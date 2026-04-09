'use strict';
// amf3transcode.js
// Decodes AMF3-inside-AMF0 responses (type 0x11 body) and re-encodes as pure AMF0.
// Required because Ruffle-based URLLoader Connection.as only speaks AMF0.

// ── AMF3 U29 variable-length integer ─────────────────────────────────────────
function readU29(buf, pos) {
  let v = 0;
  for (let i = 0; i < 4; i++) {
    const b = buf[pos++];
    if (i < 3) {
      v = (v << 7) | (b & 0x7F);
      if (!(b & 0x80)) break;
    } else {
      v = (v << 8) | b; // 4th byte: all 8 bits
    }
  }
  return { v, pos };
}

// ── AMF3 decoder ─────────────────────────────────────────────────────────────
function decodeAMF3(buf, startPos) {
  const strRefs = [];
  const objRefs = [];
  const traitRefs = [];

  function readStr(pos) {
    const { v: hdr, pos: p } = readU29(buf, pos);
    pos = p;
    if (!(hdr & 1)) return { v: strRefs[(hdr >> 1)] || '', pos }; // ref
    const len = hdr >> 1;
    if (len === 0) return { v: '', pos };
    const s = buf.slice(pos, pos + len).toString('utf8');
    pos += len;
    strRefs.push(s);
    return { v: s, pos };
  }

  function readVal(pos) {
    if (pos >= buf.length) return { v: null, pos };
    const type = buf[pos++];

    switch (type) {
      case 0x00: return { v: undefined, pos };
      case 0x01: return { v: null, pos };
      case 0x02: return { v: false, pos };
      case 0x03: return { v: true, pos };

      case 0x04: { // integer (29-bit signed)
        const { v, pos: p } = readU29(buf, pos);
        const signed = v >= 0x10000000 ? v - 0x20000000 : v;
        return { v: signed, pos: p };
      }

      case 0x05: { // double
        const v = buf.readDoubleBE(pos);
        return { v, pos: pos + 8 };
      }

      case 0x06: // string
        return readStr(pos);

      case 0x07: // XML document (treat as string)
      case 0x0B: { // XMLDocument
        const { v: hdr, pos: p } = readU29(buf, pos);
        pos = p;
        if (!(hdr & 1)) return { v: objRefs[hdr >> 1] || '', pos };
        const len = hdr >> 1;
        const s = buf.slice(pos, pos + len).toString('utf8');
        pos += len;
        objRefs.push(s);
        return { v: s, pos };
      }

      case 0x09: { // array
        const { v: hdr, pos: p } = readU29(buf, pos);
        pos = p;
        if (!(hdr & 1)) return { v: objRefs[hdr >> 1], pos };
        const denseCount = hdr >> 1;
        const arr = [];
        objRefs.push(arr);
        // associative portion
        while (true) {
          const { v: key, pos: kp } = readStr(pos);
          pos = kp;
          if (key === '') break;
          const { v: val, pos: vp } = readVal(pos);
          pos = vp;
          arr[key] = val;
        }
        // dense portion
        for (let i = 0; i < denseCount; i++) {
          const { v: val, pos: vp } = readVal(pos);
          pos = vp;
          arr.push(val);
        }
        return { v: arr, pos };
      }

      case 0x0A: { // object
        const { v: hdr, pos: p } = readU29(buf, pos);
        pos = p;
        if (!(hdr & 1)) return { v: objRefs[hdr >> 1], pos };

        const obj = {};
        objRefs.push(obj);

        let traits;
        if (!((hdr >> 1) & 1)) {
          // trait reference
          traits = traitRefs[hdr >> 2];
        } else {
          const isExternalizable = !!((hdr >> 2) & 1);
          const isDynamic = !!((hdr >> 3) & 1);
          const memberCount = hdr >> 4;
          const { v: className, pos: cp } = readStr(pos);
          pos = cp;
          const members = [];
          for (let i = 0; i < memberCount; i++) {
            const { v: name, pos: np } = readStr(pos);
            pos = np;
            members.push(name);
          }
          traits = { className, isExternalizable, isDynamic, members };
          traitRefs.push(traits);
          if (isExternalizable) return { v: obj, pos };
        }

        for (const name of traits.members) {
          const { v: val, pos: vp } = readVal(pos);
          pos = vp;
          obj[name] = val;
        }
        if (traits.isDynamic) {
          while (true) {
            const { v: key, pos: kp } = readStr(pos);
            pos = kp;
            if (key === '') break;
            const { v: val, pos: vp } = readVal(pos);
            pos = vp;
            obj[key] = val;
          }
        }
        return { v: obj, pos };
      }

      case 0x0C: { // ByteArray
        const { v: hdr, pos: p } = readU29(buf, pos);
        pos = p;
        if (!(hdr & 1)) return { v: objRefs[hdr >> 1], pos };
        const len = hdr >> 1;
        const bytes = buf.slice(pos, pos + len);
        pos += len;
        objRefs.push(bytes);
        return { v: bytes, pos };
      }

      default:
        return { v: null, pos };
    }
  }

  return readVal(startPos);
}

