# FOWLGEN WARS — Guia Completo de Configuração do Ambiente On-Chain

Este documento apresenta o passo a passo completo, desde a ativação inicial até a compilação do contrato inteligente, para configurar o ambiente de desenvolvimento do jogo FOWLGEN WARS utilizando WSL (Ubuntu), Rust, Solana e Anchor.

## 1. Stack tecnológica e versões oficiais

| Ferramenta/Tecnologia | Versão ou especificação |
| --- | --- |
| Ambiente base | Windows 11 com WSL2 (distribuição Ubuntu) |
| Linguagem de programação | Rust (via rustup/cargo) |
| Solana CLI | `v1.18.26` |
| Anchor CLI/AVM | Latest (gerenciado via Anchor Version Manager) |

## 2. Instalação no WSL (Ubuntu)

### 2.1 Instalar dependências básicas do sistema

Abra o terminal do Ubuntu e execute os comandos de atualização e instalação de pacotes essenciais:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential pkg-config libssl-dev git curl wget -y
```

### 2.2 Instalar o compilador Rust

Instale o ambiente Rust utilizando o instalador oficial:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

### 2.3 Instalar a Solana CLI (`v1.18.26`)

Faça o download do pacote binário oficial da Solana, extraia e configure o PATH global:

```bash
cd ~
wget https://github.com/solana-labs/solana/releases/download/v1.18.26/solana-release-x86_64-unknown-linux-gnu.tar.bz2
tar jxf solana-release-x86_64-unknown-linux-gnu.tar.bz2
echo 'export PATH="$HOME/solana-release/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 2.4 Instalar o AVM e a Anchor CLI

Compile o Anchor Version Manager via Cargo e instale a versão mais recente do Anchor:

```bash
cargo install --git https://github.com/coral-xyz/anchor avm --locked
avm install latest
avm use latest
```

## 3. Inicialização do projeto FOWLGEN WARS

Para criar a estrutura inicial do projeto de contratos inteligentes do jogo e testar a compilação:

```bash
anchor init folwgen_wars_contract
cd folwgen_wars_contract
anchor build
```

## 4. Estrutura de pastas principais

- `programs/fowlgen_wars_contract/src/lib.rs`: contém a lógica principal do contrato inteligente em Rust.
- `Anchor.toml`: ficheiro de configuração das redes (`localnet` e `devnet`).
- `tests/`: scripts de teste em TypeScript.
