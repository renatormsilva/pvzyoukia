// make-stub-swf.js  v2
// Gera pvz_20150415.swf com todos os named instances + TextFields que o jogo precisa.
// node make-stub-swf.js

const fs   = require('fs');
const path = require('path');

// ── Helpers ───────────────────────────────────────────────────────────────────
const u16le = n => { const b = Buffer.alloc(2); b.writeUInt16LE(n); return b; };
const u32le = n => { const b = Buffer.alloc(4); b.writeUInt32LE(n); return b; };
const cstr  = s => Buffer.from(s + '\0', 'utf8');

// SWF record (tag + data)
function tag(type, data) {
  if (data.length < 63)
    return Buffer.concat([u16le((type << 6) | data.length), data]);
  return Buffer.concat([u16le((type << 6) | 0x3F), u32le(data.length), data]);
}

// Bit-packed RECT  (all values in twips, 1px = 20 twips)
function rect(xMin, xMax, yMin, yMax) {
  const vals = [xMin, xMax, yMin, yMax];
  const maxAbs = Math.max(...vals.map(Math.abs));
  let nb = 1;
  while ((1 << (nb - 1)) <= maxAbs) nb++;
  let bits = nb.toString(2).padStart(5, '0');
  for (const v of vals) {
    const u = v >= 0 ? v : (1 << nb) + v;
    bits += u.toString(2).padStart(nb, '0');
  }
  while (bits.length % 8) bits += '0';
  return Buffer.from(bits.match(/.{8}/g).map(b => parseInt(b, 2)));
}

// PlaceObject2 tag (26) — coloca sprite com nome em depth
function place(depth, charId, name) {
  return tag(26, Buffer.concat([
    Buffer.from([0x22]),   // flags: hasCharacter | hasName
    u16le(depth),
    u16le(charId),
    cstr(name)
  ]));
}

// DefineSprite (39)
function sprite(id, innerTags) {
  return tag(39, Buffer.concat([
    u16le(id),
    u16le(innerTags.length > 0 ? 1 : 0),
    ...innerTags,
    tag(1, Buffer.alloc(0)),  // ShowFrame
    tag(0, Buffer.alloc(0))   // End
  ]));
}

// DefineEditText (37) — TextField dinâmico com .text accessível em AS3
// bounds em twips: largura 200px, altura 30px = 4000×600 twips
function editText(id) {
  const b = rect(0, 4000, 0, 600);
  // Flags (2 bytes, big-endian bit order por bytes):
  //   Byte1 bit7=HasText, bit4=ReadOnly
  //   HasText=1 → inclui InitialText
  //   ReadOnly=0 → AS3 pode setar .text
  const flags = Buffer.from([0x80, 0x00]); // só HasText
  return tag(37, Buffer.concat([
    u16le(id),
    b,
    flags,
    cstr(''),    // VariableName (vazio)
    cstr('')     // InitialText (vazio, porque HasText=1)
  ]));
}

// ── IDs de personagens ────────────────────────────────────────────────────────
let nextId = 1;
const ID = {};
const defTags = [];

function defSprite(name, innerTags) {
  ID[name] = nextId++;
  defTags.push(sprite(ID[name], innerTags));
}
function defEditText(name) {
  ID[name] = nextId++;
  defTags.push(editText(ID[name]));
}

// ── Definir personagens folha ─────────────────────────────────────────────────

defEditText('TF');   // TextField reutilizável para todos os textos
defSprite('EMPTY', []); // Sprite vazio reutilizável

// player_info: player_name, player_zhi, player_hunt, player_money, player_ymoney
defSprite('PLAYER_INFO', [
  place(1, ID.TF,    'player_name'),
  place(2, ID.EMPTY, 'player_zhi'),
  place(3, ID.TF,    'player_hunt'),
  place(4, ID.TF,    'player_money'),
  place(5, ID.TF,    'player_ymoney'),
]);

// exp: exp (TF), exp_mask (empty)
defSprite('EXP', [
  place(1, ID.TF,    'exp'),
  place(2, ID.EMPTY, 'exp_mask'),
]);