// ── AMF0 encoder ─────────────────────────────────────────────────────────────
function encodeAMF0(val) {
  const chunks = [];

  function write(v) {
    if (v === null || v === undefined) {
      chunks.push(Buffer.from([0x05]));
    } else if (typeof v === 'boolean') {
      chunks.push(Buffer.from([0x01, v ? 1 : 0]));
    } else if (typeof v === 'number') {
      const b = Buffer.allocUnsafe(9);
      b[0] = 0x00;
      b.writeDoubleBE(v, 1);
      chunks.push(b);
    } else if (Buffer.isBuffer(v)) {
      // ByteArray → encode as AMF0 string (raw bytes)
      const h = Buffer.allocUnsafe(3);
      h[0] = 0x02;
      h.writeUInt16BE(Math.min(v.length, 65535), 1);
      chunks.push(h, v.slice(0, 65535));
    } else if (typeof v === 'string') {
      const sb = Buffer.from(v, 'utf8');
      if (sb.length > 65535) {
        const h = Buffer.allocUnsafe(5);
        h[0] = 0x0C;
        h.writeUInt32BE(sb.length, 1);
        chunks.push(h, sb);
      } else {
        const h = Buffer.allocUnsafe(3);
        h[0] = 0x02;
        h.writeUInt16BE(sb.length, 1);
        chunks.push(h, sb);
      }
    } else if (Array.isArray(v)) {
      // dense array → AMF0 strict array
      const h = Buffer.allocUnsafe(5);
      h[0] = 0x0A;
      h.writeUInt32BE(v.length, 1);
      chunks.push(h);
      for (const item of v) write(item);
    } else if (typeof v === 'object') {
      chunks.push(Buffer.from([0x03])); // AMF0 anonymous object
      for (const [key, val] of Object.entries(v)) {
        if (val === undefined) continue;
        const kb = Buffer.from(key, 'utf8');
        const kh = Buffer.allocUnsafe(2);
        kh.writeUInt16BE(kb.length, 0);
        chunks.push(kh, kb);
        write(val);
      }
      chunks.push(Buffer.from([0x00, 0x00, 0x09])); // end marker
    }
  }

  write(val);
  return Buffer.concat(chunks);
}

// ── Main export: transcode an AMF response buffer ────────────────────────────
// Returns a new Buffer (pure AMF0) or null if no transcoding needed.
function transcodeAMF(responseBuf) {
  if (!responseBuf || responseBuf.length < 6) return null;

  try {
    let pos = 2; // skip version

    // skip AMF0 headers
    const hCount = responseBuf.readUInt16BE(pos); pos += 2;
    for (let h = 0; h < hCount; h++) {
      const nLen = responseBuf.readUInt16BE(pos); pos += 2 + nLen + 1;
      const vLen = responseBuf.readInt32BE(pos); pos += 4;
      if (vLen >= 0) {
        pos += vLen;
      } else {
        // unknown length header value: skip AMF0 typed value
        const vt = responseBuf[pos++];
        if (vt === 0x02) { // string
          const sLen = responseBuf.readUInt16BE(pos); pos += 2 + sLen;
        } else if (vt === 0x05 || vt === 0x01) {
          // null/undefined: no extra bytes
        }
      }
    }

    const mCount = responseBuf.readUInt16BE(pos); pos += 2;
    if (mCount < 1) return null;

    // read target URI (e.g. "/1/onResult")
    const tLen = responseBuf.readUInt16BE(pos); pos += 2;
    const target = responseBuf.slice(pos, pos + tLen).toString(); pos += tLen;

    // read response URI
    const rLen = responseBuf.readUInt16BE(pos); pos += 2;
    const respUri = responseBuf.slice(pos, pos + rLen).toString(); pos += rLen;

    pos += 4; // skip body length

    // check body type
    if (responseBuf[pos] !== 0x11) return null; // not AMF3 → no transcoding needed
    pos++; // skip 0x11 marker

    // decode AMF3 body
    const { v: decoded } = decodeAMF3(responseBuf, pos);

    // re-encode as AMF0
    const bodyBuf = encodeAMF0(decoded);

    const targetBuf = Buffer.from(target, 'utf8');
    const respBuf   = Buffer.from(respUri, 'utf8');

    const out = Buffer.allocUnsafe(6 + 2 + targetBuf.length + 2 + respBuf.length + 4 + bodyBuf.length);
    let wp = 0;
    out.writeUInt16BE(0, wp); wp += 2;      // AMF0 version
    out.writeUInt16BE(0, wp); wp += 2;      // 0 headers
    out.writeUInt16BE(1, wp); wp += 2;      // 1 message
    out.writeUInt16BE(targetBuf.length, wp); wp += 2;
    targetBuf.copy(out, wp); wp += targetBuf.length;
    out.writeUInt16BE(respBuf.length, wp); wp += 2;
    respBuf.copy(out, wp); wp += respBuf.length;
    out.writeInt32BE(-1, wp); wp += 4;      // body length unknown
    bodyBuf.copy(out, wp);

    return out;
  } catch (e) {
    return null; // parse error → return null → caller sends original
  }
}

module.exports = { transcodeAMF };
