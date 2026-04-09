const http = require('http');
const fs = require('fs');
const path = require('path');

const urls = [
  'http://s46.youkia.pvz.youkia.com/youkia/UILibs/arena/ranking_20140211.swf',
  'http://s46.youkia.pvz.youkia.com/youkia/UILibs/arena/tree_2012042414.swf',
  'http://s46.youkia.pvz.youkia.com/youkia/UILibs/atlas_2013051313.swf',
  'http://s46.youkia.pvz.youkia.com/youkia/UILibs/copy/copyWindow_2013070811.swf',
  'http://s46.youkia.pvz.youkia.com/youkia/main.swf',
];

const outputDir = './uilib';
if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

urls.forEach((url, i) => {
  setTimeout(() => {
    const filename = url.split('/').pop().split('?')[0];
    const filepath = path.join(outputDir, filename);

    if (fs.existsSync(filepath)) {
      console.log(`⏭️ Já existe: ${filename}`);
      return;
    }

    const file = fs.createWriteStream(filepath);
    http.get(url, res => {
      if (res.statusCode === 200) {
        res.pipe(file);
        file.on('finish', () => console.log(`✅ ${filename}`));
      } else {
        if (fs.existsSync(filepath)) fs.unlinkSync(filepath);
        console.log(`⚠️ Não existe: ${filename}`);
      }
    }).on('error', () => console.log(`❌ Erro: ${filename}`));
  }, i * 300);
});