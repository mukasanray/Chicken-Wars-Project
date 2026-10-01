#!/usr/bin/env bash
# ==============================================================================
# 🐔 FOWLGEN WARS — PAINEL DE CONTROLE & INSTALADOR ON-CHAIN (UBUNTU / WSL2)
# ==============================================================================
# Repositório Oficial: https://github.com/mukasanray/Fowlgen-Wars-Project.git
# Comportamento Modular:
#   1. Primeira Instalação Completa (Linux, Node 22 LTS, Rust, Solana, Anchor)
#   2. Atualização de Ambiente, Repositório e Compilação
#   3. Deploy & Upgrade do Smart Contract (Localnet, Devnet, Mainnet)
#   4. Gestão de Carteiras (Criar, Recuperar, Consultar Saldos, Airdrop)
#   5. Execução de Testes Automatizados (Anchor / Cargo)
#   6. Diagnóstico do Ambiente (Health Check)
#   7. Gerenciador do Validador Local (solana-test-validator)
# ==============================================================================

# Cores e Formatação para o Terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # Sem cor

# Diretórios de Trabalho
CURRENT_EXEC_DIR="$(pwd)"
REPO_URL="https://github.com/mukasanray/Fowlgen-Wars-Project.git"

# Identificação inteligente de diretórios
if [ -d "$CURRENT_EXEC_DIR/program" ] && [ -f "$CURRENT_EXEC_DIR/program/Anchor.toml" ]; then
    BASE_DIR="$CURRENT_EXEC_DIR"
    PROGRAM_DIR="$CURRENT_EXEC_DIR/program"
elif [ -d "$CURRENT_EXEC_DIR/fowlgenwars/program" ]; then
    BASE_DIR="$CURRENT_EXEC_DIR/fowlgenwars"
    PROGRAM_DIR="$BASE_DIR/program"
else
    BASE_DIR="$CURRENT_EXEC_DIR/fowlgenwars"
    PROGRAM_DIR="$BASE_DIR/program"
fi

# Variáveis Globais de Ambiente
export PATH="$HOME/.cargo/bin:$HOME/.avm/bin:$HOME/solana-release/bin:$PATH"

# ------------------------------------------------------------------------------
# Funções Auxiliares de Interface
# ------------------------------------------------------------------------------
pausar() {
    echo ""
    read -rp "Pressione [Enter] para continuar..." _
}

banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "  ███████╗ ██████╗ ██╗    ██╗██╗      ██████╗ ███████╗███╗   ██╗"
    echo "  ██╔════╝██╔═══██╗██║    ██║██║     ██╔════╝ ██╔════╝████╗  ██║"
    echo "  █████╗  ██║   ██║██║ █╗ ██║██║     ██║  ███╗█████╗  ██╔██╗ ██║"
    echo "  ██╔══╝  ██║   ██║██║███╗██║██║     ██║   ██║██╔══╝  ██║╚██╗██║"
    echo "  ██║     ╚██████╔╝╚███╔███╔╝███████╗╚██████╔╝███████╗██║ ╚████║"
    echo "  ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝"
    echo "                    ⚔️  W A R S  ⚔️                                "
    echo -e "${NC}"
    echo -e "${CYAN}${BOLD}Painel de Controle On-Chain & Anchor Framework — FOWLGEN WARS${NC}"
    echo -e "${YELLOW}Repositório Oficial:${NC} https://github.com/mukasanray/Fowlgen-Wars-Project.git"
    echo "------------------------------------------------------------------"
}

obter_carteira_configurada() {
    local wallet=""
    if [ -f "$PROGRAM_DIR/Anchor.toml" ]; then
        wallet=$(grep -E '^\s*wallet\s*=' "$PROGRAM_DIR/Anchor.toml" | head -n1 | cut -d'=' -f2 | tr -d ' "' | tr -d "'" | sed "s|^~|$HOME|")
    fi
    if [ -z "$wallet" ]; then
        wallet="$HOME/.config/solana/id.json"
    fi
    echo "$wallet"
}

