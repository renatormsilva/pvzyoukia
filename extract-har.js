// extract-har.js
// Extrai SWFs, XMLs e dados AMF de um arquivo .har (HTTP Archive)
// Uso: node extract-har.js pvz-capture.har

const fs   = require('fs');
const path = require('path');

const harFile = process.argv[2] || 'pvz-capture.har';

if (!fs.existsSync(harFile)) {
  console.error(`Arquivo não encontrado: ${harFile}`);
  console.error('Uso: node extract-har.js pvz-capture.har');
  process.exit(1);
}

let harText = fs.readFileSync(harFile, 'utf8');
// Remove BOM se presente
if (harText.charCodeAt(0) === 0xFEFF) harText = harText.slice(1);
const har = JSON.parse(harText);
const entries = har.log.entries;
console.log(`\n📦 HAR: ${entries.length} entradas\n`);

const outBase = path.dirname(path.resolve(harFile));
const swfDir  = path.join(outBase, 'uilib');
const amfDir  = path.join(outBase, 'amf-cache');
const xmlDir  = path.join(outBase, 'xml');
const imgDir  = path.join(outBase, 'assets', 'pvz', 'img');
const orgDir  = path.join(outBase, 'orgs');
const iconsOrgDir  = path.join(outBase, 'swfs');
const iconsTool    = path.join(outBase, 'swfs');

[swfDir, amfDir, xmlDir, imgDir, orgDir, iconsOrgDir].forEach(d =>
  fs.mkdirSync(d, { recursive: true })
);

let swfCount = 0, amfCount = 0, xmlCount = 0, imgCount = 0;

for (const entry of entries) {
  const url      = entry.request.url;
  const method   = entry.request.method;
  const status   = entry.response.status;
  const content  = entry.response.content;
  const mime     = (content.mimeType || '').toLowerCase();

  if (status !== 200) continue;
  if (!content.text) continue;

  // Decodifica corpo da resposta
  let body;
  try {
    if (content.encoding === 'base64') {
      body = Buffer.from(content.text, 'base64');
    } else {
      body = Buffer.from(content.text, 'utf8');
    }
  } catch (e) { continue; }

  if (body.length < 4) continue;

  const urlPath = new URL(url).pathname;

  // ── SWF ──────────────────────────────────────────────────────────────────
  const isSWF = mime.includes('shockwave-flash') || urlPath.endsWith('.swf');
  if (isSWF) {
    const sig = body.slice(0, 3).toString('ascii');
    if (!['FWS', 'CWS', 'ZWS'].includes(sig)) {
      console.log(`⚠  SWF inválido (${sig}): ${urlPath}`);
      continue;
    }
    let swfName = urlPath.split('?')[0].split('/').pop();
    if (!swfName.endsWith('.swf')) swfName += '.swf';

    let destDir = swfDir;
    if (urlPath.includes('/ORGLibs/')) destDir = orgDir;
    if (urlPath.includes('/IconRes/')) destDir = iconsOrgDir;
    if (urlPath.includes('/youkia/main.swf')) destDir = swfDir;

    // Para UILibs: sempre vai para uilib/
    if (urlPath.includes('/UILibs/')) destDir = swfDir;

    const destPath = path.join(destDir, swfName);
    const exists = fs.existsSync(destPath);
    const existingSize = exists ? fs.statSync(destPath).size : 0;

    // Sobrescreve apenas se o novo for maior (real > stub)
    if (!exists || body.length > existingSize) {
      fs.mkdirSync(destDir, { recursive: true });
      fs.writeFileSync(destPath, body);
      const flag = exists ? '🔄' : '✅';
      console.log(`${flag} SWF [${(body.length/1024).toFixed(1)}KB] ${swfName}`);
      swfCount++;
    } else {
      console.log(`⏭  SWF já ok: ${swfName}`);
    }
    continue;
  }

  // ── AMF ──────────────────────────────────────────────────────────────────
  const isAMF = urlPath.includes('/pvz/amf/') || mime.includes('x-amf');
  if (isAMF && method === 'POST') {
    const ts = Date.now();
    const respPath = path.join(amfDir, `${ts}_resp.bin`);
    fs.writeFileSync(respPath, body);

    // Salva também o request AMF se disponível
    const postData = entry.request.postData;
    if (postData) {
      let reqBody;
      if (postData.encoding === 'base64') {
        reqBody = Buffer.from(postData.text, 'base64');
      } else if (postData.text) {
        reqBody = Buffer.from(postData.text, 'binary');
      }
      if (reqBody && reqBody.length > 6) {
        fs.writeFileSync(path.join(amfDir, `${ts}_req.bin`), reqBody);
      }
    }

    console.log(`📨 AMF [${body.length}b] ${urlPath}`);
    amfCount++;
    continue;
  }

  // ── XML ──────────────────────────────────────────────────────────────────
  const isXML = mime.includes('xml') || urlPath.endsWith('.xml');
  if (isXML) {
    let xmlName = urlPath.split('?')[0].split('/').pop();
    if (!xmlName.endsWith('.xml')) xmlName += '.xml';
    const destPath = path.join(xmlDir, xmlName);
    if (!fs.existsSync(destPath)) {
      fs.writeFileSync(destPath, body);
      console.log(`📄 XML [${body.length}b] ${xmlName}`);
      xmlCount++;
    }
    continue;
  }

  // ── IMAGENS ──────────────────────────────────────────────────────────────
  const isImg = mime.includes('image/') || /\.(jpg|jpeg|png|gif|webp)$/i.test(urlPath);
  if (isImg) {
    const imgName = urlPath.split('?')[0].split('/').pop();
    const destPath = path.join(imgDir, imgName);
    if (!fs.existsSync(destPath)) {
      fs.writeFileSync(destPath, body);
      console.log(`🖼  IMG [${(body.length/1024).toFixed(1)}KB] ${imgName}`);
      imgCount++;
    }
    continue;
  }
}

console.log(`\n─────────────────────────────────`);
console.log(`SWFs extraídos : ${swfCount}`);
console.log(`AMFs capturados: ${amfCount}`);
console.log(`XMLs salvos    : ${xmlCount}`);
console.log(`Imagens salvas : ${imgCount}`);

// Verifica pvz_20150415.swf
const pvzPath = path.join(swfDir, 'pvz_20150415.swf');
if (fs.existsSync(pvzPath)) {
  const sz = fs.statSync(pvzPath).size;
  console.log(`\npvz_20150415.swf: ${sz} bytes ${sz > 10000 ? '✅ REAL' : '⚠  AINDA É O STUB!'}`);
} else {
  console.log(`\n⚠  pvz_20150415.swf não encontrado!`);
  console.log(`   Faz uma sessão nova no jogo com cache limpo e captura de novo.`);
}
