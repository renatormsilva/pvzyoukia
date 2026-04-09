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
│   ├── api_*_req.bin      ← request AMF0 (nome = método com _ em vez de .)
│   └── api_*_resp.bin     ← response AMF0 capturado
├── assets/
│   └── pvz/img/           ← imagens (avatares, logos, etc.)
├── main_exported/
│   └── scripts/           ← ActionScript 3 descompilado (leitura/referência, não executado)
├── patch-swf.js           ← patcher binário de main.swf (AVM2 bytecode)
├── extract-mitm.py        ← extrai AMF/XML de captura mitmproxy (.mitm) → amf-cache/ e xml/
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
| `GET /pvz/index.php/cave` | XML das cavernas (real capturado) |
| `GET /pvz/index.php/garden` | XML do jardim (real capturado) |
| `GET /pvz/index.php/organism/fightingcache` | XML de arena fighters (real capturado) |
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
<root>
  <response><status>success</status></response>
  <user id="..." ...>
    <grade .../>
    ...
  </user>
</root>
```
Aqui `_xml` = `<root>`, `_xml.response.status` = "success" → `isSuccess()` = true.
E `_xml.user.@id` funciona porque `<user>` é filho direto de `<root>`.

**Nota:** o nome do elemento raiz não importa — o servidor real usa `<root>`, nosso servidor local
também usa `<root>`. Qualquer nome funciona, desde que `<response>` não seja a raiz.

### Padrão por endpoint:
- `default/user` → raiz `<root>` + `<response>` + `<user>` com todos os atributos
- `Warehouse` → raiz `<root>` + `<response>` + `<warehouse>` (XML real capturado)
- `cave` → raiz `<root>` + `<response>` + `<hunting>` (XML real capturado)
- `garden` → raiz `<root>` + `<response>` + `<garden>` (XML real capturado)
- `organism/fightingcache` → raiz `<root>` + `<response>` + `<fighting>` (XML real capturado)
- `user/recommendfriend` → raiz `<root>` + `<response>` + `<friends>`
- catch-all → `<root><response><status>success</status></response></root>`

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

**Como capturar:** usar **mitmproxy** com Flash Player real (Pale Moon + Flash NPAPI no PC, com
data do sistema em Dez/2020 para bypassar o kill switch do Flash) → rodar `python extract-mitm.py pvzonline.mitm`

**ATENÇÃO ao capturar:** a data do PC precisa estar antes de Jan/2021 (Flash kill switch).
Pale Moon com Flash NPAPI 32.0.0.465 funciona. Configurar proxy em `Opções → Avançado → Rede`.

**Métodos AMF capturados e em cache (26 métodos):**

| Método | Função |
|---|---|
| `api.active.getSignInfo` | check-in diário |
| `api.active.getState` | estado de atividades |
| `api.apiorganism.getEvolutionCost` | custo de evolução |
| `api.apiorganism.getEvolutionOrgs` | organismos evoluíveis |
| `api.apiskill.getAllSkills` | todas as habilidades |
| `api.apiskill.getSpecSkillAll` | habilidades especiais |
| `api.arena.challenge` | **batalha de arena** |
| `api.arena.getArenaList` | lista de arena |
| `api.cave.challenge` | **batalha de caverna** |
| `api.duty.getAll` | tarefas do jogador |
| `api.fuben.caveInfo` | info da caverna (fuben) |
| `api.fuben.display` | display das fubens |
| `api.garden.add` | jardim — adicionar organismo |
| `api.guide.getCurAccSmall` | atividade diária |
| `api.message.gets` | mensagens |
| `api.reward.lottery` | recompensas / loteria |
| `api.serverbattle.knockout` | batalha servidor (knockout) |
| `api.shop.buy` | **comprar na loja** |
| `api.shop.getMerchandises` | listar produtos da loja |
| `api.shop.init` | inicializar loja |
| `api.shop.sell` | vender item |
| `api.territory.getTerritory` | território |
| `api.territory.init` | inicializar território |
| `api.tool.useOf` | usar ferramenta |
| `api.vip.rewards` | informações VIP |
| `api.zombie.getInfo` | modo Shake Tree |

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
- [x] Carregamento completo do jogo (Ruffle)
- [x] Tela principal (Firstpage) com animações
- [x] XMLs de configuração reais (organismos, ferramentas, qualidade, etc.)
- [x] Dados reais do jogador (warehouse, cave, garden, fightingcache)
- [x] 26 métodos AMF capturados do servidor real (loja, arena, batalha, jardim, etc.)
- [x] Captura via mitmproxy + Pale Moon com Flash real

### Não funciona ainda no Ruffle
- [ ] **Batalha PvE/Arena/Caverna** — respostas AMF capturadas, mas o cliente (Ruffle) não envia
  NetConnection → o servidor nunca recebe o request real em partida local
- [ ] **Sistema de tarefas** — `upDateTask` patcheado, dados de tarefas não carregam via Ruffle
- [ ] **Multiplayer** — precisa de protocolo de rede entre instâncias

**Raiz do problema:** Ruffle não implementa `NetConnection` HTTP (Flash Remoting).
As respostas AMF já estão no servidor — o bloqueio é no cliente.

### Próximos passos (ordem de impacto)
1. **Patchear `Connection.as` no AVM2** — substituir lógica de `NetConnection.call()` por
   `URLLoader` POST → o servidor já responde corretamente, só precisa do cliente enviar
2. **Banco de dados de estado** — SQLite para persistir organismos, recursos, batalhas
3. **Reimplementar lógica de batalha** em JS para respostas dinâmicas (não apenas replay fixo)
4. **Multiplayer** — após (1) e (2), sincronizar estado entre instâncias

---

## 12. Comandos úteis

```bash
# Iniciar servidor
node server/server.js

# Capturar sessão do jogo real com mitmproxy
# (data do PC deve ser < Jan/2021 para Flash funcionar no Pale Moon)
mitmproxy --listen-host 0.0.0.0 --listen-port 8080 --save-stream-file pvzonline.mitm

# Extrair AMF e XML do arquivo .mitm (requer: pip install mitmproxy)
python extract-mitm.py pvzonline.mitm

# Baixar SWFs que faltam do servidor live (ainda online)
node download-missing.js

# Baixar todos os ORGLibs e IconRes em bulk
node download-bulk.js

# Extrair SWFs/AMF/XML de captura HAR (DevTools → Network → Save as HAR)
node extract-har.js pvz-capture.har

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

### Setup para captura (método confirmado funcionando):

1. **Mudar data do PC para Dez/2020** — Flash tem kill switch após Jan/2021
2. **Instalar Pale Moon** (palemoon.org) + **Flash NPAPI 32.0.0.465**
3. **Iniciar mitmproxy:**
   ```bash
   mitmproxy --listen-host 0.0.0.0 --listen-port 8080 --save-stream-file pvzonline.mitm
   ```
4. **Configurar proxy no Pale Moon:** `Opções → Avançado → Rede → Proxy Manual → 127.0.0.1:8080`
5. **Jogar no site da Youkia** explorando tudo (batalhas, loja, arena, jardim, etc.)
6. **Extrair:**
   ```bash
   python extract-mitm.py pvzonline.mitm
   ```
7. **Restaurar data do PC**

Para autenticação, o jogo usa uma assinatura MD5:
```
sig = MD5("Y9d5n7St3w8K" + timestamp + "1a2b3c4d5e6f")
```
O servidor local ignora a validação da assinatura.
