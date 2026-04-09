// download-bulk.js
// Baixa em bulk todos os ORGLibs e IconRes do servidor live.
// node download-bulk.js

const http = require('http');
const fs   = require('fs');
const path = require('path');

const BASE    = 'http://s46.youkia.pvz.youkia.com';
const HEADERS = { 'User-Agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.2; WOW64)' };

const orgDir      = path.join(__dirname, 'orgs');
const iconsOrgDir = path.join(__dirname, 'swfs');
const iconsToolDir= path.join(__dirname, 'swfs');
[orgDir, iconsOrgDir].forEach(d => fs.mkdirSync(d, { recursive: true }));

function download(urlPath, destPath) {
  return new Promise((resolve) => {
    if (fs.existsSync(destPath) && fs.statSync(destPath).size > 500) {
      return resolve('skip');
    }
    const req = http.get(BASE + urlPath, { headers: HEADERS }, (res) => {
      if (res.statusCode === 404) { res.resume(); return resolve('404'); }
      if (res.statusCode !== 200) { res.resume(); return resolve('err' + res.statusCode); }
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        const buf = Buffer.concat(chunks);
        const sig = buf.slice(0, 3).toString('ascii');
        if (!['FWS', 'CWS', 'ZWS'].includes(sig)) return resolve('bad');
        fs.writeFileSync(destPath, buf);
        resolve('ok');
      });
    });
    req.on('error', () => resolve('err'));
    req.setTimeout(10000, () => { req.destroy(); resolve('timeout'); });
  });
}

async function downloadAll() {
  let ok = 0, skip = 0, miss = 0;

  // ── ORGLibs: org_1.swf até org_400.swf ───────────────────────────────────
  console.log('\n🌱 ORGLibs (org_1 → org_400)...');
  for (let i = 1; i <= 400; i++) {
    const name = `org_${i}.swf`;
    const result = await download(
      `/youkia/ORGLibs/${name}?_20120307`,
      path.join(orgDir, name)
    );
    if (result === 'ok')   { process.stdout.write('✓'); ok++; }
    else if (result === 'skip') { process.stdout.write('.'); skip++; }
    else if (result === '404')  { process.stdout.write(' '); miss++; }
    else                        { process.stdout.write('x'); }
    if (i % 50 === 0) process.stdout.write(` ${i}\n`);
    await new Promise(r => setTimeout(r, 80));
  }

  // ── IconOrg: 1.swf até 300.swf ───────────────────────────────────────────
  console.log('\n\n🎨 IconOrg (1 → 300)...');
  for (let i = 1; i <= 300; i++) {
    const name = `${i}.swf`;
    const result = await download(
      `/youkia/IconRes/IconOrg/${name}`,
      path.join(iconsOrgDir, name)
    );
    if (result === 'ok')   { process.stdout.write('✓'); ok++; }
    else if (result === 'skip') { process.stdout.write('.'); skip++; }
    else if (result === '404')  { process.stdout.write(' '); miss++; }
    else                        { process.stdout.write('x'); }
    if (i % 50 === 0) process.stdout.write(` ${i}\n`);
    await new Promise(r => setTimeout(r, 80));
  }

  // ── IconTool: 1.swf até 300.swf ──────────────────────────────────────────
  console.log('\n\n🔧 IconTool (1 → 300)...');
  for (let i = 1; i <= 300; i++) {
    const name = `${i}.swf`;
    const result = await download(
      `/youkia/IconRes/IconTool/${name}`,
      path.join(iconsToolDir, name)
    );
    if (result === 'ok')   { process.stdout.write('✓'); ok++; }
    else if (result === 'skip') { process.stdout.write('.'); skip++; }
    else if (result === '404')  { process.stdout.write(' '); miss++; }
    else                        { process.stdout.write('x'); }
    if (i % 50 === 0) process.stdout.write(` ${i}\n`);
    await new Promise(r => setTimeout(r, 80));
  }

  console.log(`\n\n✅ ${ok} baixados, ⏭ ${skip} já existiam, 404: ${miss}`);
}

downloadAll();
