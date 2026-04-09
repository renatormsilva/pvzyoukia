const express  = require('express');
const path     = require('path');
const fs       = require('fs');
const http     = require('http');
const crypto   = require('crypto');
const { transcodeAMF } = require('./amf3transcode');
const app = express();

// ─── PROXY CONFIG ─────────────────────────────────────────────────────────────
const REAL_SERVER  = 'http://s46.youkia.pvz.youkia.com';
const SESSION_FILE = path.join(__dirname, '../session.txt');
const getSessionCookie = () => {
  try { return fs.readFileSync(SESSION_FILE, 'utf8').trim(); } catch { return null; }
};

// ─── SWF AUTO-DOWNLOAD ────────────────────────────────────────────────────────
// Baixa um SWF do servidor real e salva localmente.
function fetchSWF(urlPath, localPath) {
  return new Promise((resolve) => {
    const cleanPath = urlPath.split('?')[0];
    const cookie = getSessionCookie();
    const req = http.get(REAL_SERVER + cleanPath, {
      headers: {
        'User-Agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.2; WOW64)',
        ...(cookie ? { 'Cookie': cookie } : {})
      }
    }, (res) => {
      if (res.statusCode !== 200) { res.resume(); return resolve(null); }
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        const buf = Buffer.concat(chunks);
        if (!['FWS', 'CWS', 'ZWS'].includes(buf.slice(0, 3).toString('ascii'))) return resolve(null);
        try {
          fs.mkdirSync(path.dirname(localPath), { recursive: true });
          fs.writeFileSync(localPath, buf);
        } catch {}
        resolve(buf);
      });
    });
    req.on('error', () => resolve(null));
    req.setTimeout(10000, () => { req.destroy(); resolve(null); });
  });
}

// ─── AMF PROXY ────────────────────────────────────────────────────────────────
// Encaminha request AMF para o servidor real e salva a resposta.
function proxyAMF(body, methodName, cookie) {
  return new Promise((resolve) => {
    const options = {
      hostname: 's46.youkia.pvz.youkia.com',
      path: '/pvz/amf/',
      method: 'POST',
      headers: {
        'Content-Type':   'application/x-amf',
        'Content-Length': body.length,
        'User-Agent':     'Mozilla/5.0',
        'Referer':        'http://s46.youkia.pvz.youkia.com/',
        ...(cookie ? { 'Cookie': cookie } : {})
      }
    };
    const req = http.request(options, (res) => {
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        const buf = Buffer.concat(chunks);
        if (buf.length < 6) return resolve(null);
        // Salva no amf-cache
        const safeName = methodName.replace(/\./g, '_');
        try {
          fs.writeFileSync(path.join(__dirname, '../amf-cache', `${safeName}_req.bin`), body);
          fs.writeFileSync(path.join(__dirname, '../amf-cache', `${safeName}_resp.bin`), buf);
        } catch {}
        resolve(buf);
      });
    });
    req.on('error', () => resolve(null));
    req.setTimeout(8000, () => { req.destroy(); resolve(null); });
    req.write(body);
    req.end();
  });
}

app.use(require('cors')());

