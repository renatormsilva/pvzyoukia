# PVZOnline — Servidor Local (Documentação para Claude)

> Objetivo: rodar o jogo Plants vs. Zombies Online (Youkia, versão chinesa) completamente local,
> primeiro em single-player e depois habilitar multiplayer real.

---

## 1. O que é este projeto

**Plants vs. Zombies Online** (PVZOnline) era um MMO flash chinês da Youkia (s46.youkia.pvz.youkia.com),
já encerrado. O jogo roda em Flash (SWF) e se comunica com o servidor via:

- **REST / URLLoader** — endpoints XML (dados do jogador, inventário, etc.)
- **AMF (Action Message Format)** — RPC binário via `NetConnection` (Flash Remoting) para lógica
  de batalha, tarefas, loja, etc.

Este projeto é um servidor Node.js + Express que replica os endpoints do servidor original,
servindo os SWFs localmente e respondendo às APIs do jogo.

---

## 2. Stack tecnológica

| Componente | Detalhe |
|---|---|
| Servidor | Node.js + Express (`server/server.js`) |
| Flash emulator | **Ruffle** (WebAssembly), carregado via `unpkg.com/@ruffle-rs/ruffle` |
| Protocolo de dados | XML (REST) + AMF0 binário (Flash Remoting) |
| SWF principal | `main.swf` → contém TODO o ActionScript compilado |

---

## 3. Estrutura de pastas

```
pvzonline/
├── server/
│   └── server.js          ← servidor principal (Express)
├── uilib/                 ← SWFs de UI (firstpage, baseUI, windows, etc.)
│   ├── main.swf           ← SWF patcheado (contém todo o AS3 compilado)
│   ├── main.swf.orig      ← backup do main.swf original
│   ├── pvz_20150415.swf   ← UI principal do jogo
│   ├── firstpage_20150506.swf
│   ├── baseUI_2013070610.swf
│   └── ...                ← outros UILibs listados em ui_config.xml
├── swfs/                  ← SWFs de assets (main.swf, IconOrg, IconTool)
│   └── main.swf           ← cópia do main.swf patcheado (servido antes de uilib/)
├── orgs/                  ← ORGLibs: org_1.swf … org_400.swf
├── xml/                   ← XMLs de configuração capturados do servidor real
│   ├── config.xml         ← configuração global (versões dos SWFs)
│   ├── ui_config.xml      ← lista de todos os UILibs a carregar
│   ├── organism.xml       ← dados de todos os organismos
│   ├── language_cn.xml    ← strings em chinês
│   └── ...
├── amf-cache/             ← respostas AMF capturadas do servidor real
│   ├── *_req.bin          ← request AMF0 capturado
│   └── *_resp.bin         ← response AMF0 capturado
├── assets/
│   └── pvz/img/           ← imagens (avatares, logos, etc.)
├── main_exported/
│   └── scripts/           ← ActionScript 3 descompilado (leitura/referência, não executado)
├── patch-swf.js           ← patcher binário de main.swf (AVM2 bytecode)
├── download-bulk.js       ← baixa ORGLibs e IconRes do servidor live
├── download-missing.js    ← baixa UILibs específicos do servidor live
├── extract-har.js         ← extrai SWFs/AMFs/XMLs de captura .har (Fiddler/DevTools)
└── extract-saz.js         ← extrai SWFs/AMFs/XMLs de captura .saz (Fiddler)
```

---

## 4. Como o servidor funciona

### 4.1 Iniciar

```bash
node server/server.js
# Acesse: http://localhost:3000
```

### 4.2 Fluxo de carregamento do jogo

```
Browser → Ruffle carrega /youkia/main.swf
  └─ main.swf lê /youkia/config/config.xml  (versões dos SWFs)
  └─ carrega /youkia/UILibs/pvz_20150415.swf  (UI principal)
  └─ UILoaderManager lê ui_config.xml e carrega todos os UILibs
  └─ GET /pvz/index.php/default/isnew  → "0" (não é jogador novo)
  └─ GET /pvz/index.php/default/user   → XML com dados do jogador
  └─ GET /pvz/index.php/Warehouse      → XML com inventário
  └─ GET /pvz/index.php/user/recommendfriend → XML de amigos sugeridos
  └─ Jogo entra na tela principal (Firstpage)
```

### 4.3 Rotas no servidor

