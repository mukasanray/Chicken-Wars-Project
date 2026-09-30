#!/usr/bin/env bash
# ==============================================================================
# 🐔 FOWLGEN WARS — INSTALADOR AUTOMATIZADO DO ANCHOR FRAMEWORK (UBUNTU / WSL2)
# ==============================================================================
# Repositório Oficial: https://github.com/mukasanray/Fowlgen-Wars-Project.git
# Comportamento:
#   Cria a pasta './fowlgenwars' no local exato da execução, clona o repositório
#   para conter a pasta 'fowlgenwars/program', instala a stack completa
#   (Node, Rust, Solana, Anchor) e compila o contrato.
# ==============================================================================

set -e # Interrompe a execução imediatamente se qualquer comando falhar

# Paleta de Cores para o Terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # Sem cor

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
echo -e "${CYAN}${BOLD}Instalador do Ambiente On-Chain & Anchor Framework — FOWLGEN WARS${NC}"
echo -e "${YELLOW}Repositório Oficial:${NC} https://github.com/mukasanray/Fowlgen-Wars-Project.git"
echo "------------------------------------------------------------------"

# Diretório base onde o instalador foi chamado
CURRENT_EXEC_DIR="$(pwd)"
BASE_DIR="$CURRENT_EXEC_DIR/fowlgenwars"
PROGRAM_DIR="$BASE_DIR/program"

# ------------------------------------------------------------------------------
# 1. Dependências Base do Sistema Operacional (Ubuntu/Debian)
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[1/8] Instalando dependências e compiladores essenciais do Linux...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev libudev-dev \
                    libclang-dev protobuf-compiler git curl wget tar bzip2

# ------------------------------------------------------------------------------
# 2. Criar Pasta 'fowlgenwars' e Baixar a Pasta /program do Repositório
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[2/8] Configurando pasta 'fowlgenwars' no local de execução...${NC}"

REPO_URL="https://github.com/mukasanray/Fowlgen-Wars-Project.git"

if [ -d "$BASE_DIR/.git" ]; then
    echo -e "${GREEN}✓ Pasta 'fowlgenwars' já encontrada com repositório em:${NC} ${BOLD}${BASE_DIR}${NC}"
    echo -e "${YELLOW}Atualizando código via 'git pull origin main'...${NC}"
    cd "$BASE_DIR"
    git pull origin main || true
elif [ -d "$PROGRAM_DIR" ] && [ -f "$PROGRAM_DIR/Anchor.toml" ]; then
    echo -e "${GREEN}✓ Pasta 'fowlgenwars/program' já existe e está pronta.${NC}"
else
    echo -e "${YELLOW}Criando pasta e clonando repositório em:${NC} ${BOLD}${BASE_DIR}${NC}"
    cd "$CURRENT_EXEC_DIR"
    git clone "$REPO_URL" "$BASE_DIR"
    echo -e "${GREEN}✓ Repositório baixado com sucesso! Pasta do contrato disponível em:${NC} ${BOLD}${PROGRAM_DIR}${NC}"
fi

# ------------------------------------------------------------------------------
# 3. Node.js (v20 LTS) e Yarn
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[3/8] Verificando e configurando Node.js (v20) e Yarn...${NC}"
if ! command -v node &> /dev/null || [[ $(node -v | cut -d'.' -f1 | tr -d 'v') -lt 18 ]]; then
    echo -e "${YELLOW}Instalando Node.js v20.x LTS...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
fi

if ! command -v yarn &> /dev/null; then
    echo -e "${YELLOW}Instalando Yarn globalmente via npm...${NC}"
    sudo npm install -g yarn
fi

echo -e "${GREEN}✓ Node.js: $(node -v) | Yarn: $(yarn -v)${NC}"

# ------------------------------------------------------------------------------
# 4. Compilador Rust & Cargo
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[4/8] Verificando e configurando Compilador Rust...${NC}"
if ! command -v rustc &> /dev/null; then
    echo -e "${YELLOW}Instalando Rust via rustup oficial...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo -e "${GREEN}✓ Rust já instalado. Sincronizando com toolchain estável...${NC}"
    rustup update stable
fi

export PATH="$HOME/.cargo/bin:$PATH"
source "$HOME/.cargo/env" 2>/dev/null || true
echo -e "${GREEN}✓ Rust: $(rustc --version) | Cargo: $(cargo --version)${NC}"

# ------------------------------------------------------------------------------
# 5. Solana CLI (v1.18.26 Oficial do Projeto)
# ------------------------------------------------------------------------------
SOLANA_VERSION="v1.18.26"
echo -e "\n${BLUE}${BOLD}[5/8] Instalando e configurando Solana CLI (${SOLANA_VERSION})...${NC}"

if ! command -v solana &> /dev/null || [[ "$(solana --version 2>/dev/null)" != *"${SOLANA_VERSION#v}"* ]]; then
    echo -e "${YELLOW}Baixando Solana CLI ${SOLANA_VERSION}...${NC}"
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

# ------------------------------------------------------------------------------
# 6. AVM (Anchor Version Manager) & Anchor CLI
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[6/8] Instalando AVM e Anchor Framework...${NC}"
if ! command -v avm &> /dev/null; then
    echo -e "${YELLOW}Compilando AVM via cargo (aguarde alguns minutos)...${NC}"
    cargo install --git https://github.com/coral-xyz/anchor avm --locked
