const express = require('express');
const path    = require('path');
const fs      = require('fs');
const app = express();

app.use(require('cors')());

// ─── LOG DE TODAS AS REQUISIÇÕES ─────────────────────────────────────────────
app.use((req, res, next) => {
  const ts = new Date().toISOString().slice(11, 23);
  const orig = res.end.bind(res);
  res.end = (...args) => {
    console.log(`[${ts}] ${req.method} ${res.statusCode} ${req.url}`);
    return orig(...args);
  };
  next();
});

// ─── CROSSDOMAIN.XML — exigido pelo Flash para carregar SWFs externos ────────
app.get('/crossdomain.xml', (_req, res) => {
  res.setHeader('Content-Type', 'text/xml');
  res.send(`<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
  <allow-access-from domain="*" secure="false"/>
</cross-domain-policy>`);
});

// ─── SEM CACHE para SWFs (evita servir versão antiga depois de patches) ──────
app.use((req, res, next) => {
  if (req.path.endsWith('.swf')) {
    res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate');
    res.setHeader('Pragma', 'no-cache');
    res.setHeader('Expires', '0');
  }
  next();
});

// ─── ASSETS ESTÁTICOS ────────────────────────────────────────────────────────

// CSS e imagens
app.use('/pvz/css',    express.static(path.join(__dirname, '../assets/pvz/css')));
app.use('/pvz/img',    express.static(path.join(__dirname, '../assets/pvz/img')));
app.use('/upload',     express.static(path.join(__dirname, '../assets/upload')));

// XMLs de configuração — várias rotas para cobrir todos os caminhos que o jogo usa
// /pvz/php_xml/organism.xml  →  PVZ_WEB_URL.replace("index.php/","") + "php_xml/X.xml"
app.use('/pvz/php_xml', express.static(path.join(__dirname, '../xml')));

// /youkia/config/lang/language_cn.xml  →  PVZ_RES_BASE_URL + "config/lang/X.xml"
// (arquivos estão direto em xml/, não em subpasta lang/)
app.use('/youkia/config/lang', express.static(path.join(__dirname, '../xml')));

// /youkia/config/load/world/insideWorld_1.xml
app.use('/youkia/config/load/world', express.static(path.join(__dirname, '../assets/youkia/config/load/world')));
// fallback: world.xml e outros mundos também estão em xml/
app.use('/youkia/config/load/world', express.static(path.join(__dirname, '../xml')));

// /youkia/config/load/arena.xml, hunting.xml, shakeTree.xml, tree.xml
app.use('/youkia/config/load', express.static(path.join(__dirname, '../xml')));

// /youkia/config/config.xml, ui_config.xml, quality.xml, MenuBtnConfig.xml
app.use('/youkia/config', express.static(path.join(__dirname, '../xml')));

// UILibs — busca em uilib/ primeiro, depois em swfs/ (pvz_20150415.swf está em swfs/)
app.use('/youkia/UILibs', express.static(path.join(__dirname, '../uilib')));
app.use('/youkia/UILibs', express.static(path.join(__dirname, '../swfs')));

// ORGLibs
app.use('/youkia/ORGLibs', express.static(path.join(__dirname, '../orgs')));
app.use('/youkia/ORGLibs', express.static(path.join(__dirname, '../swfs'))); // fallback

// Ícones dos organismos e ferramentas
app.use('/youkia/IconRes/IconOrg',  express.static(path.join(__dirname, '../swfs')));
app.use('/youkia/IconRes/IconTool', express.static(path.join(__dirname, '../swfs')));

// Raiz youkia (main.swf e outros)
app.use('/youkia', express.static(path.join(__dirname, '../swfs')));
app.use('/youkia', express.static(path.join(__dirname, '../uilib')));

// Upload de imagens de perfil dos jogadores (avatares)
app.use('/attach/picture', express.static(path.join(__dirname, '../assets/upload')));

// ─── HELPERS ─────────────────────────────────────────────────────────────────
const xmlRes = (res, xml) => {
  res.setHeader('Content-Type', 'application/xml; charset=utf-8');
  res.send(xml.trim());
};

// ─── REST API — MOCK DOS ENDPOINTS DO JOGO ───────────────────────────────────
// Todos os endpoints REST têm o padrão:
//   /pvz/index.php/{controller}/{action}(/sig/{md5})?(?timestamp)
// A sig é MD5("Y9d5n7St3w8K" + timestamp + "1a2b3c4d5e6f") — ignoramos na validação

