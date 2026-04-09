// extract-saz.js
// Extrai SWFs, XMLs e respostas AMF do arquivo .saz capturado pelo Fiddler.
// O SAZ é um ZIP com sessões HTTP salvas.
//
// Uso: node extract-saz.js pvz_capture.saz

const fs   = require('fs');
const path = require('path');
const zlib = require('zlib');

const sazFile = process.argv[2] || 'pvz_capture.saz';

if (!fs.existsSync(sazFile)) {
  console.error(`Arquivo não encontrado: ${sazFile}`);
  console.error('Uso: node extract-saz.js pvz_capture.saz');
  process.exit(1);
}

// ── Lê e parseia o ZIP (SAZ) manualmente ─────────────────────────────────────
const zip = fs.readFileSync(sazFile);

function readUInt32LE(buf, off) { return buf.readUInt32LE(off); }
function readUInt16LE(buf, off) { return buf.readUInt16LE(off); }

// Localiza todos os Local File Headers no ZIP
const entries = [];
let pos = 0;
while (pos < zip.length - 4) {
  // Local file header signature = 0x04034b50
  if (zip[pos] === 0x50 && zip[pos+1] === 0x4B &&
      zip[pos+2] === 0x03 && zip[pos+3] === 0x04) {
    const compression   = readUInt16LE(zip, pos + 8);
    const compSize      = readUInt32LE(zip, pos + 18);
    const uncompSize    = readUInt32LE(zip, pos + 22);
    const fnLen         = readUInt16LE(zip, pos + 26);
    const extraLen      = readUInt16LE(zip, pos + 28);
    const fileName      = zip.slice(pos + 30, pos + 30 + fnLen).toString('utf8');
    const dataOffset    = pos + 30 + fnLen + extraLen;

    entries.push({ fileName, compression, compSize, uncompSize, dataOffset });
    pos = dataOffset + compSize;
  } else {
    pos++;
  }
}

console.log(`\n📦 SAZ: ${entries.length} entradas encontradas\n`);

// ── Para cada entrada, tenta parsear como resposta HTTP ───────────────────────
const outBase = path.dirname(path.resolve(sazFile));
const swfDir  = path.join(outBase, 'uilib');
const amfDir  = path.join(outBase, 'amf-cache');
const xmlDir  = path.join(outBase, 'xml');
const orgDir  = path.join(outBase, 'orgs');

[swfDir, amfDir].forEach(d => fs.mkdirSync(d, { recursive: true }));

let swfCount = 0, amfCount = 0, xmlCount = 0;