# ------------------------------------------------------------------------------
# 1. PRIMEIRA INSTALAÇÃO (Stack Completa do Zero)
# ------------------------------------------------------------------------------
func_primeira_instalacao() {
    banner
    echo -e "${BLUE}${BOLD}>>> [1] Iniciando Instalação Completa do Ambiente On-Chain...${NC}\n"

    # 1. Dependências do Linux
    echo -e "${BLUE}${BOLD}[1/8] Instalando dependências e compiladores essenciais do Linux...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential pkg-config libssl-dev libudev-dev \
                        libclang-dev protobuf-compiler git curl wget tar bzip2

    # 2. Configurar pasta e clonar repositório se necessário
    echo -e "\n${BLUE}${BOLD}[2/8] Configurando repositório e pasta 'fowlgenwars'...${NC}"
    if [ -d "$BASE_DIR/.git" ]; then
        echo -e "${GREEN}✓ Repositório já encontrado em:${NC} ${BOLD}${BASE_DIR}${NC}"
        cd "$BASE_DIR" && git pull origin main || true
    elif [ -d "$PROGRAM_DIR" ] && [ -f "$PROGRAM_DIR/Anchor.toml" ]; then
        echo -e "${GREEN}✓ Pasta do contrato já existe em:${NC} ${BOLD}${PROGRAM_DIR}${NC}"
    else
        echo -e "${YELLOW}Clonando repositório oficial em:${NC} ${BOLD}${BASE_DIR}${NC}"
        git clone "$REPO_URL" "$BASE_DIR"
        PROGRAM_DIR="$BASE_DIR/program"
    fi

    # 3. Node.js v22 LTS e Yarn
    echo -e "\n${BLUE}${BOLD}[3/8] Verificando e configurando Node.js (v22 LTS), npm e Yarn...${NC}"
    NODE_MAJOR=$(node -v 2>/dev/null | cut -d'.' -f1 | tr -d 'v' || echo "0")
    if [ "$NODE_MAJOR" -lt 22 ]; then
        echo -e "${YELLOW}Instalando/Atualizando para Node.js v22.x LTS...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt update
        sudo apt install -y nodejs
    fi

    echo -e "${YELLOW}Atualizando npm para versão estável mais recente...${NC}"
    sudo npm install -g npm@latest

    if ! command -v yarn &> /dev/null; then
        echo -e "${YELLOW}Instalando Yarn globalmente via npm...${NC}"
        sudo npm install -g yarn
    fi
    echo -e "${GREEN}✓ Node.js: $(node -v) | npm: $(npm -v) | Yarn: $(yarn -v)${NC}"

    # 4. Rust & Cargo
    echo -e "\n${BLUE}${BOLD}[4/8] Verificando e configurando Compilador Rust...${NC}"
    if ! command -v rustc &> /dev/null; then
        echo -e "${YELLOW}Instalando Rust via rustup oficial...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        echo -e "${GREEN}✓ Rust já instalado. Atualizando para estável...${NC}"
        rustup update stable
    fi
    source "$HOME/.cargo/env" 2>/dev/null || true
    echo -e "${GREEN}✓ Rust: $(rustc --version) | Cargo: $(cargo --version)${NC}"

    # 5. Solana CLI v1.18.26
    SOLANA_VERSION="v1.18.26"
    echo -e "\n${BLUE}${BOLD}[5/8] Instalando Solana CLI (${SOLANA_VERSION})...${NC}"
    if ! command -v solana &> /dev/null || [[ "$(solana --version 2>/dev/null)" != *"${SOLANA_VERSION#v}"* ]]; then
        cd "$HOME"
        wget -q --show-progress "https://github.com/solana-labs/solana/releases/download/${SOLANA_VERSION}/solana-release-x86_64-unknown-linux-gnu.tar.bz2"
        rm -rf "$HOME/solana-release"
        tar jxf solana-release-x86_64-unknown-linux-gnu.tar.bz2
        rm -f solana-release-x86_64-unknown-linux-gnu.tar.bz2

        if ! grep -q 'solana-release/bin' "$HOME/.bashrc"; then
            echo 'export PATH="$HOME/solana-release/bin:$PATH"' >> "$HOME/.bashrc"
        fi
    fi
    export PATH="$HOME/solana-release/bin:$PATH"
    echo -e "${GREEN}✓ Solana CLI: $(solana --version)${NC}"

    # 6. AVM e Anchor CLI
    echo -e "\n${BLUE}${BOLD}[6/8] Instalando AVM e Anchor Framework...${NC}"
    if ! command -v avm &> /dev/null; then
        echo -e "${YELLOW}Compilando AVM via Cargo...${NC}"
        cargo install --git https://github.com/coral-xyz/anchor avm --locked
    fi

    if ! grep -q '.avm/bin' "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/.avm/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    export PATH="$HOME/.avm/bin:$PATH"

    avm install latest
    avm use latest
    echo -e "${GREEN}✓ Anchor Framework: $(anchor --version)${NC}"

    # 7. Carteira Local e Config Devnet
    echo -e "\n${BLUE}${BOLD}[7/8] Configurando Carteira Local e Rede Padrão...${NC}"
    solana config set --url devnet
    mkdir -p "$HOME/.config/solana"
    if [ ! -f "$HOME/.config/solana/id.json" ]; then
        echo -e "${YELLOW}Gerando carteira padrão em ~/.config/solana/id.json...${NC}"
        solana-keygen new --no-bip39-passphrase --outfile "$HOME/.config/solana/id.json"
    fi
    DEV_WALLET=$(solana address)
    echo -e "${GREEN}✓ Carteira Devnet Ativa:${NC} ${BOLD}${DEV_WALLET}${NC}"
    solana airdrop 2 "$DEV_WALLET" 2>/dev/null || echo -e "${YELLOW}Aviso: Airdrop indisponível ou limite atingido.${NC}"

    # 8. Setup do Contrato e Compilação
    echo -e "\n${BLUE}${BOLD}[8/8] Configurando dependências e compilando o contrato em '${PROGRAM_DIR}'...${NC}"
    if [ -d "$PROGRAM_DIR" ]; then
        cd "$PROGRAM_DIR"
        yarn install
        anchor keys sync
        rm -rf "$HOME/.cache/solana/v1.41" "$HOME/.cache/solana/v1.4"* 2>/dev/null || true
        anchor build
        echo -e "${GREEN}✓ Contrato compilado com sucesso!${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}🎉 PRIMEIRA INSTALAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
    pausar
}