// 1. Verifica se é jogador novo (0 = não, 1 = sim)
app.get('/pvz/index.php/default/isnew{*path}', (_req, res) => {
  console.log('  → default/isnew → 0');
  res.type('text').send('0');
});

// 2. Dados do jogador
// Estrutura: raiz externa contém <response><status/></response> + <user> como irmãos
// porque XmlBaseReader.isSuccess() verifica _xml.response.status (não _xml.status)
app.get('/pvz/index.php/default/user{*path}', (_req, res) => {
  console.log('  → default/user');
  xmlRes(res, `<?xml version="1.0" encoding="utf-8"?>
<pvz>
  <response><status>success</status></response>
  <user id="1001" name="LocalPlayer" money="9999999" rmb_money="999"
        honor="0" charm="0" wins="0"
        date_award="0" lottery_key="0" banner_num="0" banner_url=""
        state="0" invite_amount="0" use_invite_num="0" max_use_invite_num="0"
        face_url="" face=""
        is_new="0" vip_etime="0" is_auto="0" vip_grade="0" vip_exp="0"
        vip_restore_hp="0" reward_daily="0" has_reward_once="0"
        has_reward_sum="0" has_reward_cus="0" has_reward_first="0"
        hasActivitys="0" serverbattle_status="0" open_cave_grid="6"
        stone_cha_count="0" registrationReward="0"
        IsNewTaskSystem="1" login_reward="1">
    <grade id="50" exp="500000" exp_max="600000" exp_min="400000"
           today_exp_max="99999" today_exp="0"/>
    <arena_rank_date old_start="" old_end="" the_start="" the_end=""/>
    <tree height="10" today_max="5" today="0"/>
    <friends amount="0" page_count="0" current="1" page_size="10"/>
    <cave max_amount="10" amount="10" open_grid_grade="10" open_grid_money="1000"/>
    <garden amount="3" garden_organism_amount="0" organism_amount="6"/>
    <territory honor="0" amount="0" max_amount="3"/>
    <fuben fuben_lcc="0"/>
    <copy_active state="0"/>
    <copy_zombie state="0"/>
  </user>
</pvz>`);
});

// 3. Armazém / Storage  (_xml.warehouse.X → <warehouse> é filho da raiz)
app.get('/pvz/index.php/Warehouse{*path}', (_req, res) => {
  console.log('  → Warehouse/index');
  xmlRes(res, `<?xml version="1.0" encoding="utf-8"?>
<pvz>
  <response><status>success</status></response>
  <warehouse organism_grid_amount="6" tool_grid_amount="10">
    <open_info>
      <organism grade="10" money="10000"/>
      <tool grade="5" money="5000"/>
    </open_info>
    <tools/>
    <organisms>
      <organisms_arena ids=""/>
      <organisms_territory ids=""/>
      <organisms_serverbattle ids=""/>
    </organisms>
  </warehouse>
</pvz>`);
});

// 4. Cavernas / Hunting
app.get('/pvz/index.php/cave{*path}', (_req, res) => {
  console.log('  → cave/index');
  xmlRes(res, `<?xml version="1.0" encoding="utf-8"?>
<pvz>
  <response><status>success</status></response>
  <cave id="0" is_lock="0"><items/></cave>
</pvz>`);
});

// 5. Cache de organismos para arena
app.get('/pvz/index.php/organism/fightingcache{*path}', (_req, res) => {
  console.log('  → organism/fightingcache');
  xmlRes(res, `<?xml version="1.0" encoding="utf-8"?>
<pvz>
  <response><status>success</status></response>
  <organisms total="0"/>
</pvz>`);
});

// 6. Amigos recomendados  (_xml.friends.X → <friends> é filho da raiz)
app.get('/pvz/index.php/user/recommendfriend{*path}', (_req, res) => {
  console.log('  → user/recommendfriend');
  xmlRes(res, `<?xml version="1.0" encoding="utf-8"?>
<pvz>
  <response><status>success</status></response>
  <friends amount="0" page_count="0" current="1" page_size="10"/>
</pvz>`);
});

// 7. Página principal do jogo (redireciona para o root)
app.get('/pvz/index.php/default/main{*path}', (_req, res) => {
  console.log('  → default/main');
  res.redirect('/');
});