for (const entry of entries) {
  if (!entry.fileName.endsWith('_c.dat') && !entry.fileName.endsWith('_s.dat')) continue;

  // Descomprime se necessário
  let data = zip.slice(entry.dataOffset, entry.dataOffset + entry.compSize);
  if (entry.compression === 8) {
    try { data = zlib.inflateRawSync(data); } catch(e) { continue; }
  }

  const text = data.toString('binary');

  // ── Extrai o corpo da resposta HTTP ──────────────────────────────────────
  // Só precisamos dos arquivos _s.dat (server response)
  if (!entry.fileName.endsWith('_s.dat')) continue;

  // Encontra fim dos headers HTTP (duplo CRLF)
  let bodyStart = -1;
  for (let i = 0; i < data.length - 3; i++) {
    if (data[i] === 0x0D && data[i+1] === 0x0A &&
        data[i+2] === 0x0D && data[i+3] === 0x0A) {
      bodyStart = i + 4;
      break;
    }
  }
  if (bodyStart < 0) continue;

  const headerText = data.slice(0, bodyStart).toString('ascii');
  const body       = data.slice(bodyStart);

  // Detecta tipo pelo Content-Type e URL (no _c.dat correspondente)
  const sessionNum = entry.fileName.replace('_s.dat', '');
  const reqFile    = sessionNum + '_c.dat';
  const reqEntry   = entries.find(e => e.fileName === reqFile);
  let reqUrl = '';
  let reqMethod = 'GET';
  if (reqEntry) {
    let reqData = zip.slice(reqEntry.dataOffset, reqEntry.dataOffset + reqEntry.compSize);
    if (reqEntry.compression === 8) {
      try { reqData = zlib.inflateRawSync(reqData); } catch(e) { reqData = Buffer.alloc(0); }
    }
    const firstLine = reqData.toString('ascii', 0, 200).split('\r\n')[0];
    const m = firstLine.match(/^(\w+)\s+(\S+)/);
    if (m) { reqMethod = m[1]; reqUrl = m[2]; }
  }

  const isSwf = headerText.includes('application/x-shockwave-flash') ||
                reqUrl.endsWith('.swf') || reqUrl.includes('.swf?');
  const isAmf = reqUrl.includes('/pvz/amf/') || reqMethod === 'POST';
  const isXml = headerText.includes('application/xml') ||
                headerText.includes('text/xml') ||
                reqUrl.includes('.xml');

  if (body.length < 10) continue;

  // ── SWF ──────────────────────────────────────────────────────────────────
  if (isSwf && body.length > 100) {
    // Verifica assinatura SWF real
    const sig = body.slice(0, 3).toString('ascii');
    if (!['FWS', 'CWS', 'ZWS'].includes(sig)) continue;

    // Extrai nome do arquivo da URL
    let swfName = reqUrl.split('?')[0].split('/').pop();
    if (!swfName.endsWith('.swf')) swfName += '.swf';

    // Determina pasta de destino
    let destDir = swfDir;
    if (reqUrl.includes('/ORGLibs/'))  destDir = orgDir;
    if (reqUrl.includes('/IconRes/'))  {
      // Salva em swfs/ com nome numérico
      destDir = path.join(outBase, 'swfs');
    }
    fs.mkdirSync(destDir, { recursive: true });

    const destPath = path.join(destDir, swfName);
    fs.writeFileSync(destPath, body);
    console.log(`✅ SWF [${body.length}b] ${swfName}  ← ${reqUrl.split('youkia.com')[1]?.slice(0,60) || reqUrl.slice(-60)}`);
    swfCount++;
  }

  // ── AMF ──────────────────────────────────────────────────────────────────
  if (isAmf && body.length > 6) {
    const num = entry.fileName.split('/').pop().replace('_s.dat','');

    // Salva resposta AMF
    const amfRespPath = path.join(amfDir, `${num}_resp.bin`);
    fs.writeFileSync(amfRespPath, body);

    // Salva request AMF correspondente
    if (reqEntry) {
      let reqData = zip.slice(reqEntry.dataOffset, reqEntry.dataOffset + reqEntry.compSize);
      if (reqEntry.compression === 8) {
        try { reqData = zlib.inflateRawSync(reqData); } catch(e) { reqData = Buffer.alloc(0); }
      }
      // Corpo do request (depois dos headers)
      let reqBodyStart = -1;
      for (let i = 0; i < reqData.length - 3; i++) {
        if (reqData[i] === 0x0D && reqData[i+1] === 0x0A &&
            reqData[i+2] === 0x0D && reqData[i+3] === 0x0A) {
          reqBodyStart = i + 4;
          break;
        }
      }
      if (reqBodyStart >= 0) {
        const reqBody = reqData.slice(reqBodyStart);
        if (reqBody.length > 6) {
          fs.writeFileSync(path.join(amfDir, `${num}_req.bin`), reqBody);
        }
      }
    }

    console.log(`📨 AMF [${body.length}b] sessão ${num}`);
    amfCount++;
  }

  // ── XML ──────────────────────────────────────────────────────────────────
  if (isXml && body.length > 10) {
    let xmlName = reqUrl.split('?')[0].split('/').pop();
    if (!xmlName.endsWith('.xml')) xmlName += '.xml';
    const destPath = path.join(xmlDir, xmlName);
    if (!fs.existsSync(destPath)) {
      fs.writeFileSync(destPath, body);
      console.log(`📄 XML [${body.length}b] ${xmlName}`);
      xmlCount++;
    }
  }
}

console.log(`\n─────────────────────────────────`);
console.log(`SWFs extraídos : ${swfCount}`);
console.log(`AMFs capturados: ${amfCount}`);
console.log(`XMLs salvos    : ${xmlCount}`);
console.log(`\nSWFs → uilib/   AMF → amf-cache/   XML → xml/`);

// ── Mostra SWFs críticos ──────────────────────────────────────────────────────
const critical = ['pvz_', 'main.swf', 'loading_', 'firstpage_', 'baseUI_', 'number_'];
const found = fs.readdirSync(swfDir).filter(f => critical.some(c => f.includes(c)));
if (found.length) {
  console.log(`\n⭐ SWFs críticos encontrados em uilib/:`);
  found.forEach(f => console.log(`   ${f}`));
} else {
  console.log(`\n⚠  Nenhum SWF crítico encontrado em uilib/`);
  console.log(`   Verifique se o SAZ inclui as sessões iniciais (main.swf, pvz_*.swf)`);
}