| Rota | Resposta |
|---|---|
| `GET /` | HTML com Ruffle embutido |
| `GET /youkia/UILibs/*` | SWFs de `uilib/` depois `swfs/` |
| `GET /youkia/ORGLibs/*` | SWFs de `orgs/` |
| `GET /youkia/IconRes/IconOrg/*` | SWFs de `swfs/` |
| `GET /youkia/config/*` | XMLs de `xml/` |
| `GET /pvz/php_xml/*` | XMLs de `xml/` |
| `GET /pvz/index.php/default/isnew` | `"0"` |
| `GET /pvz/index.php/default/user` | XML do jogador |
| `GET /pvz/index.php/Warehouse` | XML do inventário |
| `GET /pvz/index.php/cave` | XML das cavernas |
| `GET /pvz/index.php/organism/fightingcache` | XML vazio |
| `GET /pvz/index.php/user/recommendfriend` | XML de amigos |
| `GET /pvz/index.php/*` | XML genérico de sucesso |
| `POST /pvz/amf/` | Sistema de replay AMF (ver §6) |

---

## 5. Formato XML das respostas — CRÍTICO

**Bug histórico:** todos os XMLs estavam com formato errado e o jogo sempre mostrava erro.

`XmlBaseReader.isSuccess()` verifica `_xml.response.status` — onde `_xml` é a **raiz** do
documento XML. Isso significa que `<response>` e os dados (`<user>`, `<warehouse>`, etc.) devem
ser **filhos separados** do elemento raiz externo, **não** ser a raiz.

### ❌ Formato ERRADO (antigo):
```xml
<response>
  <status>success</status>
  <user .../>
</response>
```
Neste caso `_xml` = `<response>`, então `_xml.response.status` = vazio → `isSuccess()` = false.

### ✅ Formato CORRETO:
```xml
<pvz>
  <response><status>success</status></response>
  <user id="..." ...>
    <grade .../>
    ...
  </user>
</pvz>
```
Aqui `_xml` = `<pvz>`, `_xml.response.status` = "success" → `isSuccess()` = true.
E `_xml.user.@id` funciona porque `<user>` é filho direto de `<pvz>`.

### Padrão por endpoint:
- `default/user` → raiz `<pvz>` + `<response>` + `<user>` com todos os atributos
- `Warehouse` → raiz `<pvz>` + `<response>` + `<warehouse>`
- `cave` → raiz `<pvz>` + `<response>` + `<cave>`
- `user/recommendfriend` → raiz `<pvz>` + `<response>` + `<friends>`
- catch-all → `<pvz><response><status>success</status></response></pvz>`

---

## 6. Sistema AMF (Flash Remoting)

### O problema
O jogo usa dois mecanismos de rede:
1. **URLLoader** (HTTP GET/POST normal) → funciona perfeitamente no Ruffle
2. **NetConnection** (Flash Remoting HTTP) → **NÃO implementado no Ruffle** (stub vazio)

A maioria das ações de jogo (batalha, loja, tarefas, arena) usa `NetConnection` através da
classe `Connection` em `com/net/http/Connection.as`.

### Sistema de replay
O servidor carrega respostas AMF binárias capturadas do servidor real (`amf-cache/*_resp.bin`)
e as serve quando recebe um POST AMF com o método correspondente.

**Como capturar:** use Fiddler ou DevTools → salvar como `.har` → rodar `node extract-har.js arquivo.har`

**Métodos AMF capturados e em cache:**
- `api.duty.getAll` — tarefas do jogador
- `api.vip.rewards` — informações VIP
- `api.guide.getCurAccSmall` — atividade diária
- `api.active.getState` — estado de atividades
- `api.active.getSignInfo` — check-in diário
- `api.apiorganism.getEvolutionOrgs` — organismos evoluíveis
- `api.apiskill.getSpecSkillAll` — habilidades especiais
- `api.zombie.getInfo` — modo Shake Tree
- `api.arena.getArenaList` — lista de arena
- `api.cave.challenge` — batalha de caverna
- `api.garden.outAndStealAll` — jardim
- `api.message.gets` — mensagens

**Para métodos não capturados:** o servidor retorna `Number(1.0)` em AMF0 como fallback.
O jogo geralmente continua funcionando (ignora o resultado).

### Como o parsing AMF funciona no servidor
Os `_req.bin` capturados podem ter encoding duplo (chunked + gzip). O servidor decodifica:
1. Detecta gzip (`0x1F 0x8B`) → descomprime com `zlib.gunzipSync`
2. Detecta chunked (hex + `\r\n`) → strip dos chunk headers → depois gzip se necessário
3. Parseia o envelope AMF0 para extrair o nome do método (target string)

---

## 7. Patch do main.swf — CRÍTICO

### Por que patchear
`Firstpage.upDateTask()` chamava `NetConnection` (não suportado pelo Ruffle) e mostrava
`showDataLoading(true)` que nunca era escondido → loading infinito.