// 8. FCM (tracking de notificações)
app.get('/pvz/index.php/fcm{*path}', (_req, res) => {
  console.log('  → fcm');
  res.send('1');
});

// 9. Verificação de login do portal Youkia
app.get(/\/login\/check/, (_req, res) => {
  console.log('  → login/check');
  res.send('1');
});

// 10. Entrada no jogo (report)
app.get(/\/entergame/, (_req, res) => {
  console.log('  → entergame');
  res.send('ok');
});

// 11. Catch-all para qualquer outro endpoint REST não mapeado
app.get('/pvz/index.php/{*path}', (req, res) => {
  console.log(`  ❓ REST não mapeado: ${req.url}`);
  xmlRes(res, `<?xml version="1.0" encoding="utf-8"?>
<pvz><response><status>success</status></response></pvz>`);
});

// ─── AMF REPLAY — carrega respostas reais capturadas do servidor live ────────
const zlib = require('zlib');
const amfMap = {}; // method → Buffer com resposta AMF real

(function loadAmfCache() {
  const cacheDir = path.join(__dirname, '..', 'amf-cache');
  if (!fs.existsSync(cacheDir)) return;

  function decodeChunked(buf) {
    const result = [];
    let off = 0;
    while (off < buf.length) {
      const lineEnd = buf.indexOf('\r\n', off);
      if (lineEnd < 0) break;
      const sizeHex = buf.slice(off, lineEnd).toString('ascii').trim().split(';')[0];
      off = lineEnd + 2;
      const size = parseInt(sizeHex, 16);
      if (isNaN(size) || size === 0) break;
      result.push(buf.slice(off, off + size));
      off += size + 2;
    }
    return result.length > 0 ? Buffer.concat(result) : buf;
  }

  function decodeResp(buf) {
    if (buf[0] === 0x1f && buf[1] === 0x8b) {
      try { return zlib.gunzipSync(buf); } catch(e) {}
    }
    if (/^[0-9a-fA-F]+\r/.test(buf.slice(0, 10).toString('ascii'))) {
      const decoded = decodeChunked(buf);
      if (decoded[0] === 0x1f && decoded[1] === 0x8b) {
        try { return zlib.gunzipSync(decoded); } catch(e) {}
      }
      return decoded;
    }
    return buf;
  }

  function parseReqMethod(buf) {
    try {
      let off = 2;
      const hCount = buf.readUInt16BE(off); off += 2;
      for (let h = 0; h < hCount; h++) {
        const nLen = buf.readUInt16BE(off); off += 2 + nLen + 1;
        const bLen = buf.readInt32BE(off); off += 4;
        if (bLen > 0) off += bLen;
      }
      off += 2;
      const tLen = buf.readUInt16BE(off); off += 2;
      return buf.slice(off, off + tLen).toString('utf8');
    } catch(e) { return null; }
  }

  const files = fs.readdirSync(cacheDir).filter(f => f.endsWith('_req.bin')).sort();
  for (const f of files) {
    const ts = f.replace('_req.bin', '');
    const req = fs.readFileSync(path.join(cacheDir, f));
    const method = parseReqMethod(req);
    if (!method || amfMap[method]) continue; // primeiro encontrado vence
    const respFile = path.join(cacheDir, ts + '_resp.bin');
    if (!fs.existsSync(respFile)) continue;
    let resp = decodeResp(fs.readFileSync(respFile));
    if (resp[0] === 0x00 && resp[1] === 0x00) {
      amfMap[method] = resp;
    }
  }
  console.log(`  📦 AMF cache: ${Object.keys(amfMap).length} métodos carregados`);
  Object.keys(amfMap).forEach(m => console.log(`     ${m}`));
})();

