// db/db.js
// Módulo de acesso ao banco de dados.
// Usado pelo server.js para ler/gravar estado do jogo.

'use strict';
const Database = require('better-sqlite3');
const path     = require('path');

const DB_PATH = path.join(__dirname, 'pvzonline.db');
let _db = null;

function getDb() {
  if (!_db) {
    _db = new Database(DB_PATH);
    _db.pragma('journal_mode = WAL');
    _db.pragma('foreign_keys = ON');
  }
  return _db;
}

// ─── PLAYER ──────────────────────────────────────────────────────────────────
function getPlayer() {
  return getDb().prepare('SELECT * FROM player WHERE id = 1001').get();
}

function updatePlayerMoney(delta) {
  getDb().prepare('UPDATE player SET money = money + ? WHERE id = 1001').run(delta);
}

function updatePlayerRmb(delta) {
  getDb().prepare('UPDATE player SET rmb_money = rmb_money + ? WHERE id = 1001').run(delta);
}

// ─── ORGANISMS ───────────────────────────────────────────────────────────────
function getOrganisms() {
  return getDb().prepare('SELECT * FROM organisms ORDER BY id').all();
}

function addOrganism(orgId, quality = 1) {
  return getDb().prepare(
    'INSERT INTO organisms (org_id, quality) VALUES (?, ?)'
  ).run(orgId, quality);
}

function removeOrganism(id) {
  getDb().prepare('DELETE FROM organisms WHERE id = ?').run(id);
}

// ─── TOOLS ───────────────────────────────────────────────────────────────────
function getTools() {
  return getDb().prepare('SELECT * FROM tools ORDER BY tool_id').all();
}

function addTool(toolId, amount = 1) {
  const existing = getDb().prepare('SELECT id FROM tools WHERE tool_id = ?').get(toolId);
  if (existing) {
    getDb().prepare('UPDATE tools SET amount = amount + ? WHERE tool_id = ?').run(amount, toolId);
  } else {
    getDb().prepare('INSERT INTO tools (tool_id, amount) VALUES (?, ?)').run(toolId, amount);
  }
}

function removeTool(toolId, amount = 1) {
  const row = getDb().prepare('SELECT id, amount FROM tools WHERE tool_id = ?').get(toolId);
  if (!row) return false;
  if (row.amount <= amount) {
    getDb().prepare('DELETE FROM tools WHERE tool_id = ?').run(toolId);
  } else {
    getDb().prepare('UPDATE tools SET amount = amount - ? WHERE tool_id = ?').run(amount, toolId);
  }
  return true;
}

// ─── GARDEN ──────────────────────────────────────────────────────────────────
function getGarden() {
  return getDb().prepare('SELECT * FROM garden ORDER BY slot_id').all();
}

function setGardenSlot(slotId, orgId) {
  if (orgId === null) {
    getDb().prepare('DELETE FROM garden WHERE slot_id = ?').run(slotId);
  } else {
    getDb().prepare(
      'INSERT OR REPLACE INTO garden (slot_id, org_id, planted_at) VALUES (?, ?, strftime(\'%s\',\'now\'))'
    ).run(slotId, orgId);
  }
}

// ─── SHOP ────────────────────────────────────────────────────────────────────
// Processa uma compra: debita dinheiro, adiciona item ao inventário
// Retorna { ok: true } ou { ok: false, error: string }
function processPurchase(itemId, itemType, price, currency) {
  const db = getDb();
  const player = getPlayer();

  if (currency === 'rmb') {
    if (player.rmb_money < price) return { ok: false, error: 'rmb insuficiente' };
    db.prepare('UPDATE player SET rmb_money = rmb_money - ? WHERE id = 1001').run(price);
  } else {
    if (player.money < price) return { ok: false, error: 'moedas insuficientes' };
    db.prepare('UPDATE player SET money = money - ? WHERE id = 1001').run(price);
  }

  if (itemType === 'organism') {
    addOrganism(itemId);
    db.prepare('UPDATE player SET organism_amount = organism_amount + 1 WHERE id = 1001').run();
  } else {
    addTool(itemId);
  }

  db.prepare(
    'INSERT INTO shop_purchases (item_id, item_type, price, currency) VALUES (?, ?, ?, ?)'
  ).run(itemId, itemType, price, currency);

  return { ok: true };
}

// ─── WAREHOUSE XML ────────────────────────────────────────────────────────────
// Gera o XML do armazém baseado no banco de dados
function buildWarehouseXml() {
  const organisms = getOrganisms();
  const tools     = getTools();
  const player    = getPlayer();

  const orgXml = organisms.map(o =>
    `      <organism id="${o.id}" org_id="${o.org_id}" level="${o.level}" exp="${o.exp}" quality="${o.quality}" slot="${o.slot}"/>`
  ).join('\n');

  const toolXml = tools.map(t =>
    `      <tool tool_id="${t.tool_id}" amount="${t.amount}"/>`
  ).join('\n');

  const arenaIds     = organisms.filter(o => o.slot === 'arena').map(o => o.id).join(',');
  const territoryIds = organisms.filter(o => o.slot === 'territory').map(o => o.id).join(',');
  const battleIds    = organisms.filter(o => o.slot === 'serverbattle').map(o => o.id).join(',');

  return `<?xml version="1.0" encoding="utf-8"?>
<root>
  <response><status>success</status></response>
  <warehouse organism_grid_amount="${Math.max(13, organisms.length + 3)}" tool_grid_amount="192">
    <open_info>
      <organism grade="1" money="20000"/>
      <tool grade="0" money="0"/>
    </open_info>
    <tools>
${toolXml}
    </tools>
    <organisms>
      <organisms_arena ids="${arenaIds}"/>
      <organisms_territory ids="${territoryIds}"/>
      <organisms_serverbattle ids="${battleIds}"/>
${orgXml}
    </organisms>
  </warehouse>
</root>`;
}

// ─── USER XML ─────────────────────────────────────────────────────────────────
// Gera o XML do jogador baseado no banco de dados
function buildUserXml() {
  const p = getPlayer();
  return `<?xml version="1.0" encoding="utf-8"?>
<root>
  <response><status>success</status></response>
  <user id="5049894" user_id="8496443" name="${p.name}"
        money="${p.money}" rmb_money="${p.rmb_money}"
        honor="${p.honor}" charm="${p.charm}" wins="${p.wins}"
        date_award="0" lottery_key="" banner_num="0" banner_url=""
        state="" invite_amount="0" use_invite_num="0" max_use_invite_num="1"
        face_url="" face=""
        is_new="" vip_etime="${p.vip_etime}" is_auto="0" vip_grade="${p.vip_grade}"
        vip_restore_hp="0" reward_daily="0" has_reward_once="0"
        has_reward_sum="0" has_reward_cus="0" has_reward_first="3"
        hasActivitys="0" serverbattle_status="5" open_cave_grid="5"
        stone_cha_count="25" registrationReward="0" medal="0"
        organism_amount="${p.organism_amount}"
        IsNewTaskSystem="1" login_reward="${p.login_reward}">
    <grade id="${p.level}" exp="${p.exp}" exp_max="600000" exp_min="400000"
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
</root>`;
}

module.exports = {
  getPlayer, updatePlayerMoney, updatePlayerRmb,
  getOrganisms, addOrganism, removeOrganism,
  getTools, addTool, removeTool,
  getGarden, setGardenSlot,
  processPurchase,
  buildWarehouseXml,
  buildUserXml,
};
