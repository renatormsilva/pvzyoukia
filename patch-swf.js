// patch-swf.js
// Patcha main.swf para fazer upDateTask() retornar imediatamente,
// corrigindo o loading infinito causado por NetConnection que Ruffle não suporta.
//
// Uso: node patch-swf.js [arquivo_entrada.swf]
// Exemplo: node patch-swf.js uilib/main_urlloader.swf

'use strict';
const fs   = require('fs');
const zlib = require('zlib');
const path = require('path');

const SWF_IN  = process.argv[2]
  ? path.resolve(process.argv[2])
  : path.join(__dirname, 'uilib', 'main.swf');
const SWF_OUT = SWF_IN.replace(/\.swf$/i, '_patched.swf');

// ── Varuint30 ─────────────────────────────────────────────────────────────────
function readU30(buf, off) {
  let v = 0, shift = 0, size = 0;
  while (size < 5) {
    const b = buf[off + size++];
    v |= (b & 0x7F) << shift;
    if (!(b & 0x80)) break;
    shift += 7;
  }
  return { v, size };
}
function skipU30(buf, off) {
  return off + readU30(buf, off).size;
}

// ── ABC Constant Pool Parser ──────────────────────────────────────────────────
// Returns { off, strings[], multinames[] }
function parseConstantPool(buf, off) {
  let r;

  // ints
  r = readU30(buf, off); off += r.size;
  for (let i = 1; i < r.v; i++) off = skipU30(buf, off);

  // uints
  r = readU30(buf, off); off += r.size;
  for (let i = 1; i < r.v; i++) off = skipU30(buf, off);

  // doubles
  r = readU30(buf, off); off += r.size;
  off += Math.max(0, r.v - 1) * 8;

  // strings
  r = readU30(buf, off); off += r.size;
  const strCount = r.v;
  const strings = [''];
  for (let i = 1; i < strCount; i++) {
    const len = readU30(buf, off); off += len.size;
    strings.push(buf.slice(off, off + len.v).toString('utf8'));
    off += len.v;
  }

  // namespaces
  r = readU30(buf, off); off += r.size;
  for (let i = 1; i < r.v; i++) {
    off++;               // kind byte
    off = skipU30(buf, off); // name index
  }

  // ns_sets
  r = readU30(buf, off); off += r.size;
  for (let i = 1; i < r.v; i++) {
    const cnt = readU30(buf, off); off += cnt.size;
    for (let j = 0; j < cnt.v; j++) off = skipU30(buf, off);
  }

  // multinames
  r = readU30(buf, off); off += r.size;
  const mnCount = r.v;
  const multinames = [null]; // index 0 = '*'
  for (let i = 1; i < mnCount; i++) {
    const kind = buf[off++];
    let name = null;
    switch (kind) {
      case 0x07: case 0x0D: // QName, QNameA
        off = skipU30(buf, off);           // ns
        { const nr = readU30(buf, off); off += nr.size; name = strings[nr.v]; }
        break;
      case 0x0F: case 0x10: // RTQName, RTQNameA
        off = skipU30(buf, off);
        break;
      case 0x11: case 0x12: // RTQNameL, RTQNameLA
        break;
      case 0x09: case 0x0E: // Multiname, MultinameA
        { const nr = readU30(buf, off); off += nr.size; name = strings[nr.v]; }
        off = skipU30(buf, off);           // ns_set
        break;
      case 0x1B: case 0x1C: // MultinameL, MultinameLA
        off = skipU30(buf, off);
        break;
      case 0x1D: { // TypeName (generic, e.g. Vector.<T>)
        off = skipU30(buf, off);           // type name multiname
        const pc = readU30(buf, off); off += pc.size;
        for (let j = 0; j < pc.v; j++) off = skipU30(buf, off);
        break;
      }
      default:
        throw new Error(`Unknown multiname kind 0x${kind.toString(16)} at ABC offset ${off - 1}`);
    }
    multinames.push(name);
  }

  return { off, strings, multinames };
}

// ── Skip one method_info record ──────────────────────────────────────────────
function skipMethodInfo(buf, off) {
  const paramCount = readU30(buf, off); off += paramCount.size;
  off = skipU30(buf, off); // return_type
  for (let i = 0; i < paramCount.v; i++) off = skipU30(buf, off); // param types
  off = skipU30(buf, off); // name
  const flags = buf[off++];
  if (flags & 0x08) { // HAS_OPTIONAL
    const optCnt = readU30(buf, off); off += optCnt.size;
    for (let i = 0; i < optCnt.v; i++) { off = skipU30(buf, off); off++; }
  }
  if (flags & 0x80) { // HAS_PARAM_NAMES
    for (let i = 0; i < paramCount.v; i++) off = skipU30(buf, off);
  }
  return off;
}

