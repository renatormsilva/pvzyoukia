// download-icons.js
// Baixa IconOrg e IconTool para pastas separadas, com cookie de sessão.
// node download-icons.js [min] [max]
// Exemplo: node download-icons.js 1 700

'use strict';
const http = require('http');
const fs   = require('fs');
const path = require('path');

const BASE    = 'http://s46.youkia.pvz.youkia.com';
const COOKIE  = fs.existsSync(path.join(__dirname, 'session.txt'))
  ? fs.readFileSync(path.join(__dirname, 'session.txt'), 'utf8').trim()
  : '';
const HEADERS = {
  'User-Agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.2; WOW64)',
  ...(COOKIE ? { Cookie: COOKIE } : {})
};

const iconOrgDir  = path.join(__dirname, 'swfs', 'iconorg');
const iconToolDir = path.join(__dirname, 'swfs', 'icontool');
[iconOrgDir, iconToolDir].forEach(d => fs.mkdirSync(d, { recursive: true }));

const MIN = parseInt(process.argv[2] || '1',   10);
const MAX = parseInt(process.argv[3] || '700',  10);

function download(urlPath, destPath) {
  return new Promise((resolve) => {
    if (fs.existsSync(destPath) && fs.statSync(destPath).size > 100) return resolve('skip');
    const req = http.get(BASE + urlPath, { headers: HEADERS }, (res) => {
      if (res.statusCode === 404) { res.resume(); return resolve('404'); }
      if (res.statusCode !== 200) { res.resume(); return resolve('err' + res.statusCode); }
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        const buf = Buffer.concat(chunks);
        if (!['FWS', 'CWS', 'ZWS'].includes(buf.slice(0, 3).toString('ascii'))) return resolve('bad');
        fs.writeFileSync(destPath, buf);
        resolve('ok');
      });
    });
    req.on('error', () => resolve('err'));
    req.setTimeout(10000, () => { req.destroy(); resolve('timeout'); });
  });
}

async function run() {
  let ok = 0, skip = 0, miss = 0;

  console.log(`\n🌸 IconOrg (${MIN} → ${MAX})...`);
  for (let i = MIN; i <= MAX; i++) {
    const r = await download(`/youkia/IconRes/IconOrg/${i}.swf`, path.join(iconOrgDir, `${i}.swf`));
    if (r === 'ok')   { process.stdout.write('✓'); ok++; }
    else if (r === 'skip') { process.stdout.write('.'); skip++; }
    else if (r === '404')  { process.stdout.write(' '); miss++; }
    else                   { process.stdout.write('x'); }
    if (i % 50 === 0) process.stdout.write(` ${i}\n`);
    await new Promise(r => setTimeout(r, 60));
  }

  console.log(`\n\n🔧 IconTool (${MIN} → ${MAX})...`);
  ok = skip = miss = 0;
  for (let i = MIN; i <= MAX; i++) {
    const r = await download(`/youkia/IconRes/IconTool/${i}.swf`, path.join(iconToolDir, `${i}.swf`));
    if (r === 'ok')   { process.stdout.write('✓'); ok++; }
    else if (r === 'skip') { process.stdout.write('.'); skip++; }
    else if (r === '404')  { process.stdout.write(' '); miss++; }
    else                   { process.stdout.write('x'); }
    if (i % 50 === 0) process.stdout.write(` ${i}\n`);
    await new Promise(r => setTimeout(r, 60));
  }

  console.log(`\n\n✅ ${ok} baixados, ⏭ ${skip} já existiam, 404: ${miss}`);
}

run();
