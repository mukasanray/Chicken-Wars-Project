# 🐔 Fowlgen Wars (G5B Studios) — Estrutura, Planejamento & Kanban

Documento oficial de organização do projeto **Fowlgen Wars**, desenvolvido pela **G5B Studios**. Este arquivo sintetiza a divisão de papéis da equipe ativa, os gargalos organizacionais, a estrutura do quadro Kanban e o modelo de briefing padronizado para assets visuais.

---

## 👥 1. Integrantes Ativos e Divisão de Papéis

### 👑 Samuel Menon Ramos — Product Owner (PO) & Game Designer
* **Escopo**: Visão macro do produto, direção criativa, Game Design Document (GDD) e decisões de mecânicas (partidas de 3 minutos, sistema de bombas e Galinheiro, 4 rotas, economia e balanceamento).
* **Atividades**: Gestão de entregas e submissões nos hackathons (*Colosseum* e *Superteam*), coordenação da transição da marca (**Fowlgen Wars / G5B Studios**) e validação final de conteúdos e artes.

### 💻 Marcos — Líder Técnico / Dev Unity & Web3
* **Escopo**: Arquitetura técnica na Unity Engine e integração com a blockchain Solana.
* **Atividades**: Desenvolvimento de smart contracts em Rust via Anchor Framework, configuração de PDAs (Program Derived Addresses) para atributos dos personagens, contratos de NFTs, geração de builds (APK Android / Web) e gravações de entregas técnicas.

### ⚙️ Vyctor Rodrigues — Scrum Master / Dev Web & Backend
* **Escopo**: Gestão ágil do projeto (Sprints e quadro Kanban no GitHub Projects), alinhamento da equipe e relatórios semanais.
* **Atividades**: Desenvolvimento e hospedagem do site oficial Web3 (com integração à carteira Phantom via Vercel/Cloudflare), criação de scripts C# para mecânicas da Unity e centralização do backlog de tarefas.

### 🎨 Sthefany — Artista 2D / UI/UX / Gestão de Mídias Sociais
* **Escopo**: Identidade visual, pranchas conceituais dos 4 personagens do MVP (Tanque, Atirador, Mago, Caçador), turnarounds e vistas de referência para modelagem/Unity, telas e HUDs no Figma.
* **Atividades**: Administração das redes sociais oficiais (Instagram, YouTube, TikTok, Facebook), criação de thumbnails/conteúdos e gestão do cofre central de senhas no Bitwarden.

### 🧪 Maria Clara — QA / Apoio em Narrativa & Áudio
* **Escopo**: Organização e transcrição do enredo/lore oficial (*A Grande Mutação / Ordem vs. Caos*), tabela de essências e cores dos personagens, e plano de testes (QA).
* **Atividades**: Pesquisa e levantamento de referências de áudios/dublagens cômicas regionais (mineirês, nordestino, carioca, etc.) e execução de rotinas de verificação de qualidade do jogo.

> **Nota de Alinhamento**: Os ex-integrantes Pedro Vinícius e Rafael foram desligados da equipe ativa, e suas atribuições foram redistribuídas entre o Scrum Master e a equipe de QA/Narrativa.

---

## 🧩 2. Gargalos e Pontos de Organização

1. **Homologação e Padronização da Marca**:
   * O nome oficial está definitivo: **Fowlgen Wars** (marca-mãe: **G5B Studios**).
   * **Ação**: Concluir a atualização do novo nome em todas as redes sociais, site, GitHub e formulários de cadastro do Colosseum/Superteam.

2. **Briefings Fechados para Arte**:
   * **Ação**: Adotar obrigatoriamente a ficha técnica de briefing antes de cada criação visual da Sthefany, evitando retrabalhos por mudanças de escopo no meio do desenvolvimento.

3. **Validação do Protótipo Jogável na Unity**:
   * **Ação**: Implementar e validar os scripts C# pendentes de movimentação, sistema de colisão, física de lançamento de bombas, interatividade dos botões de UI e emissão de efeitos sonoros.

4. **Centralização de Demandas no GitHub**:
   * **Ação**: O Scrum Master (Vyctor) deve converter todas as solicitações e ideias levantadas no WhatsApp em *Issues/Cards* no GitHub Projects, mantendo o hábito dos relatórios individuais aos sábados.

