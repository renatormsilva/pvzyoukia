# PVZOnline — Sprints de Execução

Execute nesta ordem. Cada sprint é independente.

---

## Sprint 1 — Ícones (AGORA, download-icons.js já rodando)

Aguarda terminar o download dos ícones. Depois:

```bash
# Reiniciar servidor com as correções de ícone
node server/server.js
```

Abrir o jogo e verificar se os ícones da loja aparecem.

---

## Sprint 2 — Atualizar dados AMF do servidor real

O cache AMF foi capturado em 2020. Atualiza para dados atuais:

```bash
node refresh-amf.js
```

Depois reiniciar o servidor. A loja deve mostrar ~18 páginas em vez de 61.

---

## Sprint 3 — Capturar métodos AMF novos

Tenta pegar métodos não capturados ainda:

```bash
node capture-more.js
```

---

## Sprint 4 — Banco de dados (estado persistente)

Instalar e configurar:

```bash
npm install better-sqlite3
node db/setup-db.js
```

Depois seguir `db/install.md` para ativar no server.js.
Com isso, compras na loja persistem entre sessões.

---

## Sprint 5 — Cheats via banco

Depois do Sprint 4, comandos úteis:

```bash
# Ver estado atual do jogador
node -e "const D=require('./db/db.js'); const p=D.getPlayer(); console.log('Money:', p.money, 'RMB:', p.rmb_money, 'Orgs:', p.organism_amount)"

# Dar dinheiro infinito
node -e "const D=require('./db/db.js'); D.updatePlayerMoney(99999999); console.log('✅ Dinheiro adicionado')"

# Dar RMB (premium)
node -e "const D=require('./db/db.js'); D.updatePlayerRmb(9999); console.log('✅ RMB adicionado')"

# Listar organismos no inventário
node -e "const D=require('./db/db.js'); console.log(D.getOrganisms())"

# Listar ferramentas no inventário
node -e "const D=require('./db/db.js'); console.log(D.getTools())"
```

---

## Sprint 6 — Re-aplicar patch do main.swf (se necessário)

Se o main.swf for resetado ou atualizado:

```bash
cp uilib/main.swf.orig uilib/main.swf
node patch-swf.js
# JPEXS: substituir Connection.as → Connection_new.as, salvar como uilib/main_urlloader.swf
node patch-swf.js uilib/main_urlloader.swf
cp uilib/main_urlloader_patched.swf uilib/main.swf
cp uilib/main.swf swfs/main.swf
```

---

## Sprint 7 — Capturar sessão nova (cookie expirado)

Quando o cookie em `session.txt` expirar:

1. Mudar data do PC para Dezembro 2020
2. Abrir mitmproxy: `mitmproxy --listen-port 8080 --save-stream-file pvzonline_new.mitm`
3. Pale Moon: configurar proxy 127.0.0.1:8080
4. Jogar no site real (loja, arena, caverna, batalha)
5. Extrair: `python extract-mitm.py pvzonline_new.mitm`
6. Pegar o novo PHPSESSID do arquivo `.mitm` e atualizar `session.txt`
7. Restaurar data do PC

---

## Estado atual do projeto

- [x] Servidor rodando com 26 métodos AMF
- [x] Loja funcionando (abriu, compra funciona)
- [x] Arena funcionando
- [x] Ícones corrigidos (pastas iconorg/ icontool/ separadas)
- [x] Auto-download de SWFs com cookie
- [x] Proxy AMF: métodos novos baixam automaticamente do servidor real
- [ ] Banco de dados (Sprint 4)
- [ ] Batalha PvE/Caverna/Arena real (bloqueio: Ruffle não tem NetConnection)
  - Workaround: Connection.as patcheado para URLLoader via JPEXS ✅
  - Falta: testar batalha completa end-to-end
- [ ] Multiplayer (futuro distante)
