#!/usr/bin/env bash
# ==============================================================================
# 🐔 FOWLGEN WARS — INSTALADOR AUTOMATIZADO DO ANCHOR FRAMEWORK (UBUNTU/LINUX)
# ==============================================================================
# Repositório: https://github.com/mukasanray/Fowlgen-Wars-Project.git
# Stack: Rust + Solana CLI v1.18.26 + Anchor Framework + Node.js (v20) + Yarn
# ==============================================================================

set -e # Interrompe a execução se qualquer comando crítico falhar

# Cores para o terminal
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
echo -e "${CYAN}${BOLD}Instalador Automatizado do Ambiente On-Chain & Anchor Framework${NC}"
echo -e "${YELLOW}Repositório Oficial:${NC} https://github.com/mukasanray/Fowlgen-Wars-Project.git"
echo "------------------------------------------------------------------"

# ------------------------------------------------------------------------------
# 1. Dependências Base do Sistema (Ubuntu/Debian)
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[1/7] Instalando pacotes e compiladores essenciais do sistema...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev libudev-dev \
                    libclang-dev protobuf-compiler git curl wget tar bzip2

# ------------------------------------------------------------------------------
# 2. Node.js (v20 LTS) e Yarn
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[2/7] Configurando Node.js e Yarn...${NC}"
if ! command -v node &> /dev/null || [[ $(node -v | cut -d'.' -f1 | tr -d 'v') -lt 18 ]]; then
    echo -e "${YELLOW}Instalando Node.js v20.x LTS...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
fi

if ! command -v yarn &> /dev/null; then
    echo -e "${YELLOW}Instalando Yarn globalmente via npm...${NC}"
    sudo npm install -g yarn
fi

echo -e "${GREEN}✓ Node.js: $(node -v)${NC}"
echo -e "${GREEN}✓ Yarn: $(yarn -v)${NC}"

# ------------------------------------------------------------------------------
# 3. Compilador Rust & Toolchain Cargo
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[3/7] Configurando o Compilador Rust...${NC}"
if ! command -v rustc &> /dev/null; then
    echo -e "${YELLOW}Instalando Rust via rustup oficial...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo -e "${GREEN}✓ Rust já instalado. Sincronizando com canal estável...${NC}"
    rustup update stable
fi

source "$HOME/.cargo/env" || true
echo -e "${GREEN}✓ Rust: $(rustc --version)${NC}"
echo -e "${GREEN}✓ Cargo: $(cargo --version)${NC}"

# ------------------------------------------------------------------------------
# 4. Solana CLI (v1.18.26 Oficial do Projeto)
# ------------------------------------------------------------------------------
SOLANA_VERSION="v1.18.26"
echo -e "\n${BLUE}${BOLD}[4/7] Instalando Solana CLI (${SOLANA_VERSION})...${NC}"

if ! command -v solana &> /dev/null || [[ "$(solana --version 2>/dev/null)" != *"${SOLANA_VERSION#v}"* ]]; then
    echo -e "${YELLOW}Baixando binários pré-compilados da Solana ${SOLANA_VERSION}...${NC}"
    cd "$HOME"
    wget -q --show-progress "https://github.com/solana-labs/solana/releases/download/${SOLANA_VERSION}/solana-release-x86_64-unknown-linux-gnu.tar.bz2"
    rm -rf "$HOME/solana-release"
    tar jxf solana-release-x86_64-unknown-linux-gnu.tar.bz2
    rm -f solana-release-x86_64-unknown-linux-gnu.tar.bz2

    # Injetar PATH no .bashrc
    if ! grep -q 'solana-release/bin' "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/solana-release/bin:$PATH"' >> "$HOME/.bashrc"
    fi
fi

export PATH="$HOME/solana-release/bin:$PATH"
echo -e "${GREEN}✓ Solana CLI: $(solana --version)${NC}"

# ------------------------------------------------------------------------------
# 5. AVM (Anchor Version Manager) & Anchor Framework CLI
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[5/7] Instalando AVM e Anchor CLI...${NC}"
if ! command -v avm &> /dev/null; then
    echo -e "${YELLOW}Compilando AVM via cargo (aguarde alguns instantes)...${NC}"
    cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
fi

echo -e "${YELLOW}Instalando e ativando a versão mais recente do Anchor...${NC}"
avm install latest
avm use latest

echo -e "${GREEN}✓ Anchor Framework: $(anchor --version)${NC}"

# ------------------------------------------------------------------------------
# 6. Configuração da Solana Devnet & Wallet Local
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[6/7] Configurando Solana Devnet e Carteira Local...${NC}"
solana config set --url devnet