# ------------------------------------------------------------------------------
# 2. ATUALIZAR AMBIENTE & RECOMPILAR CONTRATO
# ------------------------------------------------------------------------------
func_atualizar_ambiente() {
    banner
    echo -e "${BLUE}${BOLD}>>> [2] Atualizando Repositório, Dependências e Contrato...${NC}\n"

    if [ -d "$BASE_DIR/.git" ]; then
        echo -e "${YELLOW}Puxando alterações mais recentes do repositório (git pull)...${NC}"
        cd "$BASE_DIR"
        git pull origin main
    fi

    echo -e "\n${YELLOW}Sincronizando compilador Rust...${NC}"
    rustup update stable

    if [ -d "$PROGRAM_DIR" ]; then
        cd "$PROGRAM_DIR"
        echo -e "\n${YELLOW}Atualizando dependências TypeScript (yarn install)...${NC}"
        yarn install

        echo -e "\n${YELLOW}Sincronizando Program ID (anchor keys sync)...${NC}"
        anchor keys sync

        echo -e "\n${YELLOW}Recompilando smart contract (anchor build)...${NC}"
        anchor build
        echo -e "\n${GREEN}${BOLD}✓ Ambiente e contrato atualizados com sucesso!${NC}"
    else
        echo -e "${RED}Erro: Diretório do contrato não encontrado em ${PROGRAM_DIR}.${NC}"
    fi
    pausar
}