// player: todos os filhos que o código acessa
defSprite('PLAYER', [
  place(1,  ID.EMPTY,       'players'),
  place(2,  ID.EMPTY,       'shop'),
  place(3,  ID.EMPTY,       'hunt'),
  place(4,  ID.EMPTY,       'recharge'),
  place(5,  ID.EMPTY,       'num_hunt'),
  place(6,  ID.EMPTY,       'num_money'),
  place(7,  ID.EMPTY,       'num_rmb'),
  place(8,  ID.EMPTY,       'num_level'),
  place(9,  ID.EMPTY,       'num_level_loc'),
  place(10, ID.EMPTY,       '_light'),
  place(11, ID.EMPTY,       'pic'),
  place(12, ID.PLAYER_INFO, 'player_info'),
  place(13, ID.EXP,         'exp'),
]);

// dataLoading: loadName (TF), _p (TF), loading (sprite), loading2 (sprite)
defSprite('DATA_LOADING', [
  place(1, ID.TF,    'loadName'),
  place(2, ID.TF,    '_p'),
  place(3, ID.EMPTY, 'loading'),
  place(4, ID.EMPTY, 'loading2'),
]);

// rushLoading: pic (container), loading (sprite)
defSprite('RUSH_LOADING', [
  place(1, ID.EMPTY, 'pic'),
  place(2, ID.EMPTY, 'loading'),
]);

// right: shop, picture, storage, compound
defSprite('RIGHT', [
  place(1, ID.EMPTY, 'shop'),
  place(2, ID.EMPTY, 'picture'),
  place(3, ID.EMPTY, 'storage'),
  place(4, ID.EMPTY, 'compound'),
]);

// player_other_info: player_name (TF)
defSprite('PLAYER_OTHER_INFO', [
  place(1, ID.TF, 'player_name'),
]);

// player_other: player_info (com player_name)
defSprite('PLAYER_OTHER', [
  place(1, ID.PLAYER_OTHER_INFO, 'player_info'),
]);

// ── Root frame: instâncias nomeadas do _node ──────────────────────────────────
const rootTags = [
  ['player',            ID.PLAYER],
  ['draw',              ID.EMPTY],
  ['back',              ID.EMPTY],
  ['_left',             ID.EMPTY],
  ['_right',            ID.EMPTY],
  ['_left_light',       ID.EMPTY],
  ['_right_light',      ID.EMPTY],
  ['_toOtherHunting',   ID.EMPTY],
  ['autoGainIcon',      ID.EMPTY],
  ['isInto',            ID.EMPTY],
  ['rushLoading',       ID.RUSH_LOADING],
  ['player_other',      ID.PLAYER_OTHER],
  ['player_other_back', ID.EMPTY],
  ['right',             ID.RIGHT],
  ['lastFloor_btn',     ID.EMPTY],
  ['dowork',            ID.EMPTY],
  ['goHome_btn',        ID.EMPTY],
  ['dataLoading',       ID.DATA_LOADING],
].map(([name, charId], i) => place(i + 1, charId, name));

rootTags.push(tag(1, Buffer.alloc(0))); // ShowFrame
rootTags.push(tag(0, Buffer.alloc(0))); // End

// ── Montar SWF (FWS, versão 14, sem código AS) ────────────────────────────────
const body   = Buffer.concat([...defTags, ...rootTags]);
const fsize  = rect(0, 15200, 0, 10700);  // 760×535 px
const header = Buffer.concat([
  Buffer.from('FWS'),
  Buffer.from([0x0E]),       // versão 14
  u32le(0),                  // placeholder → corrigido abaixo
  fsize,
  u16le(0x1800),             // frame rate 24fps
  u16le(1),                  // 1 frame
]);

const swf = Buffer.concat([header, body]);
swf.writeUInt32LE(swf.length, 4);

const dest1 = path.join(__dirname, 'uilib', 'pvz_20150415.swf');
const dest2 = path.join(__dirname, 'swfs', 'pvz_20150415.swf');
fs.writeFileSync(dest1, swf);
fs.writeFileSync(dest2, swf);
console.log(`✅ Gerado: ${swf.length} bytes → uilib/ e swfs/`);
console.log(`   IDs: ${JSON.stringify(ID, null, 0)}`);
