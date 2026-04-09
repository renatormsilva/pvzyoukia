const fs = require('fs');

// Lê os dois HARs
const raw1 = fs.readFileSync('pvzonline.har', 'utf8').replace(/^\uFEFF/, '');
const raw2 = fs.readFileSync('pvzonline_completo.har', 'utf8').replace(/^\uFEFF/, '');

const har1 = JSON.parse(raw1);
const har2 = JSON.parse(raw2);

// Junta as entradas dos dois
const allEntries = [...har1.log.entries, ...har2.log.entries];

const urls = allEntries
  .filter(e => e.request.url.includes('youkia'))
  .filter(e => !e.request.url.includes('.swf'))
  .map(e => ({
    url: e.request.url,
    method: e.request.method,
    status: e.response.status,
    type: e.response.content.mimeType
  }))
  .filter((v, i, a) => a.findIndex(t => t.url === v.url) === i);

urls.forEach(u => console.log(`${u.method} ${u.status} ${u.type}\n${u.url}\n`));

fs.writeFileSync('endpoints.txt',
  urls.map(u => `${u.method} ${u.status} ${u.type}\n${u.url}`).join('\n\n')
);

console.log(`\n✅ Total: ${urls.length} endpoints únicos encontrados`);