# ------------------------------------------------------------------------------
# 3. DEPLOY & UPGRADE DO SMART CONTRACT
# ------------------------------------------------------------------------------
func_deploy_contrato() {
    banner
    echo -e "${BLUE}${BOLD}>>> [3] Deploy / Atualização do Smart Contract${NC}\n"

    if [ ! -d "$PROGRAM_DIR" ]; then
        echo -e "${RED}Erro: Pasta do contrato não encontrada em: ${PROGRAM_DIR}${NC}"
        pausar
        return
    fi

    cd "$PROGRAM_DIR"

    echo "Selecione o cluster de destino para o Deploy/Upgrade:"
    echo -e "  ${BOLD}[1]${NC} localnet (Validador local de teste)"
    echo -e "  ${BOLD}[2]${NC} devnet   (Solana Devnet pública de testes - Recomendado)"
    echo -e "  ${BOLD}[3]${NC} mainnet  (Solana Mainnet-Beta - CUIDADO: Fundos Reais!)"
    echo -e "  ${BOLD}[0]${NC} Cancelar e voltar ao menu"
    echo ""
    read -rp "Opção [0-3]: " CLUSTER_OPT

    local CHOSEN_CLUSTER=""
    case "$CLUSTER_OPT" in
        1) CHOSEN_CLUSTER="localnet" ;;
        2) CHOSEN_CLUSTER="devnet" ;;
        3) CHOSEN_CLUSTER="mainnet" ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida.${NC}"; pausar; return ;;
    esac

    echo -e "\n${BLUE}${BOLD}--- Verificando Pré-Requisitos para Deploy (${CHOSEN_CLUSTER}) ---${NC}"
    
    # 1. Carteira configurada
    local CONFIGURED_WALLET
    CONFIGURED_WALLET=$(obter_carteira_configurada)
    echo -e "${CYAN}Carteira configurada:${NC} ${BOLD}${CONFIGURED_WALLET}${NC}"

    if [ ! -f "$CONFIGURED_WALLET" ]; then
        echo -e "${RED}❌ ERRO: Arquivo de chave não encontrado em: ${CONFIGURED_WALLET}${NC}"
        echo -e "${YELLOW}Use a opção [4] do menu para criar ou importar uma carteira válida.${NC}"
        pausar
        return
    fi

    local WALLET_PUBKEY
    WALLET_PUBKEY=$(solana-keygen pubkey "$CONFIGURED_WALLET" 2>/dev/null || echo "")
    echo -e "${GREEN}✓ Chave Pública:${NC} ${BOLD}${WALLET_PUBKEY}${NC}"

    # 2. Validações por cluster
    if [ "$CHOSEN_CLUSTER" == "mainnet" ]; then
        if ! grep -q '\[programs\.mainnet\]' Anchor.toml; then
            echo -e "${YELLOW}⚠️ Aviso: [programs.mainnet] está ausente ou comentado no Anchor.toml.${NC}"
        fi

        echo -e "\n${RED}${BOLD}🚨 ATENÇÃO CRÍTICA: DEPLOY NA MAINNET CONSOME SOL REAL!${NC}"
        local MAINNET_BAL
        MAINNET_BAL=$(solana balance "$WALLET_PUBKEY" --url mainnet-beta 2>/dev/null || echo "0 SOL")
        echo -e "${CYAN}Saldo da carteira na Mainnet:${NC} ${BOLD}${MAINNET_BAL}${NC}"
        read -rp "Para confirmar a publicação na MAINNET, digite 'CONFIRMAR-MAINNET': " CONFIRM_TXT
        if [ "$CONFIRM_TXT" != "CONFIRMAR-MAINNET" ]; then
            echo -e "${YELLOW}Operação cancelada pelo usuário.${NC}"
            pausar
            return
        fi
    elif [ "$CHOSEN_CLUSTER" == "devnet" ]; then
        local DEV_BAL
        DEV_BAL=$(solana balance "$WALLET_PUBKEY" --url devnet 2>/dev/null || echo "0 SOL")
        echo -e "${CYAN}Saldo na Devnet:${NC} ${BOLD}${DEV_BAL}${NC}"
        if [[ "$DEV_BAL" == "0 SOL"* ]]; then
            echo -e "${YELLOW}Solicitando 2 SOL de teste via airdrop...${NC}"
            solana airdrop 2 "$WALLET_PUBKEY" --url devnet 2>/dev/null || true
            echo -e "${CYAN}Saldo atualizado:${NC} $(solana balance "$WALLET_PUBKEY" --url devnet 2>/dev/null || echo '0 SOL')"
        fi
    elif [ "$CHOSEN_CLUSTER" == "localnet" ]; then
        echo -e "${CYAN}Checando validador local (127.0.0.1:8899)...${NC}"
        if ! curl -s http://127.0.0.1:8899 >/dev/null 2>&1; then
            echo -e "${YELLOW}⚠️ O validador local não está ativo.${NC}"
            read -rp "Deseja iniciá-lo em segundo plano agora? (s/N): " START_VAL
            if [[ "$START_VAL" =~ ^[sS]$ ]]; then
                nohup solana-test-validator --reset > "$HOME/solana-test-validator.log" 2>&1 &
                echo -e "${GREEN}Validador local iniciado em segundo plano.${NC}"
                sleep 4
            else
                echo -e "${YELLOW}Operação cancelada.${NC}"
                pausar
                return
            fi
        else
            echo -e "${GREEN}✓ Validador local ativo.${NC}"
        fi
    fi

    # 3. Sincronizar chaves e recompilar
    echo -e "\n${YELLOW}Sincronizando chaves e compilando binário...${NC}"
    anchor keys sync
    anchor build

    # 4. Executar deploy / upgrade
    echo -e "\n${YELLOW}Executando: anchor deploy --provider.cluster ${CHOSEN_CLUSTER} --provider.wallet ${CONFIGURED_WALLET}${NC}"
    if anchor deploy --provider.cluster "$CHOSEN_CLUSTER" --provider.wallet "$CONFIGURED_WALLET"; then
        echo -e "\n${GREEN}${BOLD}🎉 DEPLOY / UPGRADE EXECUTADO COM SUCESSO!${NC}"
        
        # Opção de atualizar o IDL
        echo ""
        read -rp "Deseja inicializar/atualizar o IDL on-chain agora? (S/n): " UPGRADE_IDL
        if [[ ! "$UPGRADE_IDL" =~ ^[nN]$ ]]; then
            local PROG_ID
            PROG_ID=$(anchor keys list 2>/dev/null | grep fowlgen_wars_contract | awk '{print $2}')
            if [ -n "$PROG_ID" ] && [ -f "target/idl/fowlgen_wars_contract.json" ]; then
                echo -e "${YELLOW}Atualizando IDL on-chain para o Program ID: ${PROG_ID}...${NC}"
                anchor idl upgrade "$PROG_ID" -f target/idl/fowlgen_wars_contract.json --provider.cluster "$CHOSEN_CLUSTER" 2>/dev/null || \
                anchor idl init "$PROG_ID" -f target/idl/fowlgen_wars_contract.json --provider.cluster "$CHOSEN_CLUSTER" 2>/dev/null || true
                echo -e "${GREEN}✓ Operação de IDL concluída.${NC}"
            fi
        fi
    else
        echo -e "\n${RED}⚠️ Falha na execução do deploy. Verifique se a carteira possui saldo suficiente para rent.${NC}"
    fi
    pausar
}

