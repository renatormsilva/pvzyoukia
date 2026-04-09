// Adiciona no download.js ou cria um download-pvz.js
const http = require('http');
const fs = require('fs');

const url = 'http://s46.youkia.pvz.youkia.com/pvz/pvz_20150415.swf';
const file = fs.createWriteStream('./swfs/pvz_20150415.swf');

http.get(url, res => {
  res.pipe(file);
  file.on('finish', () => console.log('✅ pvz_20150415.swf baixado!'));
}).on('error', err => console.log('❌ Erro:', err.message));