### O que foi patcheado
`main.swf` contém TODO o ActionScript compilado (DoABC tag com ~1MB de bytecode AVM2).

O método `Firstpage.upDateTask` (método AVM2 #640, corpo #625, 69 bytes de código) foi
substituído por NOPs (`0x02`) + `returnvoid` (`0x47`) → método vira no-op.

**Efeito:** o loading de tarefas não aparece mais. O sistema de tarefas fica sem dados
(mostra estado vazio), mas o jogo é totalmente jogável.

### Como re-aplicar o patch (se necessário)
```bash
# Restaurar original e re-patchear:
cp uilib/main.swf.orig uilib/main.swf
node patch-swf.js
cp uilib/main_patched.swf uilib/main.swf
cp uilib/main.swf swfs/main.swf
```

**IMPORTANTE:** `swfs/main.swf` tem prioridade sobre `uilib/main.swf` no servidor
(rota `/youkia` serve `swfs/` antes de `uilib/`). Ambos devem ter a versão patcheada.

### Como o patch-swf.js funciona
1. Lê `uilib/main.swf` (CWS = zlib comprimido)
2. Descomprime o body
3. Localiza a DoABC tag (tipo 82, contém o bytecode AVM2)
4. Parseia o pool de constantes ABC → encontra a string "upDateTask"
5. Navega pela hierarquia: multinames → instance_info da classe "Firstpage" → trait do método
6. Encontra o method_body correspondente
7. Preenche o código com NOPs + `returnvoid`
8. Recomprime e salva como `main_patched.swf`

---

## 8. Arquitetura ActionScript do jogo (referência)

### Hierarquia de SWFs
```
main.swf  ← carregado pelo Ruffle, contém TODO o ActionScript
  └─ pvz_20150415.swf  ← UI principal (tela de jogo, MovieClip root)
       └─ [via ui_config.xml]:
            firstpage_20150506.swf   ← tela inicial, botões de navegação
            baseUI_2013070610.swf    ← componentes base de UI
            windows_20150316.swf     ← janelas (amigos, ranking, etc.)
            loading_2013051313.swf   ← tela de loading
            number_20150416.swf      ← fonte numérica
            tips_20150506.swf        ← tooltips
            taskWindow_20150504.swf  ← sistema de tarefas
            [battle/, arena/, copy/, genius/]  ← submódulos de gameplay
```

### Classes AS3 importantes (em main_exported/scripts/)

| Classe | Arquivo | Função |
|---|---|---|
| `PlantsVsZombies` | `PlantsVsZombies.as` | Classe raiz; gerencia todo o ciclo de vida |
| `Firstpage` | `pvz/firstpage/Firstpage.as` | Tela principal do jogo; navegação entre modos |
| `Connection` | `com/net/http/Connection.as` | Wrapper de `NetConnection` para AMF RPC — **não funciona no Ruffle** |
| `XmlBaseReader` | `xmlReader/XmlBaseReader.as` | Base para parsear respostas XML do servidor |
| `XmlUserInfo` | `xmlReader/XmlUserInfo.as` | Parseia `default/user` |
| `XmlStorage` | `xmlReader/firstPage/XmlStorage.as` | Parseia `Warehouse` |
| `DistributionLoaderManager` | `core/managers/DistributionLoaderManager.as` | Carrega UILibs sob demanda |
| `NewTaskCtrl` | `pvz/newTask/ctrl/NewTaskCtrl.as` | Sistema de tarefas (usa NetConnection) |
| `AMFConnectionConstants` | `constants/AMFConnectionConstants.as` | Constantes com nomes dos métodos AMF |
| `GlobalConstants` | `constants/GlobalConstants.as` | URLs base, versões, flags globais |

### Fluxo pós-login detalhado
```
loadUserInfo() → GET default/user (URLLoader)
  ↓ XML parseado, jogador configurado
storageInfo() → GET Warehouse (URLLoader)
  ↓ inventário carregado
backFun() = init() → configura botões da UI
firstpage.showEveryPrizesWindow()
  ↓ login_reward="1" → firstLogin=0 → pula ActivityWindow
  ↓ firstLogin=2
firstpage.upDateTask()  ← NO-OP (patcheado)
AddFriendsWindow → GET user/recommendfriend (URLLoader)
  ↓ amount=0 → chama showVipWindow()
showVipWindow() → playNameGuide()
  ↓ animação do nameplate → jogo totalmente carregado!
```

---

## 9. Atributos do jogador (default/user)

Atributos críticos no XML do `<user>`:

| Atributo | Valor atual | Efeito |
|---|---|---|
| `login_reward="1"` | 1 | `firstLogin=0` → pula o ActivityWindow e seu loading |
| `is_new="0"` | 0 | Não é jogador novo → pula tutorial |
| `IsNewTaskSystem="1"` | 1 | Usa `NewTaskCtrl` para tarefas (ambas as rotas usam NetConnection) |
| `banner_num="0"` | 0 | Sem banners de atividade (evita loading de imagem vazia) |
| `id="1001"` | — | ID do jogador local |
| `grade.id="50"` | — | Nível 50 (alto o suficiente para desbloquear recursos) |

---

## 10. Headers e CORS

- `crossdomain.xml` em `/crossdomain.xml` → permite Flash carregar de qualquer domínio
- `Cache-Control: no-store` para todos os arquivos `.swf` → evita servir SWF antigo após patch
- `cors()` middleware → evita bloqueios de CORS

---

## 11. Problemas conhecidos / O que ainda falta

### Funcionando
- [x] Carregamento completo do jogo
- [x] Tela principal (Firstpage) com animações
- [x] XMLs de configuração (organismos, ferramentas, qualidade, etc.)
- [x] Inventário do jogador (warehouse)
- [x] Respostas AMF capturadas (tarefas, VIP, arena, etc.)

### Não funciona ainda
- [ ] **Batalha PvE** — usa `NetConnection` para iniciar/resolver batalhas
- [ ] **Sistema de tarefas** — `upDateTask` patcheado, dados de tarefas não carregam
- [ ] **Loja** — usa `NetConnection`
- [ ] **Arena** — usa `NetConnection`
- [ ] **Jardim** — pode usar URLLoader ou NetConnection (misto)
- [ ] **Multiplayer** — precisa de protocolo de rede entre instâncias

### Próximos passos para multiplayer
1. Implementar suporte real a AMF no servidor (receber POST AMF binário, decodificar, processar,
   retornar resposta AMF real)
2. Criar banco de dados de jogadores (SQLite ou similar)
3. Substituir o sistema `Connection`/`NetConnection` por algo que o Ruffle suporte
   — opções: patchear `Connection.as` para usar URLLoader + endpoint JSON no servidor;
   ou aguardar suporte nativo de NetConnection HTTP no Ruffle
4. Implementar endpoints de batalha (a lógica do jogo precisa ser reimplementada em JS/Node)

---

## 12. Comandos úteis

```bash
# Iniciar servidor
node server/server.js

# Baixar SWFs que faltam do servidor live (ainda online)
node download-missing.js

# Baixar todos os ORGLibs e IconRes em bulk
node download-bulk.js

# Extrair SWFs/AMF/XML de captura HAR (DevTools → Network → Save as HAR)
node extract-har.js pvz-capture.har

# Extrair de captura SAZ (Fiddler → File → Save → Session Archive)
node extract-saz.js pvz_capture.saz

# Re-aplicar patch no main.swf (após atualização ou reset)
cp uilib/main.swf.orig uilib/main.swf && node patch-swf.js
cp uilib/main_patched.swf uilib/main.swf
cp uilib/main.swf swfs/main.swf
```

---

## 13. Notas sobre o Ruffle

- Ruffle é carregado via CDN: `https://unpkg.com/@ruffle-rs/ruffle`
- **URLLoader** funciona perfeitamente (todos os GET/POST XML funcionam)
- **NetConnection HTTP** (Flash Remoting) **NÃO é suportado** — Ruffle não implementa;
  o `Connection.as` do jogo usa NetConnection para TODOS os RPCs de gameplay
- O `statusHandler` em `Connection.as` está vazio → erros são silenciados
- Ruffle faz todos os requests de rede via `window.fetch` (interceptável via JS)
- O parâmetro `allowScriptAccess: 'always'` é necessário para `ExternalInterface` funcionar

---

## 14. Capturando mais dados do servidor real

O servidor `s46.youkia.pvz.youkia.com` ainda está online (em 2026).

Para capturar uma sessão completa:
1. Abrir Fiddler ou DevTools com proxy
2. Apontar o Flash Player real (ou alguma máquina com Flash) para o servidor
3. Jogar uma sessão completa (incluindo batalhas, loja, arena)
4. Salvar como `.har` ou `.saz`
5. Rodar `node extract-har.js` ou `node extract-saz.js`
6. Os `_req.bin`/`_resp.bin` serão usados pelo replay system

Para autenticação, o jogo usa uma assinatura MD5:
```
sig = MD5("Y9d5n7St3w8K" + timestamp + "1a2b3c4d5e6f")
```
O servidor local ignora a validação da assinatura.