fi

if ! grep -q '.avm/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.avm/bin:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/.avm/bin:$PATH"

echo -e "${YELLOW}Ativando versão mais recente do Anchor...${NC}"
avm install latest
avm use latest

echo -e "${GREEN}✓ Anchor Framework: $(anchor --version)${NC}"

# ------------------------------------------------------------------------------
# 7. Configuração da Solana Devnet & Wallet Local
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[7/8] Configurando Solana Devnet e Carteira Local...${NC}"
solana config set --url devnet

mkdir -p "$HOME/.config/solana"
if [ ! -f "$HOME/.config/solana/id.json" ]; then
    echo -e "${YELLOW}Gerando nova carteira Devnet em ~/.config/solana/id.json...${NC}"
    solana-keygen new --no-bip39-passphrase --outfile "$HOME/.config/solana/id.json"
fi

DEV_WALLET=$(solana address)
echo -e "${GREEN}✓ Endereço da Carteira Devnet:${NC} ${BOLD}${DEV_WALLET}${NC}"

echo -e "${YELLOW}Solicitando SOL de teste via Airdrop na Devnet...${NC}"
solana airdrop 2 "$DEV_WALLET" 2>/dev/null || echo -e "${YELLOW}⚠️  Aviso: Limite de airdrop atingido. Acesse https://faucet.solana.com para solicitar saldo.${NC}"
echo -e "${GREEN}✓ Saldo Devnet Atual: $(solana balance)${NC}"

# ------------------------------------------------------------------------------
# 8. Setup do Contrato na Pasta fowlgenwars/program
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[8/8] Configurando e compilando o smart contract em '${PROGRAM_DIR}'...${NC}"

if [ -d "$PROGRAM_DIR" ]; then
    cd "$PROGRAM_DIR"

    echo -e "${YELLOW}Instalando dependências TypeScript (yarn install)...${NC}"
    yarn install

    echo -e "${YELLOW}Sincronizando Program ID (anchor keys sync)...${NC}"
    anchor keys sync

    echo -e "${YELLOW}Limpando downloads incompletos de platform-tools da Solana...${NC}"
    # 1. Limpa o download que ficou pela metade
    rm -rf "$HOME/.cache/solana/v1.41"
    rm -rf "$HOME/.cache/solana/v1.4"* 2>/dev/null || true

    echo -e "${YELLOW}Executando compilação do contrato (anchor build)...${NC}"
    # 2. Entra na pasta e roda a compilação de novo
    cd "$PROGRAM_DIR"

    if ! anchor build; then
        echo -e "${YELLOW}⚠️ Primeira tentativa falhou ou download foi interrompido. Limpando cache e tentando novamente...${NC}"
        # 1. Limpa o download que ficou pela metade
        rm -rf "$HOME/.cache/solana/v1.41"
        rm -rf "$HOME/.cache/solana/v1.4"* 2>/dev/null || true
        # 2. Entra na pasta e roda a compilação de novo
        cd "$PROGRAM_DIR"
        anchor build
    fi

    echo -e "${GREEN}✓ Contrato compilado e IDL gerado em: ${PROGRAM_DIR}/target/idl/fowlgen_wars.json${NC}"
else
    echo -e "${RED}Erro: Pasta do contrato não encontrada em ${PROGRAM_DIR}.${NC}"
    exit 1
fi

# ------------------------------------------------------------------------------
# Resumo Final e Comandos de Operação
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}=================================================================="
echo "    🎉 INSTALAÇÃO E SETUP DO FOWLGEN WARS CONCLUÍDOS COM SUCESSO! "
echo "==================================================================${NC}"
echo -e "${CYAN}${BOLD}Pasta Criada e Configurada:${NC}"
echo -e "  • Pasta do Projeto:  ${BOLD}${BASE_DIR}${NC}"
echo -e "  • Pasta do Contrato: ${BOLD}${PROGRAM_DIR}${NC}"
echo -e "  • Node.js:           ${BOLD}$(node -v)${NC}"
echo -e "  • Yarn:              ${BOLD}$(yarn -v)${NC}"
echo -e "  • Rust:              ${BOLD}$(rustc --version)${NC}"
echo -e "  • Solana CLI:        ${BOLD}$(solana --version)${NC}"
echo -e "  • Anchor Framework:  ${BOLD}$(anchor --version)${NC}"
echo -e "  • Carteira Devnet:   ${BOLD}${DEV_WALLET}${NC}"
echo ""
echo -e "${YELLOW}${BOLD}Como Testar e Publicar o Contrato:${NC}"
echo -e "  1. ${BOLD}cd ${PROGRAM_DIR}${NC}"
echo -e "  2. ${BOLD}anchor test${NC}                    -> Executa os testes automatizados TypeScript"
echo -e "  3. ${BOLD}anchor deploy${NC}                  -> Publica o contrato na Solana Devnet"
echo -e "  4. ${BOLD}anchor test --skip-local-validator${NC} -> Valida o contrato direto na Devnet"
echo ""
echo -e "${PURPLE}Para atualizar as variáveis de ambiente no seu terminal execute:${NC}"
echo -e "  ${BOLD}source ~/.bashrc${NC}"
echo "=================================================================="
