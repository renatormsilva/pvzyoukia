const http = require('http');
const fs = require('fs');
const path = require('path');

// Pega os IDs do organism.xml
const raw = fs.readFileSync('./xml/organism.xml', 'utf8');
const ids = [...raw.matchAll(/id="(\d+)"/g)].map(m => m[1]);

const outputDir = './orgs';
if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

console.log(`Baixando ${ids.length} organismos...`);

ids.forEach((id, i) => {
  setTimeout(() => {
    const url = `http://s46.youkia.pvz.youkia.com/youkia/ORGLibs/org_${id}.swf?_20120307`;
    const filepath = path.join(outputDir, `org_${id}.swf`);

    if (fs.existsSync(filepath)) {
      console.log(`⏭️ Já existe: org_${id}.swf`);
      return;
    }

    const file = fs.createWriteStream(filepath);
    http.get(url, res => {
      if (res.statusCode === 200) {
        res.pipe(file);
        file.on('finish', () => console.log(`✅ org_${id}.swf`));
      } else {
  if (fs.existsSync(filepath)) fs.unlinkSync(filepath);
  console.log(`⚠️ Não existe: org_${id}.swf`);
}
    }).on('error', () => console.log(`❌ Erro: org_${id}.swf`));
  }, i * 200);
});