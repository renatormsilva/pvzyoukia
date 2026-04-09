// download-uilib2.js
// Baixa as UILibs que faltam do servidor original e copia pvz_20150415.swf
// para o lugar certo.
//
// EXECUTE ANTES DE INICIAR O SERVIDOR:
//   node download-uilib2.js

const fs   = require('fs');
const http = require('http');
const path = require('path');

const BASE = 'http://s46.youkia.pvz.youkia.com';

// ── UILibs faltantes (buscadas em uilib/) ────────────────────────────────────
const UILIB_DIR  = path.join(__dirname, 'uilib');
const ORGS_DIR   = path.join(__dirname, 'orgs');

const downloads = [
  // CRÍTICA: loading_2013051313.swf — sem ela o jogo trava na tela branca
  { url: `${BASE}/youkia/UILibs/loading_2013051313.swf`,               dest: path.join(UILIB_DIR, 'loading_2013051313.swf') },

  // UILibs do config.xml
  { url: `${BASE}/youkia/UILibs/number_20150416.swf`,                  dest: path.join(UILIB_DIR, 'number_20150416.swf') },
  { url: `${BASE}/youkia/UILibs/help_2015011502.swf`,                  dest: path.join(UILIB_DIR, 'help_2015011502.swf') },
  { url: `${BASE}/youkia/UILibs/tips_20150506.swf`,                    dest: path.join(UILIB_DIR, 'tips_20150506.swf') },
  { url: `${BASE}/youkia/UILibs/windows_20150316.swf`,                 dest: path.join(UILIB_DIR, 'windows_20150316.swf') },
  { url: `${BASE}/youkia/UILibs/qualityLight_20140212.swf`,            dest: path.join(UILIB_DIR, 'qualityLight_20140212.swf') },
  { url: `${BASE}/youkia/UILibs/baseUI_2013070610.swf`,                dest: path.join(UILIB_DIR, 'baseUI_2013070610.swf') },
  { url: `${BASE}/youkia/UILibs/firstpage_20150506.swf`,               dest: path.join(UILIB_DIR, 'firstpage_20150506.swf') },
  { url: `${BASE}/youkia/UILibs/vip_2013051813.swf`,                   dest: path.join(UILIB_DIR, 'vip_2013051813.swf') },
  { url: `${BASE}/youkia/UILibs/helpBattle_2012091301.swf`,            dest: path.join(UILIB_DIR, 'helpBattle_2012091301.swf') },
  { url: `${BASE}/youkia/UILibs/sound_2013060514.swf`,                 dest: path.join(UILIB_DIR, 'sound_2013060514.swf') },

  // Genius (subpasta)
  { url: `${BASE}/youkia/UILibs/genius/geniusEffect_2013042216.swf`,  dest: path.join(UILIB_DIR, 'genius', 'geniusEffect_2013042216.swf') },

  // ORGLibs de tutorial
  { url: `${BASE}/youkia/ORGLibs/orghelp_2012122502.swf`,             dest: path.join(ORGS_DIR, 'orghelp_2012122502.swf') },
  { url: `${BASE}/youkia/ORGLibs/org_default_2012082801.swf`,         dest: path.join(ORGS_DIR, 'org_default_2012082801.swf') },
];

// ── Copia pvz_20150415.swf de swfs/ para uilib/ (se ainda não foi) ───────────
const pvzSrc  = path.join(__dirname, 'swfs', 'pvz_20150415.swf');
const pvzDest = path.join(UILIB_DIR, 'pvz_20150415.swf');
if (fs.existsSync(pvzSrc) && !fs.existsSync(pvzDest)) {
  fs.copyFileSync(pvzSrc, pvzDest);
  console.log('✅ Copiado: swfs/pvz_20150415.swf → uilib/pvz_20150415.swf');
} else if (fs.existsSync(pvzDest)) {
  console.log('⏭  pvz_20150415.swf já existe em uilib/');
} else {
  console.log('⚠  pvz_20150415.swf não encontrado em swfs/ — verifique');
}

// ── Cria subpastas necessárias ────────────────────────────────────────────────
[
  path.join(UILIB_DIR, 'genius'),
].forEach(d => { if (!fs.existsSync(d)) fs.mkdirSync(d, { recursive: true }); });

// ── Download ──────────────────────────────────────────────────────────────────
const total = downloads.length;
let done = 0;

function report(label, file, extra) {
  done++;
  console.log(`${label} [${done}/${total}] ${path.basename(file)}${extra || ''}`);
}

downloads.forEach((item, i) => {
  setTimeout(() => {
    if (fs.existsSync(item.dest)) {
      const size = fs.statSync(item.dest).size;
      if (size > 100) { report('⏭ ', item.dest, ` (já existe, ${size} bytes)`); return; }
      // arquivo existe mas está vazio/corrompido — re-baixa
      fs.unlinkSync(item.dest);
    }

    const out = fs.createWriteStream(item.dest);
    const req = http.get(item.url, res => {
      if (res.statusCode !== 200) {
        res.resume();
        out.close();
        fs.unlink(item.dest, () => {});
        report('❌', item.dest, ` (HTTP ${res.statusCode})`);
        return;
      }
      res.pipe(out);
      out.on('finish', () => {
        const size = fs.statSync(item.dest).size;
        if (size < 100) {
          report('⚠ ', item.dest, ` (${size} bytes — suspeito)`);
        } else {
          report('✅', item.dest, ` (${size} bytes)`);
        }
      });
    });
    req.on('error', err => {
      out.close();
      fs.unlink(item.dest, () => {});
      report('❌', item.dest, ` (${err.message})`);
    });
  }, i * 600);
});

console.log(`\n⬇  Baixando ${total} arquivos do servidor original…\n`);