# ------------------------------------------------------------------------------
# 4. GESTÃO DE CARTEIRAS (WALLETS)
# ------------------------------------------------------------------------------
func_gerenciar_carteiras() {
    while true; do
        banner
        echo -e "${BLUE}${BOLD}>>> [4] Gerenciador de Carteiras (Solana Wallets)${NC}\n"

        local CURRENT_WALLET
        CURRENT_WALLET=$(obter_carteira_configurada)
        local PUBKEY=""
        if [ -f "$CURRENT_WALLET" ]; then
            PUBKEY=$(solana-keygen pubkey "$CURRENT_WALLET" 2>/dev/null || echo "Inacessível")
        fi

        echo -e "Carteira Atual no Anchor.toml: ${BOLD}${CURRENT_WALLET}${NC}"
        echo -e "Chave Pública:                 ${CYAN}${BOLD}${PUBKEY:-'Nenhuma carteira configurada'}${NC}\n"

        echo "Escolha a operação desejada:"
        echo -e "  ${BOLD}[1]${NC} Consultar saldos nos clusters (Localnet, Devnet, Mainnet)"
        echo -e "  ${BOLD}[2]${NC} Criar NOVA carteira de desenvolvimento (Keypair)"
        echo -e "  ${BOLD}[3]${NC} Recuperar carteira existente via Seed Phrase (Mnemônica)"
        echo -e "  ${BOLD}[4]${NC} Vincular arquivo de carteira (.json) existente ao Anchor.toml"
        echo -e "  ${BOLD}[5]${NC} Solicitar Airdrop de 2 SOL na Devnet"
        echo -e "  ${BOLD}[0]${NC} Voltar ao menu principal"
        echo ""
        read -rp "Opção [0-5]: " W_OPT

        case "$W_OPT" in
            1)
                if [ -n "$PUBKEY" ]; then
                    echo -e "\n${YELLOW}Consultando saldos...${NC}"
                    echo -e "  • Localnet (8899): $(solana balance "$PUBKEY" --url http://127.0.0.1:8899 2>/dev/null || echo 'Validador Offline')"
                    echo -e "  • Devnet:          $(solana balance "$PUBKEY" --url devnet 2>/dev/null || echo 'Erro ao consultar')"
                    echo -e "  • Mainnet:         $(solana balance "$PUBKEY" --url mainnet-beta 2>/dev/null || echo 'Erro ao consultar')"
                else
                    echo -e "${RED}Nenhuma carteira válida ativa para consultar.${NC}"
                fi
                pausar
                ;;
            2)
                echo ""
                read -rp "Digite o nome para o arquivo (ex: carteira_teste): " NEW_NAME
                NEW_NAME=${NEW_NAME:-"carteira_teste"}
                local OUT_PATH="$HOME/.config/solana/${NEW_NAME}.json"
                mkdir -p "$HOME/.config/solana"
                solana-keygen new --outfile "$OUT_PATH"
                echo -e "\n${GREEN}✓ Nova carteira criada em:${NC} ${BOLD}${OUT_PATH}${NC}"
                read -rp "Deseja configurar esta carteira como padrão no Anchor.toml? (S/n): " SET_DEF
                if [[ ! "$SET_DEF" =~ ^[nN]$ ]]; then
                    sed -i "s|^\s*wallet\s*=.*|wallet = \"${OUT_PATH}\"|" "$PROGRAM_DIR/Anchor.toml"
                    echo -e "${GREEN}✓ Anchor.toml atualizado com a nova carteira!${NC}"
                fi
                pausar
                ;;
            3)
                echo ""
                read -rp "Digite o nome para salvar a carteira recuperada (ex: carteira_recuperada): " REC_NAME
                REC_NAME=${REC_NAME:-"carteira_recuperada"}
                local REC_PATH="$HOME/.config/solana/${REC_NAME}.json"
                mkdir -p "$HOME/.config/solana"
                echo -e "${YELLOW}Digite a sua frase semente (12 ou 24 palavras) quando solicitado:${NC}"
                solana-keygen recover "prompt://?key=0/0" --outfile "$REC_PATH"
                echo -e "\n${GREEN}✓ Carteira recuperada em:${NC} ${BOLD}${REC_PATH}${NC}"
                read -rp "Deseja vincular esta carteira no Anchor.toml? (S/n): " SET_REC
                if [[ ! "$SET_REC" =~ ^[nN]$ ]]; then
                    sed -i "s|^\s*wallet\s*=.*|wallet = \"${REC_PATH}\"|" "$PROGRAM_DIR/Anchor.toml"
                    echo -e "${GREEN}✓ Anchor.toml atualizado!${NC}"
                fi
                pausar
                ;;
            4)
                echo ""
                read -rp "Digite o caminho absoluto do arquivo .json: " JSON_PATH
                JSON_PATH=$(eval echo "$JSON_PATH")
                if [ -f "$JSON_PATH" ]; then
                    sed -i "s|^\s*wallet\s*=.*|wallet = \"${JSON_PATH}\"|" "$PROGRAM_DIR/Anchor.toml"
                    echo -e "${GREEN}✓ Anchor.toml atualizado com:${NC} ${JSON_PATH}"
                else
                    echo -e "${RED}Arquivo não encontrado.${NC}"
                fi
                pausar
                ;;
            5)
                if [ -n "$PUBKEY" ]; then
                    echo -e "\n${YELLOW}Solicitando 2 SOL na Devnet para ${PUBKEY}...${NC}"
                    solana airdrop 2 "$PUBKEY" --url devnet || echo -e "${YELLOW}Falha no airdrop. Use o faucet web: https://faucet.solana.com${NC}"
                    echo -e "Novo Saldo Devnet: $(solana balance "$PUBKEY" --url devnet 2>/dev/null || echo '0 SOL')"
                else
                    echo -e "${RED}Nenhuma carteira ativa encontrada.${NC}"
                fi
                pausar
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                pausar
                ;;
        esac
    done
}

