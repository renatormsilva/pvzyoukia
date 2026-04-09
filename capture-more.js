// capture-more.js
// Tenta capturar métodos AMF não capturados ainda, enviando requests genéricos.
// Útil para pegar api.reward.openbox e outros que só aparecem interagindo.
// Usage: node capture-more.js

'use strict';
const http = require('http');
const fs   = require('fs');
const path = require('path');
const zlib = require('zlib');

const AMF_CACHE = path.join(__dirname, 'amf-cache');
const SESSION   = path.join(__dirname, 'session.txt');
const cookie    = fs.existsSync(SESSION) ? fs.readFileSync(SESSION, 'utf8').trim() : '';

if (!cookie) { console.error('❌ session.txt não encontrado'); process.exit(1); }

// ── Encoder AMF0 mínimo ───────────────────────────────────────────────────────
function encodeStr(s) {
  const b = Buffer.from(s, 'utf8');
  const h = Buffer.alloc(3); h[0] = 0x02; h.writeUInt16BE(b.length, 1);
  return Buffer.concat([h, b]);
}
function encodeNull() { return Buffer.from([0x05]); }
function encodeNumber(n) {
  const b = Buffer.alloc(9); b[0] = 0x00; b.writeDoubleBE(n, 1); return b;
}
function encodeArray(items) {
  const h = Buffer.alloc(5); h[0] = 0x0A; h.writeUInt32BE(items.length, 1);
  return Buffer.concat([h, ...items]);
}

// Monta envelope AMF0 request
function buildRequest(method, params = []) {
  const targetBuf  = Buffer.from(method, 'utf8');
  const responseBuf = Buffer.from('/1', 'utf8');
  const bodyBuf     = encodeArray(params);

  const out = Buffer.alloc(
    2 + 2 + 2 +                           // version, 0 headers, 1 message
    2 + targetBuf.length +                 // target length + target
    2 + responseBuf.length +               // response length + response
    4 + bodyBuf.length                     // body length + body
  );
  let wp = 0;
  out.writeUInt16BE(0, wp); wp += 2;       // AMF version 0
  out.writeUInt16BE(0, wp); wp += 2;       // 0 headers
  out.writeUInt16BE(1, wp); wp += 2;       // 1 message
  out.writeUInt16BE(targetBuf.length, wp); wp += 2;
  targetBuf.copy(out, wp); wp += targetBuf.length;
  out.writeUInt16BE(responseBuf.length, wp); wp += 2;
  responseBuf.copy(out, wp); wp += responseBuf.length;
  out.writeInt32BE(-1, wp); wp += 4;
  bodyBuf.copy(out, wp);
  return out;
}

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
  if (!buf) return null;
  if (buf[0] === 0x1f && buf[1] === 0x8b) {
    try { return zlib.gunzipSync(buf); } catch(e) {}
  }
  if (/^[0-9a-fA-F]+\r/.test(buf.slice(0, 10).toString('ascii'))) {
    const d = decodeChunked(buf);
    if (d[0] === 0x1f && d[1] === 0x8b) { try { return zlib.gunzipSync(d); } catch(e) {} }
    return d;
  }
  return buf;
}

function postAMF(reqBuf) {
  return new Promise((resolve) => {
    const req = http.request({
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
    }, (res) => {
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => resolve(Buffer.concat(chunks)));
    });
    req.on('error', () => resolve(null));
    req.setTimeout(10000, () => { req.destroy(); resolve(null); });
    req.write(reqBuf);
    req.end();
  });
}

async function tryCapture(method, params, description) {
  const safeName = method.replace(/\./g, '_');
  const respFile = path.join(AMF_CACHE, safeName + '_resp.bin');
  if (fs.existsSync(respFile)) {
    console.log(`  ⏭  ${method} (já em cache)`);
    return;
  }

  process.stdout.write(`  📡 ${method} (${description})... `);
  const reqBuf = buildRequest(method, params);
  const raw    = await postAMF(reqBuf);
  const resp   = decodeResp(raw);

  if (!resp || resp.length < 6 || resp[0] !== 0x00) {
    console.log('❌');
    return;
  }

  fs.writeFileSync(path.join(AMF_CACHE, safeName + '_req.bin'), reqBuf);
  fs.writeFileSync(respFile, resp);
  console.log(`✅ ${resp.length}b`);
}

// ─── Lista de métodos para tentar capturar ────────────────────────────────────
// Adicione mais conforme descobrir novos métodos no jogo
async function main() {
  console.log('\n🎯 Tentando capturar métodos AMF não capturados...\n');

  const USER_ID  = encodeNumber(5049894);
  const ZERO     = encodeNumber(0);
  const ONE      = encodeNumber(1);
  const PAGE1    = encodeNumber(1);
  const NULL     = encodeNull();

  await tryCapture('api.reward.openbox',    [NULL], 'abrir caixa de recompensa');
  await tryCapture('api.reward.getList',    [NULL], 'lista de recompensas');
  await tryCapture('api.duty.getSpecial',   [NULL], 'tarefas especiais');
  await tryCapture('api.copy.getList',      [NULL], 'lista de cópias (zombie mode)');
  await tryCapture('api.copy.active.get',   [NULL], 'copias ativas');
  await tryCapture('api.genius.getInfo',    [NULL], 'genius info');
  await tryCapture('api.genius.getList',    [NULL], 'genius list');
  await tryCapture('api.rank.getArenaRank', [PAGE1], 'ranking arena pag 1');
  await tryCapture('api.rank.getOrgRank',   [PAGE1], 'ranking organismos');
  await tryCapture('api.vip.getInfo',       [NULL], 'info vip');
  await tryCapture('api.shop.getHistory',   [NULL], 'histórico de compras');
  await tryCapture('api.mail.getList',      [NULL], 'lista de emails');
  await tryCapture('api.notice.getList',    [NULL], 'notícias/avisos');
  await tryCapture('api.friend.getList',    [NULL], 'lista de amigos');
  await tryCapture('api.friend.recommend',  [NULL], 'amigos recomendados');
  await tryCapture('api.sign.getInfo',      [NULL], 'check-in info');
  await tryCapture('api.event.getList',     [NULL], 'lista de eventos');
  await tryCapture('api.territory.fight',   [NULL], 'batalha território');
  await tryCapture('api.cave.getList',      [NULL], 'lista de cavernas');
  await tryCapture('api.fuben.getList',     [NULL], 'lista de fubens');
  await tryCapture('api.serverbattle.getList', [NULL], 'batalha de servidor');

  console.log('\n✅ Concluído. Reinicie o servidor para carregar novos métodos.');
}

main();
