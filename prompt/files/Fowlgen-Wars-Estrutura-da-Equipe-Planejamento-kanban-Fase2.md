# FOWLGEN WARS — G5B Studios
## Estrutura da Equipe, Planejamento & Kanban — Fase 2

Documento oficial de organização da equipe ativa, distribuição de responsabilidades, fluxo de trabalho e planejamento Kanban para a **Fase 2** do projeto **FOWLGEN WARS**, desenvolvido pela **G5B Studios**.

---

### Status do Projeto
* **Fase 1:** ✅ Concluída (Organização, estruturação conceitual e preparação).
* **Fase Atual:** 🚀 **Fase 2 — Desenvolvimento e Integração do MVP**.
* **Equipe Ativa:** 6 integrantes.
* **Projeto:** FOWLGEN WARS
* **Estúdio:** G5B Studios

---

## 👥 1. Equipe Ativa — Fase 2

### 👑 1. Samuel Menon Ramos
**Product Owner (PO) • Game Designer • Growth Marketing**
* **Responsabilidade Principal:** Visão de produto, direção criativa, Game Design e decisões estratégicas de crescimento.
* **Atividades:**
  * Definição e priorização de backlog e visão do produto.
  * GDD e documentação técnica de Game Design.
  * Definição das mecânicas centrais (partidas de 3 min, sistema de bombas, Galinheiro, classes, funções e rotas).
  * Economia do jogo, progressão e balanceamento conceitual.
  * Validação final de personagens, artes, sistemas e critérios de aceite.
  * Identidade, posicionamento de marca e estratégia de Growth Marketing.
  * Comunicação externa, redes sociais e divulgação.
  * Pitch decks, apresentações para hackathons/editais e relacionamento com parceiros e comunidade.
* 🎯 **Regra de Ouro:** O PO define o *"o quê"* e o *"por quê"*; a equipe técnica define o *"como"*. Samuel foca em produto, direção, validação e crescimento.

---