# ------------------------------------------------------------------------------
# 5. EXECUTAR TESTES AUTOMATIZADOS
# ------------------------------------------------------------------------------
func_executar_testes() {
    banner
    echo -e "${BLUE}${BOLD}>>> [5] Execução de Testes Automatizados${NC}\n"

    if [ ! -d "$PROGRAM_DIR" ]; then
        echo -e "${RED}Erro: Pasta do contrato não encontrada em: ${PROGRAM_DIR}${NC}"
        pausar
        return
    fi

    cd "$PROGRAM_DIR"

    echo "Escolha a modalidade de testes:"
    echo -e "  ${BOLD}[1]${NC} anchor test (Validador local efêmero gerenciado pelo Anchor)"
    echo -e "  ${BOLD}[2]${NC} anchor test --skip-local-validator (Executa direto no cluster do Anchor.toml)"
    echo -e "  ${BOLD}[3]${NC} cargo test  (Testes unitários puros em Rust)"
    echo -e "  ${BOLD}[0]${NC} Voltar ao menu principal"
    echo ""
    read -rp "Opção [0-3]: " T_OPT

    case "$T_OPT" in
        1)
            echo -e "\n${YELLOW}Executando 'anchor test'...${NC}"
            anchor test
            ;;
        2)
            echo -e "\n${YELLOW}Executando 'anchor test --skip-local-validator'...${NC}"
            anchor test --skip-local-validator
            ;;
        3)
            echo -e "\n${YELLOW}Executando 'cargo test'...${NC}"
            cargo test
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}Opção inválida.${NC}"
            ;;
    esac
    pausar
}