// ─── LOG DE TODAS AS REQUISIÇÕES ─────────────────────────────────────────────
app.use((req, res, next) => {
  const ts = new Date().toISOString().slice(11, 23);
  const orig = res.end.bind(res);
  res.end = (...args) => {
    console.log(`[${ts}] ${req.method} ${res.statusCode} ${req.originalUrl}`);
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

// /youkia/config/load/serverbattle/knockout.xml
app.use('/youkia/config/load/serverbattle', express.static(path.join(__dirname, '../xml')));

// /youkia/config/lang/possession_cn.xml, severBattle_cn.xml
app.use('/youkia/config/lang', express.static(path.join(__dirname, '../xml')));

// /youkia/config/load/arena.xml, hunting.xml, shakeTree.xml, tree.xml, possession.xml, garden.xml
app.use('/youkia/config/load', express.static(path.join(__dirname, '../xml')));

// /youkia/config/config.xml, ui_config.xml, quality.xml, MenuBtnConfig.xml
app.use('/youkia/config', express.static(path.join(__dirname, '../xml')));

// UILibs — busca em uilib/ primeiro, depois em swfs/ (pvz_20150415.swf está em swfs/)
app.use('/youkia/UILibs', express.static(path.join(__dirname, '../uilib')));
app.use('/youkia/UILibs', express.static(path.join(__dirname, '../swfs')));

// ORGLibs
app.use('/youkia/ORGLibs', express.static(path.join(__dirname, '../orgs')));
app.use('/youkia/ORGLibs', express.static(path.join(__dirname, '../swfs'))); // fallback

// Ícones dos organismos e ferramentas (pastas separadas para evitar conflito de IDs)
app.use('/youkia/IconRes/IconOrg',  express.static(path.join(__dirname, '../swfs/iconorg')));
app.use('/youkia/IconRes/IconOrg',  express.static(path.join(__dirname, '../swfs'))); // fallback legado
app.use('/youkia/IconRes/IconTool', express.static(path.join(__dirname, '../swfs/icontool')));
app.use('/youkia/IconRes/IconTool', express.static(path.join(__dirname, '../swfs'))); // fallback legado

// Raiz youkia (main.swf e outros)
app.use('/youkia', express.static(path.join(__dirname, '../swfs')));
app.use('/youkia', express.static(path.join(__dirname, '../uilib')));

// ── SWF AUTO-DOWNLOAD: qualquer SWF não encontrado → tenta baixar do servidor real ──
app.get('/youkia/{*path}', async (req, res, next) => {
  // req.params.path = "IconRes/IconTool/616.swf" (sem o /youkia/ prefix)
  const reqPath = '/' + req.params.path; // e.g. /IconRes/IconTool/616.swf
  if (!reqPath.endsWith('.swf')) return next();

  // Determina onde salvar localmente
  let localPath;
  const base = path.basename(reqPath);
  if (reqPath.startsWith('/IconRes/IconOrg/')) {
    localPath = path.join(__dirname, '../swfs/iconorg', base);
  } else if (reqPath.startsWith('/IconRes/IconTool/')) {
    localPath = path.join(__dirname, '../swfs/icontool', base);
  } else if (reqPath.startsWith('/UILibs/')) {
    localPath = path.join(__dirname, '../uilib', reqPath.slice('/UILibs/'.length));
  } else if (reqPath.startsWith('/ORGLibs/')) {
    localPath = path.join(__dirname, '../orgs', base);
  } else {
    localPath = path.join(__dirname, '../swfs', base);
  }

  const fullUrl = '/youkia' + reqPath;
  console.log(`  🔽 Auto-download SWF: ${fullUrl}`);
  const buf = await fetchSWF(fullUrl, localPath);
  if (buf) {
    console.log(`  ✅ Salvo: ${localPath} (${buf.length}b)`);
    res.setHeader('Content-Type', 'application/x-shockwave-flash');
    res.setHeader('Cache-Control', 'no-store');
    res.send(buf);
  } else {
    console.log(`  ❌ Não existe no servidor real: ${fullUrl}`);
    res.status(404).send('Not found');
  }
});

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
// login_reward="1" → firstLogin=0 → pula ActivityWindow (e seu UILoader que trava no Ruffle)
// banner_num="0"   → evita carregar banner_url inválida
app.get('/pvz/index.php/default/user{*path}', (_req, res) => {
  console.log('  → default/user');
  xmlRes(res, `<?xml version="1.0" encoding="utf-8"?>
<root>
  <response><status>success</status></response>
  <user id="5049894" user_id="8496443" name="LocalPlayer" money="9999999" rmb_money="999"
        honor="0" charm="0" wins="0"
        date_award="0" lottery_key="" banner_num="0" banner_url=""
        state="" invite_amount="0" use_invite_num="0" max_use_invite_num="1"
        face_url="" face=""
        is_new="" vip_etime="1799078399" is_auto="0" vip_grade="0"
        vip_restore_hp="0" reward_daily="0" has_reward_once="0"
        has_reward_sum="0" has_reward_cus="0" has_reward_first="3"
        hasActivitys="0" serverbattle_status="5" open_cave_grid="5"
        stone_cha_count="25" registrationReward="0" medal="0"
        organism_amount="10"
        IsNewTaskSystem="1" login_reward="1">
    <grade id="50" exp="500000" exp_max="600000" exp_min="400000"
           today_exp_max="99999" today_exp="0"/>
    <arena_rank_date old_start="3月31日" old_end="4月7日"
                     the_start="4月7日" the_end="4月14日"/>
    <tree height="48" today_max="1" today="1"/>
    <warehouse>
      <organism grade="1" money="20000"/>
      <tool grade="0" money="0"/>
    </warehouse>
    <friends amount="0" page_count="0" current="1" page_size="10"/>
    <cave max_amount="10" amount="10" open_grid_grade="10" open_grid_money="1000"/>
    <garden amount="3" garden_organism_amount="0" organism_amount="6"/>
    <territory honor="0" amount="0" max_amount="3"/>
    <fuben fuben_lcc="0"/>
    <copy_active state="0"/>
    <copy_zombie state="0"/>
  </user>
</root>`);
});

// 3. Armazém / Storage — serve o XML real capturado do servidor live
const warehouseXml = (() => {
  const f = path.join(__dirname, '../xml/captured_pvz_index.php_Warehouse_index_sig_6388f8b5b47ded6b344f51548d84de15_1586422800624.xml');
  if (fs.existsSync(f)) return fs.readFileSync(f, 'utf8');
  return `<?xml version="1.0" encoding="utf-8"?>
<root>
  <response><status>success</status></response>
  <warehouse organism_grid_amount="13" tool_grid_amount="192">
    <open_info><organism grade="1" money="20000"/><tool grade="0" money="0"/></open_info>
    <tools/>
    <organisms>
      <organisms_arena ids=""/>
      <organisms_territory ids=""/>
      <organisms_serverbattle ids=""/>
    </organisms>
  </warehouse>
</root>`;
})();
app.get('/pvz/index.php/Warehouse{*path}', (_req, res) => {
  console.log('  → Warehouse/index');
  xmlRes(res, warehouseXml);
});

// 4. Cavernas / Hunting — serve XML real capturado
const caveXmls = {
  private_2: (() => { const f = path.join(__dirname, '../xml/captured_pvz_index.php_cave_index_id_5049894_type_private_2_sig_6388f8b5b47ded6b344f51548.xml'); return fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : null; })(),
  public:    (() => { const f = path.join(__dirname, '../xml/captured_pvz_index.php_cave_index_id_5049894_type_public_sig_6388f8b5b47ded6b344f51548d84.xml'); return fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : null; })(),
  private:   (() => { const f = path.join(__dirname, '../xml/captured_pvz_index.php_cave_index_id_5049894_type_private_sig_6388f8b5b47ded6b344f51548d8.xml'); return fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : null; })(),
};
const caveDefault = `<?xml version="1.0" encoding="utf-8"?>
<root><response><status>success</status></response><hunting><user id="5049894" max_id="33" my_id="33"/></hunting></root>`;
app.get('/pvz/index.php/cave{*path}', (req, res) => {
  console.log('  → cave/index');
  const type = (req.query.type || req.path.match(/\/type\/([^/]+)/)?.[1] || '');
  const xml = caveXmls[type] || caveXmls['private_2'] || caveDefault;
  xmlRes(res, xml);
});

// 5. Cache de organismos para arena — serve XML real capturado
const fightingCacheXml = (() => {
  const f = path.join(__dirname, '../xml/captured_pvz_index.php_organism_fightingcache_sig_6388f8b5b47ded6b344f51548d84de15_158642.xml');
  return fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : `<?xml version="1.0" encoding="utf-8"?>
<root><response><status>success</status></response><fighting><organisms/></fighting></root>`;
})();
app.get('/pvz/index.php/organism/fightingcache{*path}', (_req, res) => {
  console.log('  → organism/fightingcache');
  xmlRes(res, fightingCacheXml);
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

// 7a. Jardim — serve XML real capturado
const gardenXml = (() => {
  const f = path.join(__dirname, '../xml/captured_pvz_index.php_garden_index_id_5049894_sig_6388f8b5b47ded6b344f51548d84de15_15864.xml');
  return fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : `<?xml version="1.0" encoding="utf-8"?>
<root><response><status>success</status></response><garden isAuto="0" id="5049894" am="6" ba="0" cn="3" bt=""><ors/><monster/></garden></root>`;
})();
app.get('/pvz/index.php/garden{*path}', (_req, res) => {
  console.log('  → garden');
  xmlRes(res, gardenXml);
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

  // Padrão com hash: api_shop_getMerchandises_a1b2c3d4_req.bin
  const HASH_RE = /^(.+)_([0-9a-f]{8})_req\.bin$/;

  const files = fs.readdirSync(cacheDir).filter(f => f.endsWith('_req.bin')).sort();
  for (const f of files) {
    const hashMatch = f.match(HASH_RE);
    const stem   = f.replace('_req.bin', '');
    const reqBuf = fs.readFileSync(path.join(cacheDir, f));
    const respFile = path.join(cacheDir, stem + '_resp.bin');
    if (!fs.existsSync(respFile)) continue;

    const resp = decodeResp(fs.readFileSync(respFile));
    if (!resp || resp[0] !== 0x00 || resp[1] !== 0x00) continue;

    if (hashMatch) {
      // Arquivo com hash: api_shop_getMerchandises_a1b2c3d4
      // Recalcula o hash do req.bin para garantir consistência
      const method = hashMatch[1].replace(/_/g, '.');
      const hash   = crypto.createHash('sha1').update(reqBuf).digest('hex').slice(0, 8);
      const key    = `${method}:${hash}`;
      if (!amfMap[key]) amfMap[key] = resp;
    } else {
      // Arquivo sem hash (legado): api_shop_getMerchandises
      let method = parseReqMethod(reqBuf);
      if (!method && /^api_/.test(stem)) {
        method = stem.replace(/_/g, '.');
      }
      if (method && !amfMap[method]) amfMap[method] = resp;
    }
  }

  const methodCount = new Set(Object.keys(amfMap).map(k => k.split(':')[0])).size;
  const hashCount   = Object.keys(amfMap).filter(k => k.includes(':')).length;
  console.log(`AMF cache: ${methodCount} métodos (${hashCount} com hash de parâmetros)`);
  Object.keys(amfMap).filter(k => !k.includes(':')).forEach(m => console.log(`  ${m}`));
})();

// ─── AMF ENDPOINT ─────────────────────────────────────────────────────────────
app.post('/pvz/amf/', express.raw({ type: '*/*', limit: '10mb' }), async (req, res) => {
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

  // Hash dos primeiros 128 bytes do body (parâmetros da requisição)
  // Usado para distinguir chamadas ao mesmo método com params diferentes (ex: abas da loja)
  const bodyHash = crypto.createHash('sha1').update(body).digest('hex').slice(0, 8);
  const cacheKey = `${target}:${bodyHash}`;

  console.log(`  📨 AMF: ${target} (uri: ${respUri}, hash: ${bodyHash})`);

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

  function serveFromCache(buf, label) {
    const transcoded = transcodeAMF(buf);
    if (transcoded) {
      console.log(`     → ${label} ${buf.length}b → transcoded AMF3→AMF0 ${transcoded.length}b`);
      buf = transcoded;
    } else {
      console.log(`     → ${label} ${buf.length}b`);
    }
    res.setHeader('Content-Type', 'application/x-amf');
    res.send(patchUri(buf, respUri));
  }

  // 1. Cache por body hash (resposta exata para estes parâmetros)
  if (amfMap[cacheKey]) {
    serveFromCache(amfMap[cacheKey], `cache[${bodyHash}]`);
    return;
  }

  // 2. Cache genérico por método (fallback para retrocompatibilidade)
  //    Só usa se não tiver cookie (sem proxy disponível)
  const cookie = getSessionCookie();
  if (!cookie && amfMap[target]) {
    serveFromCache(amfMap[target], 'replay');
    return;
  }

  // 3. Proxy para o servidor real (captura resposta específica para estes params)
  if (cookie) {
    // Se tem cache genérico e cookie, tenta proxy primeiro para ter resposta correta
    // Se não tem nem cache genérico, proxy é obrigatório
    const hasGenericCache = !!amfMap[target];
    console.log(`     → proxy servidor real (${target})${hasGenericCache ? ' [params diferentes]' : ' [novo método]'}`);
    const realResp = await proxyAMF(body, target, cookie);
    if (realResp) {
      // Salva com body hash para este conjunto de parâmetros
      amfMap[cacheKey] = realResp;
      const safeName = target.replace(/\./g, '_');
      try {
        fs.writeFileSync(path.join(__dirname, '../amf-cache', `${safeName}_${bodyHash}_req.bin`), body);
        fs.writeFileSync(path.join(__dirname, '../amf-cache', `${safeName}_${bodyHash}_resp.bin`), realResp);
      } catch {}
      console.log(`     ✅ AMF proxy OK, salvo como ${bodyHash} (${realResp.length}b)`);
      serveFromCache(realResp, 'proxy→cache');
      return;
    }
    console.log(`     ⚠ Proxy falhou`);
    // Fallback para cache genérico se tiver
    if (amfMap[target]) {
      serveFromCache(amfMap[target], 'replay[fallback]');
      return;
    }
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
