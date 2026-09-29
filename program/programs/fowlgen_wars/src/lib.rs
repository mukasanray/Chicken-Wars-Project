use anchor_lang::prelude::*;

// IMPORTANTE: Substitua pelo Program ID real após executar:
//   anchor keys list
// E depois sincronize com:
//   anchor keys sync
declare_id!("11111111111111111111111111111111");

#[program]
pub mod fowlgen_wars {
    use super::*;

    /// Instrução de inicialização do programa Fowlgen Wars.
    ///
    /// Esta é a primeira instrução — prova que o programa está deployado
    /// e consegue receber chamadas.
    ///
    /// Evolução futura:
    ///   initialize → initialize_fowlgen → upgrade_fowlgen
    ///   → record_battle → claim_reward
    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Fowlgen Wars program initialized!");
        msg!("Signer: {}", ctx.accounts.signer.key());

        Ok(())
    }
}

/// Accounts para a instrução `initialize`.
///
/// Apenas requer um `Signer` — a wallet que está chamando o programa.
/// Futuramente será expandido com PDAs para estado do jogo, fowlgens, etc.
#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(mut)]
    pub signer: Signer<'info>,
}