mkdir -p "$HOME/.config/solana"
if [ ! -f "$HOME/.config/solana/id.json" ]; then
    echo -e "${YELLOW}Gerando nova carteira de desenvolvimento em ~/.config/solana/id.json...${NC}"
    solana-keygen new --no-bip39-passphrase --outfile "$HOME/.config/solana/id.json"
fi

DEV_WALLET=$(solana address)
echo -e "${GREEN}✓ Endereço da Carteira Devnet:${NC} ${BOLD}${DEV_WALLET}${NC}"

echo -e "${YELLOW}Solicitando 2 SOL de teste via Airdrop na Devnet...${NC}"
solana airdrop 2 "$DEV_WALLET" || echo -e "${YELLOW}⚠️  Aviso: Airdrop automático atingiu rate limit. Acesse https://faucet.solana.com se precisar de saldo.${NC}"
echo -e "${GREEN}✓ Saldo Devnet Atual: $(solana balance)${NC}"

# ------------------------------------------------------------------------------
# 7. Setup do Programa Anchor do Fowlgen Wars
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}${BOLD}[7/7] Verificando e compilando o smart contract do repositório...${NC}"

# Identificar diretório do projeto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_PROGRAM_DIR=""

if [ -f "$SCRIPT_DIR/Anchor.toml" ]; then
    TARGET_PROGRAM_DIR="$SCRIPT_DIR"
elif [ -f "$SCRIPT_DIR/program/Anchor.toml" ]; then
    TARGET_PROGRAM_DIR="$SCRIPT_DIR/program"
elif [ -d "$HOME/Fowlgen-Wars-Project/program" ]; then
    TARGET_PROGRAM_DIR="$HOME/Fowlgen-Wars-Project/program"
fi

if [ -n "$TARGET_PROGRAM_DIR" ]; then
    echo -e "${CYAN}Entrando na pasta do contrato:${NC} $TARGET_PROGRAM_DIR"
    cd "$TARGET_PROGRAM_DIR"

    echo -e "${YELLOW}Instalando dependências TypeScript...${NC}"
    yarn install

    echo -e "${YELLOW}Sincronizando Program ID (anchor keys sync)...${NC}"
    anchor keys sync

    echo -e "${YELLOW}Executando compilação inicial (anchor build)...${NC}"
    anchor build

    echo -e "${GREEN}✓ Contrato compilado e IDL gerado em target/idl/fowlgen_wars.json!${NC}"
else
    echo -e "${YELLOW}Pasta /program não encontrada no caminho atual.${NC}"
    echo -e "Para clonar e testar o contrato execute:"
    echo -e "  git clone https://github.com/mukasanray/Fowlgen-Wars-Project.git"
    echo -e "  cd Fowlgen-Wars-Project/program && yarn install && anchor build"
fi

# ------------------------------------------------------------------------------
# Resumo Final e Comandos de Operação
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}=================================================================="
echo "    🎉 INSTALAÇÃO DO ANCHOR FRAMEWORK CONCLUÍDA COM SUCESSO!     "
echo "==================================================================${NC}"
echo -e "${CYAN}${BOLD}Resumo do Ambiente Instalado:${NC}"
echo -e "  • Node.js:  ${BOLD}$(node -v 2>/dev/null || echo 'OK')${NC}"
echo -e "  • Yarn:     ${BOLD}$(yarn -v 2>/dev/null || echo 'OK')${NC}"
echo -e "  • Rust:     ${BOLD}$(rustc --version 2>/dev/null || echo 'OK')${NC}"
echo -e "  • Solana:   ${BOLD}$(solana --version 2>/dev/null || echo 'OK')${NC}"
echo -e "  • Anchor:   ${BOLD}$(anchor --version 2>/dev/null || echo 'OK')${NC}"
echo -e "  • Cluster:  ${BOLD}Devnet (https://api.devnet.solana.com)${NC}"
echo -e "  • Wallet:   ${BOLD}~/.config/solana/id.json${NC}"
echo ""
echo -e "${YELLOW}${BOLD}Próximos Comandos na pasta 'program/':${NC}"
echo -e "  1. ${BOLD}anchor test${NC}                    -> Executa testes automatizados TypeScript"
echo -e "  2. ${BOLD}anchor deploy${NC}                  -> Publica o contrato na Solana Devnet"
echo -e "  3. ${BOLD}anchor test --skip-local-validator${NC} -> Valida o contrato direto na Devnet"
echo ""
echo -e "${PURPLE}Para atualizar seu terminal execute:${NC} ${BOLD}source ~/.bashrc${NC}"
echo "=================================================================="
