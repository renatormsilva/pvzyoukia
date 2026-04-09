# Como instalar e usar o banco de dados

## 1. Instalar dependência

```bash
cd c:\Users\Ingri\OneDrive\Desktop\pvzonline
npm install better-sqlite3
```

## 2. Criar o banco

```bash
node db/setup-db.js
```

## 3. Ativar no server.js

No topo de `server/server.js`, adicionar:

```javascript
const db = require('../db/db.js');
```

Depois substituir a rota `default/user`:

```javascript
app.get('/pvz/index.php/default/user{*path}', (_req, res) => {
  console.log('  → default/user (DB)');
  xmlRes(res, db.buildUserXml());
});
```

E substituir a rota `Warehouse`:

```javascript
app.get('/pvz/index.php/Warehouse{*path}', (_req, res) => {
  console.log('  → Warehouse (DB)');
  xmlRes(res, db.buildWarehouseXml());
});
```

## 4. Verificar estado do banco

```bash
node -e "const D=require('./db/db.js'); console.log(D.getPlayer()); console.log('Orgs:', D.getOrganisms().length); console.log('Tools:', D.getTools())"
```

## 5. Dar dinheiro (cheats)

```bash
node -e "const D=require('./db/db.js'); D.updatePlayerMoney(1000000); console.log(D.getPlayer().money)"
```
