// db/setup-db.js
// Cria o banco de dados SQLite com todas as tabelas do jogo.
// Usage: node db/setup-db.js
// Requer: npm install better-sqlite3

'use strict';
const Database = require('better-sqlite3');
const path     = require('path');
const fs       = require('fs');

const DB_PATH = path.join(__dirname, 'pvzonline.db');
fs.mkdirSync(path.dirname(DB_PATH), { recursive: true });

const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

db.exec(`
-- ─── JOGADOR ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS player (
  id              INTEGER PRIMARY KEY DEFAULT 1001,
  name            TEXT    DEFAULT 'LocalPlayer',
  money           INTEGER DEFAULT 9999999,   -- moedas normais
  rmb_money       INTEGER DEFAULT 999,        -- dinheiro real (premium)
  honor           INTEGER DEFAULT 0,
  charm           INTEGER DEFAULT 0,
  wins            INTEGER DEFAULT 0,
  level           INTEGER DEFAULT 50,
  exp             INTEGER DEFAULT 500000,
  vip_grade       INTEGER DEFAULT 0,
  vip_etime       INTEGER DEFAULT 1799078399,
  is_new          INTEGER DEFAULT 0,
  login_reward    INTEGER DEFAULT 1,          -- 1 = skip ActivityWindow
  banner_num      INTEGER DEFAULT 0,
  organism_amount INTEGER DEFAULT 10
);
INSERT OR IGNORE INTO player (id) VALUES (1001);

-- ─── ORGANISMOS NO INVENTÁRIO ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS organisms (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  org_id      INTEGER NOT NULL,   -- ID do tipo de organismo (organism.xml)
  level       INTEGER DEFAULT 1,
  exp         INTEGER DEFAULT 0,
  quality     INTEGER DEFAULT 1,  -- 1=normal, 2=rare, 3=epic, 4=legendary
  slot        TEXT    DEFAULT 'none', -- 'cave', 'arena', 'territory', 'none'
  acquired_at INTEGER DEFAULT (strftime('%s','now'))
);

-- ─── FERRAMENTAS/ITENS NO INVENTÁRIO ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tools (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  tool_id     INTEGER NOT NULL,   -- ID do tipo de ferramenta (tool.xml)
  amount      INTEGER DEFAULT 1,
  acquired_at INTEGER DEFAULT (strftime('%s','now'))
);

-- ─── JARDIM ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS garden (
  slot_id     INTEGER PRIMARY KEY, -- posição no jardim (0-5)
  org_id      INTEGER,             -- NULL = vazio
  planted_at  INTEGER DEFAULT (strftime('%s','now'))
);

-- ─── HISTÓRICO DE COMPRAS NA LOJA ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS shop_purchases (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  item_id     INTEGER NOT NULL,
  item_type   TEXT    NOT NULL,   -- 'organism' | 'tool'
  price       INTEGER NOT NULL,
  currency    TEXT    NOT NULL,   -- 'money' | 'rmb'
  purchased_at INTEGER DEFAULT (strftime('%s','now'))
);

-- ─── CAVERNAS ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cave_slots (
  slot_id     INTEGER PRIMARY KEY, -- 0-9 (até 10 slots de caverna)
  org_id      INTEGER,             -- NULL = vazio
  difficulty  INTEGER DEFAULT 1
);

-- ─── PROGRESSO DAS BATALHAS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS battle_log (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  type        TEXT    NOT NULL,   -- 'cave' | 'arena' | 'serverbattle'
  result      TEXT    NOT NULL,   -- 'win' | 'lose'
  reward_money INTEGER DEFAULT 0,
  fought_at   INTEGER DEFAULT (strftime('%s','now'))
);
`);

console.log('✅ Banco de dados criado em:', DB_PATH);
console.log('   Tabelas: player, organisms, tools, garden, cave_slots, shop_purchases, battle_log');
db.close();
