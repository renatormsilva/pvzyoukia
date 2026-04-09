const http = require('http');
const fs = require('fs');
const path = require('path');

const assets = [
  // CSS e imagens da interface
  'http://s46.youkia.pvz.youkia.com/pvz/css/style.css?657487',
  'http://s46.youkia.pvz.youkia.com/pvz/img/flashbg.gif',
  'http://s46.youkia.pvz.youkia.com/pvz/img/menu.jpg',
  'http://s46.youkia.pvz.youkia.com/pvz/img/pvz_bbg.jpg',
  'http://s46.youkia.pvz.youkia.com/pvz/img/side_link2012-6-7.jpg',
  'http://s46.youkia.pvz.youkia.com/upload/1.png',
  // XMLs dos mundos
  ...Array.from({length: 20}, (_, i) => 
    `http://s46.youkia.pvz.youkia.com/youkia/config/load/world/insideWorld_${i+1}.xml`
  ),
];

const download = (url, dest) => new Promise(resolve => {
  if (fs.existsSync(dest)) {
    console.log(`⏭️ Já existe: ${path.basename(dest)}`);
    return resolve();
  }
  
  const dir = path.dirname(dest);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

  const file = fs.createWriteStream(dest);
  http.get(url, res => {
    if (res.statusCode === 200) {
      res.pipe(file);
      file.on('finish', () => {
        console.log(`✅ ${path.basename(dest)}`);
        resolve();
      });
    } else {
      fs.unlinkSync(dest);
      console.log(`⚠️ Não existe: ${path.basename(dest)}`);
      resolve();
    }
  }).on('error', () => resolve());
});

(async () => {
  for (const url of assets) {
    const filename = url.split('/').pop().split('?')[0];
    const subpath = new URL(url).pathname;
    const dest = path.join('.', 'assets', subpath);
    await download(url, dest);
  }
  console.log('\n✅ Assets baixados!');
})();