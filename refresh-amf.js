// refresh-amf.js
// Re-fetches all AMF responses from the real server using the saved session cookie.
// Run this to update stale cached data (shop pages, arena list, etc.)
// Usage: node refresh-amf.js [method_filter]
// Examples:
//   node refresh-amf.js              (refresh all)
//   node refresh-amf.js shop         (refresh only methods containing "shop")

'use strict';
const http = require('http');
const fs   = require('fs');
const path = require('path');
const zlib = require('zlib');

const AMF_CACHE = path.join(__dirname, 'amf-cache');
const SESSION   = path.join(__dirname, 'session.txt');

const cookie = fs.existsSync(SESSION) ? fs.readFileSync(SESSION, 'utf8').trim() : '';
if (!cookie) { console.error('❌ session.txt não encontrado ou vazio'); process.exit(1); }

const filter = process.argv[2] || '';

// ── Decode chunked + gzip (mesmo do server.js) ────────────────────────────────
function decodeChunked(buf) {
  const result = [];
  let off = 0;
  while (off < buf.length) {
    const lineEnd = buf.indexOf('\r\n', off);
    if (lineEnd < 0) break;
    const sizeHex = buf.slice(off, lineEnd).toString('ascii').trim().split(';')[0];
    off = lineEnd + 2;
    const size = parseInt(sizeHex, 16);
    if (isNaN(size) || size === 0) break;
    result.push(buf.slice(off, off + size));
    off += size + 2;
  }
  return result.length > 0 ? Buffer.concat(result) : buf;
}

function decodeResp(buf) {
  if (buf[0] === 0x1f && buf[1] === 0x8b) {
    try { return zlib.gunzipSync(buf); } catch(e) {}
  }
  if (/^[0-9a-fA-F]+\r/.test(buf.slice(0, 10).toString('ascii'))) {
    const decoded = decodeChunked(buf);
    if (decoded[0] === 0x1f && decoded[1] === 0x8b) {
      try { return zlib.gunzipSync(decoded); } catch(e) {}
    }
    return decoded;
  }
  return buf;
}

// ── POST AMF to real server ───────────────────────────────────────────────────
function postAMF(reqBuf) {
  return new Promise((resolve) => {
    const options = {
      hostname: 's46.youkia.pvz.youkia.com',
      path:     '/pvz/amf/',
      method:   'POST',
      headers: {
        'Content-Type':   'application/x-amf',
        'Content-Length': reqBuf.length,
        'User-Agent':     'Mozilla/5.0',
        'Referer':        'http://s46.youkia.pvz.youkia.com/',
        'Cookie':         cookie
      }
    };
    const req = http.request(options, (res) => {
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => resolve(Buffer.concat(chunks)));
    });
    req.on('error', () => resolve(null));
    req.setTimeout(12000, () => { req.destroy(); resolve(null); });
    req.write(reqBuf);
    req.end();
  });
}

// ── Main ──────────────────────────────────────────────────────────────────────
async function main() {
  const files = fs.readdirSync(AMF_CACHE)
    .filter(f => f.endsWith('_req.bin'))
    .filter(f => !filter || f.includes(filter))
    .sort();

  if (files.length === 0) {
    console.log('Nenhum arquivo _req.bin encontrado' + (filter ? ` com filtro "${filter}"` : ''));
    process.exit(0);
  }

  console.log(`\n🔄 Refreshing ${files.length} métodos AMF do servidor real...\n`);

  let ok = 0, fail = 0;

  for (const f of files) {
    const stem   = f.replace('_req.bin', '');
    const method = stem.replace(/_/g, '.'); // api_shop_init → api.shop.init (approx)
    const reqBuf = fs.readFileSync(path.join(AMF_CACHE, f));

    process.stdout.write(`  ${method.padEnd(40)} `);

    const rawResp = await postAMF(reqBuf);
    if (!rawResp || rawResp.length < 6) {
      console.log('❌ sem resposta');
      fail++;
      await new Promise(r => setTimeout(r, 500));
      continue;
    }

    const resp = decodeResp(rawResp);
    if (resp[0] !== 0x00 || resp[1] !== 0x00) {
      console.log(`❌ resposta inválida (${rawResp.length}b raw, ${resp.length}b decoded)`);
      fail++;
      await new Promise(r => setTimeout(r, 300));
      continue;
    }

    const respFile = path.join(AMF_CACHE, stem + '_resp.bin');
    const oldSize  = fs.existsSync(respFile) ? fs.statSync(respFile).size : 0;
    fs.writeFileSync(respFile, resp);
    console.log(`✅ ${resp.length}b (era ${oldSize}b)`);
    ok++;

    await new Promise(r => setTimeout(r, 200));
  }

  console.log(`\n✅ ${ok} atualizados, ❌ ${fail} falharam`);
  if (ok > 0) console.log('\n💡 Reinicie o servidor para carregar os dados novos.');
}

main();