### 💻 2. Marcos
**Líder Técnico • Desenvolvedor Unity • Web3**
* **Responsabilidade Principal:** Arquitetura técnica, liderança do desenvolvimento de software e integrações.
* **Atividades:**
  * Arquitetura geral e desenvolvimento core na Unity (C#).
  * Desenvolvimento das mecânicas principais de gameplay.
  * Integração Unity / Web3 (Solana, Rust, Anchor, PDAs, NFTs e dados on-chain).
  * Gerenciamento de builds (Android / WebGL).
  * Definição de padrões de código, code review e decisões de infraestrutura.
* 🎯 **Regra:** Marcos conduz as decisões técnicas e de arquitetura do projeto.

---

### 🧠 3. Alexandre
**Dev / Apoio Técnico • Áudio • QA Técnico**
* **Mudança da Fase 2:** Alexandre atua como braço de apoio técnico direto de Marcos, absorvendo frentes especializadas.
* **Responsabilidade Principal:** Suporte ao desenvolvimento, liderança da frente de Áudio e QA Técnico.
* **Atividades Técnicas:**
  * Apoio na programação Unity e resolução de bugs complexos.
  * Teste e revisão de implementações técnicas.
  * Apoio na integração entre módulos e validação do protótipo.
* 🎧 **Responsabilidade de Áudio:**
  * Estruturação e organização da biblioteca de SFX/BGM ([`Fowlgen-Wars-Biblioteca-Efeitos-Sonoros.md`](Fowlgen-Wars-Biblioteca-Efeitos-Sonoros.md)).
  * Efeitos sonoros (personagens, bombas, impactos, UI, vitória/derrota).
  * Implementação de audio triggers, mixers e volume na Unity.
* 🧪 **QA Técnico:**
  * Diagnóstico de física, colisões, mecânicas de bombas, performance e estabilidade de código.
* 🎯 **Regra:** Marcos lidera a tecnologia; Alexandre fortalece a tecnologia e o áudio. Maria avalia a experiência do jogador; Alexandre testa a robustez técnica.

---

### ⚙️ 4. Emanoel
**Scrum Master • Organização do Projeto • QA de Processo**
* **Mudança da Fase 2:** Emanoel assume a função anteriormente exercida por Vyctor.
* **Responsabilidade Principal:** Garantir a organização, visibilidade e fluxo contínuo de entregas no Kanban.
* **Atividades:**
  * Gestão de Sprints e manutenção do GitHub Projects / Kanban.
  * Refinamento de ideias em cards acionáveis e distribuição de tarefas com prazos.
  * Remoção de bloqueios e facilitação de alinhamentos rápidos (*dailies/syncs*).
  * Relatórios semanais e registro formal de decisões.
* 🧪 **Apoio ao QA:**
  * Criação e manutenção de checklists de teste.
  * Registro, triagem e organização de bugs no GitHub.
  * Reprodução de erros de fluxo e validação de critérios de conclusão.
* 🎯 **Regra:** O Scrum Master facilita o fluxo. Pergunta: *"O que está bloqueando essa tarefa?"* para destravar o time.

---

### 🎨 5. Junior
**Designer UI/UX**
* **Mudança da Fase 2:** Junior assume a função anteriormente exercida por Sthefany.
* **Responsabilidade Principal:** Design de interface, experiência do usuário e identidade visual de telas mobile.
* **Atividades:**
  * Criação e iteração de UI/UX no Figma.
  * HUD de combate, menus, botões, fluxo de navegação e telas (Inicial, Seleção, Vitória/Derrota, Loja/Recompensas).
  * Design System e adaptação para diferentes resoluções mobile.
* 📌 **Processo Obrigatório:** `Briefing → Figma → Revisão → Aprovação do PO → Implementação Unity`.
* 🎯 **Regra:** Primeiro define-se a experiência; depois implementa-se a interface.

---

### 🧪 6. Maria Clara
**QA Funcional • Apoio em Narrativa**
* **Mudança da Fase 2:** Carga reorganizada e compartilhada com Alexandre e Emanoel, removendo a sobrecarga de áudio e QA técnico.
* **Responsabilidade Principal:** Qualidade da experiência do usuário (UX Testing) e coerência narrativa.
* **Atividades de QA:**
  * Testes funcionais e fluxo de gameplay na visão do jogador.
  * Identificação de falhas de usabilidade e interface.
  * Validação de coerência textual e regras de jogo.
* 📖 **Narrativa / Lore:**
  * Organização do lore ([`Fowlgen-Wars-A-Era-Passada.md`](Fowlgen-wars-A-Era-Passada.md)), revisão textual, transcrição de diálogos/frases de combate e fichas de personagens.
* 🚫 **Desvinculações:** Áudio e bugs profundos de código foram repassados para Alexandre e Emanoel.
* 🎯 **Regra:** Maria atua focada no QA da experiência e narrativa.

---

## 🔄 2. Nova Matriz de Distribuição do QA

| Área de QA | Responsável Primário | Apoio / Validação |
| :--- | :--- | :--- |
| **Teste Funcional & Experiência** | Maria Clara | — |
| **Fluxo do Jogador & Telas** | Maria Clara | Junior |
| **Textos & Coerência de Lore** | Maria Clara | Samuel |
| **Checklists de Teste** | Maria Clara | Emanoel |
| **Triagem & Registro de Bugs** | Emanoel | Maria Clara |
| **Testes Técnicos & Unity** | Alexandre | Marcos |
| **Física, Colisão & Bombas** | Alexandre | Marcos |
| **Performance & Profiling** | Alexandre | Marcos |
| **Validação Técnica Final** | Marcos | — |
| **Critérios de Aceite de Produto** | Samuel Menon Ramos | — |

```text
Fluxo de Qualidade em Rede:
Desenvolvimento ──> Emanoel organiza ──> Maria testa experiência ──> Alexandre testa técnica ──> Marcos valida código ──> Samuel valida produto
```

---

## 🏗️ 3. Estrutura de Responsabilidades

```text
🎮 PRODUTO & GAME DESIGN ── Samuel
        │
        ▼
📋 ORGANIZAÇÃO & SCRUM ──── Emanoel
        │
        ├─────────────────────────────┬─────────────────────────────┐
        ▼                             ▼                             ▼
💻 TECNOLOGIA                 🎨 EXPERIÊNCIA UI/UX          🧪 QA & NARRATIVA
Marcos (Líder)                Junior                        Maria Clara (Funcional)
  ↳ Alexandre (Apoio & Áudio)                                 ↳ Emanoel (Processo)
                                                              ↳ Alexandre (Técnico)
```

---

## 🚀 4. Objetivo e Prioridades da Fase 2

> **Meta da Fase 2:** Transformar a estrutura conceitual em um **protótipo cada vez mais jogável, integrado e testável**.

### Prioridades Técnicas:
1. Unity funcional e estável.
2. Personagem controlável com movimentação e colisão validadas.
3. Mecânica e física das bombas.
4. Habilidades e cooldowns no HUD.
5. Integração de áudio e feedback sonoro.
6. Correção contínua de bugs e geração de builds jogáveis.

---

## 📋 5. Kanban — Fase 2

### 📥 Backlog Futuro (Fases Posteriores)
* Mapas e skins secundárias de arena ([`Fowlgen-Wars-Sistema-de-Arenas.md`](Fowlgen-Wars-Sistema-de-Arenas.md)).
* Novas rotas e mecânicas avançadas de selva.
* Marketplace, NFTs e economia completa on-chain.
* Dublagens e frases regionais avançadas.
* Sistema completo de progressão e eventos sazonais.

### 📌 Ready — Tarefas Prontas para Execução

* **💻 Unity / Core (Marcos + Alexandre):**
  - [ ] Movimentação básica e fluida.
  - [ ] Sistema de colisão com o cenário.
  - [ ] Física e área de explosão das bombas.
  - [ ] Botões e slots de habilidade no HUD.
  - [ ] Primeiro fluxo ponta a ponta de partida local.
  - [ ] Validação de builds Android e WebGL.

* **🎨 UI/UX (Junior):**
  - [ ] Wireframe e layout final do HUD de combate.
  - [ ] Telas: Inicial, Seleção de Personagem, Vitória e Derrota.
  - [ ] Design System de botões e ícones de habilidade.

* **🎧 Áudio (Alexandre):**
  - [ ] Estrutura de diretórios de áudio no projeto Unity.
  - [ ] SFX: Bombas, passos, impactos e cliques de UI.
  - [ ] Efeitos de Vitória / Derrota e BGM provisória.
  - [ ] Integração de áudio aos eventos do jogo.

* **🧪 QA (Maria Clara + Emanoel + Alexandre):**
  - [ ] Elaborar checklist funcional da Fase 2.
  - [ ] Teste de colisão, movimentação e física de bombas.
  - [ ] Registro e triagem de bugs no GitHub Projects.

* **⚙️ Scrum & Processos (Emanoel):**
  - [ ] Montar e atualizar quadro Kanban no GitHub.
  - [ ] Atribuir responsáveis e critérios de aceite em cada card.
  - [ ] Consolidar relatórios semanais de progresso.

* **📢 Growth & Produto (Samuel):**
  - [ ] Atualização do manual de identidade da marca FOWLGEN.
  - [ ] Criação de conteúdo para redes sociais e devlog.
  - [ ] Materiais de apresentação para eventos e editais.

---

## 🔄 6. Ciclo de Vida Obrigatório de uma Tarefa

Toda demanda de desenvolvimento deve seguir o fluxo:

$$\text{BACKLOG} \longrightarrow \text{READY} \longrightarrow \text{IN PROGRESS} \longrightarrow \text{REVIEW} \longrightarrow \text{QA} \longrightarrow \text{DONE}$$

### Exemplo Prático:
1. Marcos implementa a mecânica de bombas.
2. Alexandre revisa o código e os scripts na Unity (*Review*).
3. Maria testa o comportamento e a sensação no gameplay (*QA Funcional*).
4. Emanoel registra pendências ou move o card no Kanban (*QA Processo*).
5. Alexandre/Marcos realizam os ajustes finos.
6. Samuel valida a conformidade com o GDD (*Aprovação do PO* $\rightarrow$ **DONE**).

---

## 🤝 7. Princípios e Regras de Ouro da Equipe

* **Ajude e Seja Ajudado:**
  1. Tentar entender.
  2. Pesquisar.
  3. Tentar solucionar.
  4. Se persistir travado, levantar a mão imediatamente e pedir ajuda.
* **Comunicação Ativa:** *"Quem sabe, compartilha. Quem não sabe, pergunta. Quem aprende, ensina."*
* **Regra de Ouro da Entrega:**  
  $$\text{1 Tarefa} \longrightarrow \text{1 Responsável} \longrightarrow \text{1 Critério de Aceite} \longrightarrow \text{1 Teste} \longrightarrow \text{1 Entrega}$$
* **Diretrizes Rápidas:**
  * 🐔 Menos conversa solta $\rightarrow$ **Mais cards no Kanban**.
  * 🐔 Menos tarefas abertas $\rightarrow$ **Mais entregas concluídas**.
  * 🐔 Menos sobrecarga individual $\rightarrow$ **Mais colaboração em rede**.
  * 🐔 Menos ideias soltas $\rightarrow$ **Mais protótipo funcionando**.
