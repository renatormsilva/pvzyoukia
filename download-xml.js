const fs = require('fs');
const http = require('http');
const path = require('path');

const xmlUrls = [
  'http://s46.youkia.pvz.youkia.com/youkia/config/lang/language_cn.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/lang/world_cn.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/lang/shakeTree_cn.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/config.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/MenuBtnConfig.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/ui_config.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/quality.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/load/arena.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/load/hunting.xml',
  'http://s46.youkia.pvz.youkia.com/youkia/config/load/world/world.xml',
  'http://s46.youkia.pvz.youkia.com/pvz/php_xml/organism.xml',
  'http://s46.youkia.pvz.youkia.com/pvz/php_xml/tool.xml',
  'http://s46.youkia.pvz.youkia.com/pvz/php_xml/talent.xml',
  'http://s46.youkia.pvz.youkia.com/pvz/php_xml/awards.xml',
  'http://s46.youkia.pvz.youkia.com/pvz/php_xml/gemexchange.xml',
];

const outputDir = './xml';
if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

xmlUrls.forEach((url, i) => {
  setTimeout(() => {
    const filename = url.split('/').pop().split('?')[0];
    const filepath = path.join(outputDir, filename);
    const file = fs.createWriteStream(filepath);
    
    http.get(url, res => {
      res.pipe(file);
      file.on('finish', () => console.log(`✅ ${filename}`));
    }).on('error', err => console.log(`❌ ${filename}: ${err.message}`));
  }, i * 300);
});