# ------------------------------------------------------------------------------
# 6. DIAGNÓSTICO DO AMBIENTE (Health Check)
# ------------------------------------------------------------------------------
func_diagnostico_healthcheck() {
    banner
    echo -e "${BLUE}${BOLD}>>> [6] Diagnóstico de Saúde do Ambiente (Health Check)${NC}\n"

    check_tool() {
        local name="$1"
        local cmd="$2"
        if command -v "$name" &>/dev/null; then
            echo -e "  [${GREEN}OK${NC}] ${BOLD}${name}${NC}: $($cmd 2>/dev/null | head -n1)"
        else
            echo -e "  [${RED}FALHA${NC}] ${BOLD}${name}${NC}: Não instalado ou não encontrado no PATH"
        fi
    }

    echo -e "${CYAN}${BOLD}Ferramentas e Compiladores:${NC}"
    check_tool "node" "node -v"
    check_tool "npm" "npm -v"
    check_tool "yarn" "yarn -v"
    check_tool "rustc" "rustc --version"
    check_tool "cargo" "cargo --version"
    check_tool "solana" "solana --version"
    check_tool "avm" "avm --version"
    check_tool "anchor" "anchor --version"
    check_tool "git" "git --version"

    echo -e "\n${CYAN}${BOLD}Configurações Ativas do Anchor.toml:${NC}"
    if [ -f "$PROGRAM_DIR/Anchor.toml" ]; then
        local CLUSTER_CFG
        CLUSTER_CFG=$(grep -E '^\s*cluster\s*=' "$PROGRAM_DIR/Anchor.toml" | cut -d'=' -f2 | tr -d ' "' | tr -d "'")
        local WALLET_CFG
        WALLET_CFG=$(obter_carteira_configurada)
        
        echo -e "  • Cluster Padrão:     ${BOLD}${CLUSTER_CFG}${NC}"
        echo -e "  • Caminho da Carteira:${BOLD}${WALLET_CFG}${NC}"
        
        if [ -f "$WALLET_CFG" ]; then
            local PUB
            PUB=$(solana-keygen pubkey "$WALLET_CFG" 2>/dev/null || echo "")
            echo -e "  • Chave Pública:      ${GREEN}${BOLD}${PUB}${NC}"
            echo -e "  • Saldo na Devnet:    $(solana balance "$PUB" --url devnet 2>/dev/null || echo 'Sem conexão')"
        else
            echo -e "  • Status da Carteira: ${RED}Arquivo não encontrado no disco!${NC}"
        fi
    else
        echo -e "  ${YELLOW}Arquivo Anchor.toml não localizado em ${PROGRAM_DIR}${NC}"
    fi

    echo -e "\n${CYAN}${BOLD}Status de Serviços Locais:${NC}"
    if curl -s http://127.0.0.1:8899 >/dev/null 2>&1; then
        echo -e "  • solana-test-validator: [${GREEN}EM EXECUÇÃO${NC}] na porta 8899"
    else
        echo -e "  • solana-test-validator: [${YELLOW}PARADO${NC}]"
    fi

    pausar
}