// ─── AMF ENDPOINT ─────────────────────────────────────────────────────────────
app.post('/pvz/amf/', express.raw({ type: '*/*', limit: '10mb' }), (req, res) => {
  const body = req.body;
  if (!body || body.length < 6) { res.status(400).end(); return; }

  // Parse do request para extrair método e response URI
  function parseRequest(buf) {
    try {
      let off = 2;
      const hCount = buf.readUInt16BE(off); off += 2;
      for (let h = 0; h < hCount; h++) {
        const nLen = buf.readUInt16BE(off); off += 2 + nLen + 1;
        const bLen = buf.readInt32BE(off); off += 4;
        if (bLen > 0) off += bLen;
      }
      off += 2; // body count
      const tLen = buf.readUInt16BE(off); off += 2;
      const target = buf.slice(off, off + tLen).toString('utf8'); off += tLen;
      const rLen = buf.readUInt16BE(off); off += 2;
      const respUri = buf.slice(off, off + rLen).toString('utf8');
      return { target, respUri };
    } catch(e) { return { target: '?', respUri: '1' }; }
  }

  const { target, respUri } = parseRequest(body);
  console.log(`  📨 AMF: ${target} (uri: ${respUri})`);

  // Substitui response URI para corresponder ao da requisição
  function patchUri(respBuf, newUri) {
    try {
      let off = 2;
      const hCount = respBuf.readUInt16BE(off); off += 2;
      for (let h = 0; h < hCount; h++) {
        const nLen = respBuf.readUInt16BE(off); off += 2 + nLen + 1;
        const bLen = respBuf.readInt32BE(off); off += 4 + Math.max(0, bLen);
      }
      off += 2;
      const tLen = respBuf.readUInt16BE(off);
      const before = respBuf.slice(0, off);
      const after = respBuf.slice(off + 2 + tLen);
      const newTarget = Buffer.from('/' + newUri + '/onResult', 'utf8');
      const lenBuf = Buffer.alloc(2);
      lenBuf.writeUInt16BE(newTarget.length);
      return Buffer.concat([before, lenBuf, newTarget, after]);
    } catch(e) { return respBuf; }
  }

  if (amfMap[target]) {
    console.log(`     → replay ${amfMap[target].length}b`);
    const patched = patchUri(amfMap[target], respUri);
    res.setHeader('Content-Type', 'application/x-amf');
    res.send(patched);
    return;
  }

  // Fallback: retorna 1.0 (double AMF0) para métodos não capturados
  // Isso evita que o jogo trave esperando resposta válida
  console.log(`     → fallback 1.0 (não capturado)`);
  const onResult = Buffer.from('/' + respUri + '/onResult', 'utf8');
  const nullStr  = Buffer.from('/null', 'utf8');
  const lenOr = Buffer.alloc(2); lenOr.writeUInt16BE(onResult.length);
  const lenNl = Buffer.alloc(2); lenNl.writeUInt16BE(nullStr.length);
  // Body: AMF0 Number 1.0 = type 0x00 + 8 bytes IEEE754
  const numOne = Buffer.from([0x00, 0x3f, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);
  res.setHeader('Content-Type', 'application/x-amf');
  res.send(Buffer.concat([
    Buffer.from([0x00, 0x00, 0x00, 0x00, 0x00, 0x01]),
    lenOr, onResult, lenNl, nullStr,
    Buffer.from([0x00, 0x00, 0x00, 0x09]), // body length = 9
    numOne
  ]));
});

// ─── PÁGINA PRINCIPAL ─────────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>PVZOnline Local</title>
  <style>
    body { margin: 0; background: #1a1a2e; display: flex; justify-content: center; align-items: center; height: 100vh; }
    #game-container { width: 760px; height: 535px; }
  </style>
  <script src="https://unpkg.com/@ruffle-rs/ruffle"></script>
</head>
<body>
  <div id="game-container"></div>
  <script>
    window.addEventListener('load', function () {
      const ruffle = window.RufflePlayer.newest();
      const player = ruffle.createPlayer();
      player.style.width  = '760px';
      player.style.height = '535px';
      document.getElementById('game-container').appendChild(player);

      player.load({
        url: '/youkia/main.swf',
        // base_url      → URL base da API REST + AMF
        // base_url_info → URL base dos assets (SWFs, XMLs de config)
        parameters: {
          base_url:      'http://localhost:3000/pvz/index.php/',
          base_url_info: 'http://localhost:3000/youkia/',
          isWeb: 'true'
        },
        allowScriptAccess: 'always',
        autoplay: 'on'
      });

      player.addEventListener('loadeddata', () => console.log('SWF carregado!'));
    });
  </script>
</body>
</html>`);
});

// ─── START ────────────────────────────────────────────────────────────────────
app.listen(3000, () => {
  console.log('');
  console.log('╔══════════════════════════════════════════╗');
  console.log('║   PVZOnline Local Server — porta 3000    ║');
  console.log('╠══════════════════════════════════════════╣');
  console.log('║  http://localhost:3000                    ║');
  console.log('╚══════════════════════════════════════════╝');
  console.log('');
});