5. **Formalização Jurídica Interna**:
   * **Ação**: Coleta das assinaturas dos integrantes na Ficha Técnica de Confidencialidade e Participação para resguardar a propriedade intelectual do estúdio.

---

## 📋 3. Quadro Kanban do Projeto

### 📥 Backlog Geral (Futuras Sprints)
- [ ] **[Game Design]** Detalhamento dos mapas secundários (múltiplas rotas e selva).
- [ ] **[Dev/Web3]** Sistema de marketplace para negociação de NFTs (skins e cosméticos).
- [ ] **[Áudio/QA]** Gravação e implementação final das dublagens cômicas regionais.
- [ ] **[Comercial]** Mapeamento de editais de fomento (Sebrae Games, ProAC) e produtos licenciados.

### 📌 Sprint Atual (Ready / A Iniciar)
- [ ] **[Unity]** Testar script C# de movimentação básica do personagem na cena.
- [ ] **[Unity]** Implementar e validar o sistema de colisão e física de bombas.
- [ ] **[Unity]** Conectar botões da interface (HUD) com os eventos e ações do jogo.
- [ ] **[UI/UX]** Fechar o briefing padronizado dos 4 personagens do MVP (Léo, Sophie, Mago, Atirador).
- [ ] **[Narrativa/QA]** Concluir a transcrição do capítulo 1 da história oficial no Google Docs.

### 🔨 Em Desenvolvimento (In Progress)
- [/] **[Web3/Dev]** Conexão do programa Anchor/Rust (PDAs de atributos dos personagens) com a Unity.
- [/] **[Web/Front]** Ajustes de responsividade mobile e tutoriais de onboarding no site Web3.
- [/] **[Arte 2D]** Finalização das vistas neutras e turnarounds das 4 classes do MVP.
- [/] **[Gestão]** Estruturação das Sprints e atualização contínua do quadro Kanban no GitHub.

### 🔎 Em Teste / Revisão (Review)
- [/] **[Vídeos/Hackathon]** Revisão dos vídeos de entregas técnicas para atualização de links nas plataformas.
- [/] **[Redes Sociais]** Padronização das mídias sociais oficiais com a marca **Fowlgen Wars / G5B Studios**.

### ✅ Concluído (Done)
- [x] Batida de martelo e homologação do nome **Fowlgen Wars** e do estúdio **G5B Studios**.
- [x] POC de conexão da Solana Devnet com o SDK da Unity.
- [x] Lançamento da versão inicial do site Web3 com integração à carteira Phantom.
- [x] Centralização das credenciais e senhas das redes sociais no Bitwarden.
- [x] Elaboração da Ficha Técnica de Confidencialidade e Participação.

---

## 📝 4. Modelo de Briefing de Personagem (Template Visual)

```markdown
# 🐔 Briefing Visual — [Nome do Personagem]

### 1. 🪪 Identificação Básica
* **Nome do Personagem**: [Ex: Léo / Sophie]
* **Espécie / Fusão**: [Ex: Galinha Humanoide / Galinha + Leão]
* **Classe**: [Tanque | Atirador | Mago | Caçador]
* **Rota / Função**: [TOP | MID | JUNGLE | ADC]
* **Essência / Elemento**: [Fogo | Terra | Água | Arcano | etc.]
* **Personalidade**: [3 palavras-chave]

### 2. 🎨 Diretrizes Visuais & Anatomia
* **Porte Físico**: [Parrudo, Ágil, Mediano, Curvilíneo]
* **Características OBRIGATÓRIAS**:
  - [ ] Estilo da crista/pena
  - [ ] Vestimenta / Armadura principal
  - [ ] Arma / Equipamento nas mãos
* **RESTRIÇÕES & PROIBIÇÕES**:
  - ❌ [O que NÃO pode conter no design]

### 3. 📐 Especificações de Entrega
* **Pose**: Neutra / Vista frontal (para referência Unity/3D)
* **Formato**: PNG transparente 1:1 (2048x2048px) no Google Drive

### 4. ✅ Critérios de Aceite
- [ ] Seguir todas as especificações obrigatórias sem violar as proibições.
- [ ] Aprovação formal do PO (Samuel) no card do GitHub.
```

---
*Documento gerado para gestão do projeto Fowlgen Wars — G5B Studios.*