# ------------------------------------------------------------------------------
# 7. GERENCIADOR DO VALIDADOR LOCAL
# ------------------------------------------------------------------------------
func_validador_local() {
    banner
    echo -e "${BLUE}${BOLD}>>> [7] Gerenciador do Validador Local (solana-test-validator)${NC}\n"

    local STATUS="PARADO"
    if curl -s http://127.0.0.1:8899 >/dev/null 2>&1; then
        STATUS="${GREEN}ATIVO / RESPONDENDO NA PORTA 8899${NC}"
    fi

    echo -e "Status Atual: ${BOLD}${STATUS}${NC}\n"
    echo "Opções:"
    echo -e "  ${BOLD}[1]${NC} Iniciar validador local em segundo plano"
    echo -e "  ${BOLD}[2]${NC} Parar validador local em execução"
    echo -e "  ${BOLD}[3]${NC} Ver últimas 20 linhas do log"
    echo -e "  ${BOLD}[0]${NC} Voltar ao menu principal"
    echo ""
    read -rp "Opção [0-3]: " V_OPT

    case "$V_OPT" in
        1)
            if curl -s http://127.0.0.1:8899 >/dev/null 2>&1; then
                echo -e "${YELLOW}O validador já está em execução.${NC}"
            else
                echo -e "${YELLOW}Iniciando solana-test-validator...${NC}"
                nohup solana-test-validator --reset > "$HOME/solana-test-validator.log" 2>&1 &
                sleep 3
                if curl -s http://127.0.0.1:8899 >/dev/null 2>&1; then
                    echo -e "${GREEN}✓ Validador local iniciado com sucesso! Log em: ~/solana-test-validator.log${NC}"
                else
                    echo -e "${YELLOW}Iniciado. Aguarde alguns instantes até a porta 8899 abrir.${NC}"
                fi
            fi
            ;;
        2)
            echo -e "${YELLOW}Parando processos do solana-test-validator...${NC}"
            pkill -f solana-test-validator || true
            sleep 1
            echo -e "${GREEN}✓ Validador finalizado.${NC}"
            ;;
        3)
            if [ -f "$HOME/solana-test-validator.log" ]; then
                echo -e "\n${CYAN}--- Últimas linhas do log ---${NC}"
                tail -n 20 "$HOME/solana-test-validator.log"
            else
                echo -e "${YELLOW}Nenhum log encontrado em ~/solana-test-validator.log${NC}"
            fi
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}Opção inválida.${NC}"
            ;;
    esac
    pausar
}

# ------------------------------------------------------------------------------
# LOOP PRINCIPAL (MENU INTERATIVO)
# ------------------------------------------------------------------------------
main_menu() {
    while true; do
        banner
        echo -e "${CYAN}${BOLD}MENU PRINCIPAL:${NC}"
        echo -e "  ${BOLD}[1]${NC} 🚀 Primeira Instalação (Stack Completa do Zero)"
        echo -e "  ${BOLD}[2]${NC} 🔄 Atualizar Ambiente & Recompilar Contrato"
        echo -e "  ${BOLD}[3]${NC} 📦 Deploy / Atualizar Smart Contract (Localnet / Devnet / Mainnet)"
        echo -e "  ${BOLD}[4]${NC} 👛 Gerenciar Carteiras (Criar, Recuperar, Consultar Saldos, Airdrop)"
        echo -e "  ${BOLD}[5]${NC} 🧪 Executar Testes Automatizados (Anchor / Cargo)"
        echo -e "  ${BOLD}[6]${NC} 🩺 Diagnóstico do Ambiente (Health Check)"
        echo -e "  ${BOLD}[7]${NC} ⚙️  Gerenciar Validador Local (solana-test-validator)"
        echo -e "  ${BOLD}[0]${NC} ❌ Sair"
        echo "------------------------------------------------------------------"
        read -rp "Selecione uma opção [0-7]: " MAIN_OPT

        case "$MAIN_OPT" in
            1) func_primeira_instalacao ;;
            2) func_atualizar_ambiente ;;
            3) func_deploy_contrato ;;
            4) func_gerenciar_carteiras ;;
            5) func_executar_testes ;;
            6) func_diagnostico_healthcheck ;;
            7) func_validador_local ;;
            0)
                echo -e "\n${GREEN}Até logo e boas batalhas no FOWLGEN WARS! 🐔⚔️${NC}\n"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Opção inválida. Escolha entre 0 e 7.${NC}"
                sleep 1.5
                ;;
        esac
    done
}

# Inicia o menu principal
main_menu
