// download-missing.js
// Baixa do servidor live os SWFs críticos que ainda faltam localmente.
// node download-missing.js

const https = require('https');
const http  = require('http');
const fs    = require('fs');
const path  = require('path');

const BASE = 'http://s46.youkia.pvz.youkia.com';

// SWFs que queremos garantir que temos localmente
const targets = [
  // [url_path, destino_local]
  ['/youkia/UILibs/pvz_20150415.swf',      'uilib/pvz_20150415.swf'],
  ['/youkia/UILibs/loading_2013051313.swf', 'uilib/loading_2013051313.swf'],
  ['/youkia/UILibs/firstpage_20150506.swf', 'uilib/firstpage_20150506.swf'],
  ['/youkia/UILibs/baseUI_2013070610.swf',  'uilib/baseUI_2013070610.swf'],
  ['/youkia/UILibs/number_20150416.swf',    'uilib/number_20150416.swf'],
  ['/youkia/UILibs/windows_20150316.swf',   'uilib/windows_20150316.swf'],
  ['/youkia/UILibs/tips_20150506.swf',      'uilib/tips_20150506.swf'],
  ['/youkia/UILibs/ranking_20140211.swf',   'uilib/ranking_20140211.swf'],
  ['/youkia/UILibs/vip_2013051813.swf',     'uilib/vip_2013051813.swf'],
  ['/youkia/UILibs/tree_2012042414.swf',    'uilib/tree_2012042414.swf'],
  ['/youkia/UILibs/sound_2013060514.swf',   'uilib/sound_2013060514.swf'],
  ['/youkia/UILibs/help_2015011502.swf',    'uilib/help_2015011502.swf'],
  ['/youkia/UILibs/helpBattle_2012091301.swf', 'uilib/helpBattle_2012091301.swf'],
  ['/youkia/UILibs/copyWindow_2013070811.swf', 'uilib/copyWindow_2013070811.swf'],
  ['/youkia/UILibs/qualityLight_20140212.swf', 'uilib/qualityLight_20140212.swf'],
  ['/youkia/UILibs/atlas_2013051313.swf',   'uilib/atlas_2013051313.swf'],
  ['/youkia/main.swf',                       'uilib/main.swf'],
];

function download(urlPath, dest) {
  return new Promise((resolve) => {
    const fullUrl = BASE + urlPath;
    const destPath = path.join(__dirname, dest);

    // Checa se já existe e não é o stub (>100KB = provavelmente real)
    if (fs.existsSync(destPath)) {
      const size = fs.statSync(destPath).size;
      if (size > 10000) {
        console.log(`⏭  já existe (${(size/1024).toFixed(1)}KB): ${dest}`);
        return resolve(true);
      }
      console.log(`⚠  arquivo pequeno (${size}b), vai sobrescrever: ${dest}`);
    }

    fs.mkdirSync(path.dirname(destPath), { recursive: true });

    const client = fullUrl.startsWith('https') ? https : http;
    const req = client.get(fullUrl, {
      headers: {
        'User-Agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.2; WOW64)',
        'Referer': 'http://pvz-s1.youkia.com/youkia/main.swf',
        'x-flash-version': '34,0,0,305',
      }
    }, (res) => {
      if (res.statusCode === 301 || res.statusCode === 302) {
        console.log(`↪  redirect: ${urlPath} → ${res.headers.location}`);
        return resolve(false);
      }
      if (res.statusCode !== 200) {
        console.log(`❌ ${res.statusCode}: ${urlPath}`);
        res.resume();
        return resolve(false);
      }

      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        const buf = Buffer.concat(chunks);
        // Verifica assinatura SWF
        const sig = buf.slice(0, 3).toString('ascii');
        if (!['FWS', 'CWS', 'ZWS'].includes(sig)) {
          console.log(`❌ não é SWF válido (${buf.slice(0,20).toString('ascii').trim()}): ${urlPath}`);
          return resolve(false);
        }
        fs.writeFileSync(destPath, buf);
        console.log(`✅ ${(buf.length/1024).toFixed(1)}KB → ${dest}`);
        resolve(true);
      });
    });

    req.on('error', e => {
      console.log(`❌ erro: ${urlPath} — ${e.message}`);
      resolve(false);
    });

    req.setTimeout(15000, () => {
      console.log(`⏱  timeout: ${urlPath}`);
      req.destroy();
      resolve(false);
    });
  });
}

(async () => {
  console.log('\n🔄 Baixando SWFs do servidor live...\n');
  let ok = 0, fail = 0;
  for (const [urlPath, dest] of targets) {
    const result = await download(urlPath, dest);
    if (result) ok++; else fail++;
    // Pequeno delay para não sobrecarregar
    await new Promise(r => setTimeout(r, 300));
  }
  console.log(`\n✅ ${ok} baixados, ❌ ${fail} falhas`);

  // Verifica o pvz_20150415.swf especificamente
  const pvzPath = path.join(__dirname, 'uilib/pvz_20150415.swf');
  const pvzSize = fs.existsSync(pvzPath) ? fs.statSync(pvzPath).size : 0;
  console.log(`\npvz_20150415.swf: ${pvzSize} bytes ${pvzSize > 10000 ? '✅ REAL' : '⚠ STUB AINDA'}`);
})();
