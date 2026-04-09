const fs = require('fs');
const http = require('http');
const path = require('path');

// Fix do BOM
const raw = fs.readFileSync('pvzonline.har', 'utf8').replace(/^\uFEFF/, '');
const har = JSON.parse(raw);

const outputDir = './swfs';
if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

// Pega só os SWFs
const swfEntries = har.log.entries.filter(e => 
  e.request.url.includes('.swf') && e.response.status === 200
);

console.log(`📦 Encontrados ${swfEntries.length} SWFs pra baixar...`);

// Pega os cookies da primeira requisição pra autenticar
const cookies = swfEntries[0]?.request.headers
  .find(h => h.name === 'Cookie')?.value || '';

let completed = 0;

swfEntries.forEach((entry, i) => {
  setTimeout(() => {
    const url = entry.request.url;
    const filename = url.split('/').pop().split('?')[0] || `asset_${i}.swf`;
    const filepath = path.join(outputDir, filename);

    // Skip se já existe
    if (fs.existsSync(filepath)) {
      console.log(`⏭️ Já existe: ${filename}`);
      completed++;
      return;
    }

    const options = {
      headers: {
        'Cookie': cookies,
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    };

    const file = fs.createWriteStream(filepath);
    http.get(url, options, res => {
      res.pipe(file);
      file.on('finish', () => {
        completed++;
        console.log(`✅ [${completed}/${swfEntries.length}] ${filename}`);
      });
    }).on('error', err => {
      completed++;
      console.log(`❌ Erro em ${filename}: ${err.message}`);
    });

  }, i * 300);
});