// ── Read/skip one trait ──────────────────────────────────────────────────────
// If multinames provided, returns { off, name, methodIdx } for method traits
function readTrait(buf, off, multinames) {
  const nameR = readU30(buf, off); off += nameR.size;
  const name = multinames ? (multinames[nameR.v] || null) : null;
  const kindFlags = buf[off++];
  const kind = kindFlags & 0x0F;
  let methodIdx = -1;
  switch (kind) {
    case 0: case 6: { // slot, const
      off = skipU30(buf, off); // slot_id
      off = skipU30(buf, off); // type_name
      const vi = readU30(buf, off); off += vi.size;
      if (vi.v !== 0) off++; // vkind
      break;
    }
    case 1: case 2: case 3: { // method, getter, setter
      off = skipU30(buf, off); // disp_id
      const mi = readU30(buf, off); off += mi.size;
      methodIdx = mi.v;
      break;
    }
    case 4: { // class
      off = skipU30(buf, off);
      off = skipU30(buf, off);
      break;
    }
    case 5: { // function
      off = skipU30(buf, off);
      off = skipU30(buf, off);
      break;
    }
    default:
      throw new Error(`Unknown trait kind ${kind} at offset ${off}`);
  }
  if (kindFlags & 0x40) { // ATTR_Metadata
    const mc = readU30(buf, off); off += mc.size;
    for (let i = 0; i < mc.v; i++) off = skipU30(buf, off);
  }
  return { off, name, methodIdx };
}

// ── Main ABC patcher ──────────────────────────────────────────────────────────
function patchABC(abc, targetClass, targetMethods) {
  let off = 4; // skip u16 minor + u16 major version

  // Parse constant pool
  const cp = parseConstantPool(abc, off);
  off = cp.off;
  const { strings, multinames } = cp;

  process.stdout.write(`    ABC: ${strings.length} strings, ${multinames.length} multinames\n`);

  // Check targets exist
  for (const m of targetMethods) {
    if (!strings.includes(m)) {
      process.stdout.write(`    ⚠  String "${m}" NOT found in this ABC\n`);
    }
  }

  // ── Method infos ────────────────────────────────────────────────────────────
  const mCnt = readU30(abc, off); off += mCnt.size;
  process.stdout.write(`    Methods: ${mCnt.v}\n`);
  for (let i = 0; i < mCnt.v; i++) off = skipMethodInfo(abc, off);

  // ── Metadata ────────────────────────────────────────────────────────────────
  const mdCnt = readU30(abc, off); off += mdCnt.size;
  for (let i = 0; i < mdCnt.v; i++) {
    off = skipU30(abc, off);
    const ic = readU30(abc, off); off += ic.size;
    for (let j = 0; j < ic.v; j++) { off = skipU30(abc, off); off = skipU30(abc, off); }
  }

  // ── Instance info (class definitions) ───────────────────────────────────────
  const classCnt = readU30(abc, off); off += classCnt.size;
  process.stdout.write(`    Classes: ${classCnt.v}\n`);

  const foundMethods = {}; // methodName → method index

  for (let c = 0; c < classCnt.v; c++) {
    const nameR = readU30(abc, off); off += nameR.size;
    const className = multinames[nameR.v] || '';
    off = skipU30(abc, off); // super_name
    const flags = abc[off++];
    if (flags & 0x08) off = skipU30(abc, off); // protected_ns
    const intfCnt = readU30(abc, off); off += intfCnt.size;
    for (let i = 0; i < intfCnt.v; i++) off = skipU30(abc, off);
    off = skipU30(abc, off); // iinit

    const traitCnt = readU30(abc, off); off += traitCnt.size;
    for (let t = 0; t < traitCnt.v; t++) {
      const tr = readTrait(abc, off, multinames);
      off = tr.off;
      if (className === targetClass && tr.methodIdx >= 0 && targetMethods.includes(tr.name)) {
        foundMethods[tr.name] = tr.methodIdx;
        process.stdout.write(`    ✓ ${className}.${tr.name} → method #${tr.methodIdx}\n`);
      }
    }
  }

  // ── Class info (static traits) ───────────────────────────────────────────────
  for (let c = 0; c < classCnt.v; c++) {
    off = skipU30(abc, off); // cinit
    const traitCnt = readU30(abc, off); off += traitCnt.size;
    for (let t = 0; t < traitCnt.v; t++) off = readTrait(abc, off, null).off;
  }

  // ── Scripts ─────────────────────────────────────────────────────────────────
  const scriptCnt = readU30(abc, off); off += scriptCnt.size;
  for (let s = 0; s < scriptCnt.v; s++) {
    off = skipU30(abc, off);
    const tc = readU30(abc, off); off += tc.size;
    for (let t = 0; t < tc.v; t++) off = readTrait(abc, off, null).off;
  }

  if (Object.keys(foundMethods).length === 0) {
    process.stdout.write(`    ⚠  Nenhum método alvo encontrado na classe "${targetClass}"\n`);
    return false;
  }

  // ── Method bodies ────────────────────────────────────────────────────────────
  const bodyCnt = readU30(abc, off); off += bodyCnt.size;
  process.stdout.write(`    Method bodies: ${bodyCnt.v}\n`);

  let patched = 0;
  for (let b = 0; b < bodyCnt.v; b++) {
    const mi = readU30(abc, off); off += mi.size; // method index
    off = skipU30(abc, off); // max_stack
    off = skipU30(abc, off); // local_count
    off = skipU30(abc, off); // init_scope_depth
    off = skipU30(abc, off); // max_scope_depth

    const codeLenR = readU30(abc, off); off += codeLenR.size;
    const codeStart = off;
    const codeLen   = codeLenR.v;
    off += codeLen;

    // Check if this is one of our target method bodies
    for (const [mName, mIdx] of Object.entries(foundMethods)) {
      if (mi.v === mIdx) {
        process.stdout.write(`    ✓ Patching ${mName} (body #${b}): ${codeLen} bytes code\n`);
        if (codeLen === 0) {
          process.stdout.write(`      ⚠  Código vazio, pulando\n`);
          break;
        }
        // Fill with NOPs (0x02) then returnvoid (0x47) at end
        for (let i = codeStart; i < codeStart + codeLen - 1; i++) abc[i] = 0x02;
        abc[codeStart + codeLen - 1] = 0x47;
        patched++;
        break;
      }
    }

    // Skip exceptions
    const excCnt = readU30(abc, off); off += excCnt.size;
    for (let e = 0; e < excCnt.v; e++) {
      off = skipU30(abc, off); off = skipU30(abc, off); off = skipU30(abc, off);
      off = skipU30(abc, off); off = skipU30(abc, off);
    }
    // Skip method body traits
    const tbCnt = readU30(abc, off); off += tbCnt.size;
    for (let t = 0; t < tbCnt.v; t++) off = readTrait(abc, off, null).off;
  }

  return patched > 0;
}

// ── SWF tag iterator ──────────────────────────────────────────────────────────
function iterateSWFTags(body, cb) {
  const nbits = (body[0] >> 3) & 0x1F;
  let pos = Math.ceil((5 + 4 * nbits) / 8) + 4;
  while (pos < body.length) {
    const rec = body.readUInt16LE(pos);
    const type = rec >> 6;
    let len = rec & 0x3F;
    let hSize = 2;
    if (len === 0x3F) { len = body.readInt32LE(pos + 2); hSize = 6; }
    cb(type, pos, hSize, pos + hSize, len);
    if (type === 0) break;
    pos += hSize + len;
  }
}

// ── Entry point ───────────────────────────────────────────────────────────────
function main() {
  console.log(`\n🔧 Patching ${path.basename(SWF_IN)} ...\n`);

  const raw = fs.readFileSync(SWF_IN);
  const sig = raw.slice(0, 3).toString('ascii');
  if (!['CWS', 'FWS'].includes(sig)) {
    console.error('LZMA (ZWS) não suportado'); process.exit(1);
  }

  const body = Buffer.from(sig === 'CWS' ? zlib.inflateSync(raw.slice(8)) : raw.slice(8));
  console.log(`  Descomprimido: ${body.length} bytes`);

  let patchedAny = false;

  iterateSWFTags(body, (type, hOff, hSize, dataOff, dataLen) => {
    if (type !== 82 && type !== 72) return; // not DoABC
    console.log(`  DoABC tag @${hOff}, dataLen=${dataLen}`);

    // Parse past flags(4) + null-terminated name
    let abcStart = dataOff + 4;
    if (type === 82) { // DoABC has flags + name
      while (abcStart < dataOff + dataLen && body[abcStart] !== 0) abcStart++;
      abcStart++; // skip null terminator
    }
    const abcEnd = dataOff + dataLen;
    const abcSize = abcEnd - abcStart;
    console.log(`  ABC data: offset=${abcStart}, size=${abcSize}`);

    if (abcSize < 10) return;

    // abc is a VIEW into body (modifications affect body!)
    const abc = body.slice(abcStart, abcEnd);

    try {
      const ok1 = patchABC(abc, 'Firstpage', ['upDateTask', 'upCopyAcitvtyStaus']);
      const ok2 = patchABC(abc, 'PlantsVsZombies', ['upDateTask']);
      if (ok1 || ok2) patchedAny = true;
    } catch(e) {
      console.log(`  ⚠  patchABC error: ${e.message}`);
    }
  });

  if (!patchedAny) {
    console.error('\n❌ Patch falhou — método não encontrado em nenhum DoABC');
    process.exit(1);
  }

  // Recompress
  const header = Buffer.from(raw.slice(0, 8));
  header.writeUInt32LE(8 + body.length, 4); // uncompressed total size
  const compBody = sig === 'CWS' ? zlib.deflateSync(body, { level: 6 }) : body;
  const out = Buffer.concat([header, compBody]);
  fs.writeFileSync(SWF_OUT, out);
  console.log(`\n✅ Salvo: ${SWF_OUT} (${out.length} bytes)`);
  console.log('💡 Substitua main.swf pelo arquivo patched para usar.');
}

main();
