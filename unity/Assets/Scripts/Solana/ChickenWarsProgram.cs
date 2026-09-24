using UnityEngine;

namespace ChickenWars.Solana
{
    /// <summary>
    /// Abstração para chamar as instruções do programa Chicken Wars on-chain.
    /// 
    /// Esta classe encapsula as chamadas ao smart contract via Solana SDK.
    /// O IDL (Interface Definition Language) gerado pelo Anchor define
    /// as instruções e accounts disponíveis.
    /// 
    /// Fluxo:
    ///   Rust (lib.rs)
    ///     → anchor build
    ///       → IDL (chicken_wars.json)
    ///         → ChickenWarsProgram.cs (esta classe)
    ///           → Solana SDK → Transaction → Cluster
    /// 
    /// IMPORTANTE: Não editar o IDL manualmente.
    /// A origem é sempre: Rust → Anchor build → IDL → Unity.
    /// 
    /// Evolução das instruções:
    ///   initialize (atual)
    ///   → initialize_chicken
    ///   → upgrade_chicken  
    ///   → record_battle
    ///   → claim_reward
    /// </summary>
    public class ChickenWarsProgram : MonoBehaviour
    {
        [Header("IDL")]
        [SerializeField]
        [Tooltip("Referência ao IDL JSON do programa (Assets/Solana/IDL/chicken_wars.json)")]
        private TextAsset idlJson;

        public TextAsset IdlJson => idlJson;

        public void BindIdl(TextAsset asset)
        {
            if (asset != null)
                idlJson = asset;
            else if (idlJson == null)
                idlJson = IdlInspector.LoadIdlAsset();
        }

        public string DescribeReadiness()
        {
            if (SolanaManager.Instance == null)
                return "SolanaManager missing";
            if (!SolanaManager.Instance.IsInitialized)
                return "SolanaManager not initialized";
            if (SolanaManager.Instance.Config == null || !SolanaManager.Instance.Config.IsProgramConfigured())
                return "Program ID empty in SolanaConfig";
            if (IdlInspector.IsPlaceholderProgramId(SolanaManager.Instance.Config.programId))
                return "Program ID is still the Anchor placeholder";
            if (idlJson == null)
                return "IDL TextAsset not assigned";
            return "Ready";
        }

        /// <summary>
        /// Program ID do contrato (vem do SolanaConfig).
        /// </summary>
        public string ProgramId
        {
            get
            {
                if (SolanaManager.Instance != null && SolanaManager.Instance.Config != null)
                {
                    return SolanaManager.Instance.Config.programId;
                }
                return string.Empty;
            }
        }

        /// <summary>
        /// Verifica se o programa está configurado e pronto para chamadas.
        /// </summary>
        public bool IsReady
        {
            get
            {
                return SolanaManager.Instance != null
                    && SolanaManager.Instance.IsInitialized
                    && SolanaManager.Instance.Config != null
                    && SolanaManager.Instance.Config.IsProgramConfigured()
                    && !IdlInspector.IsPlaceholderProgramId(SolanaManager.Instance.Config.programId)
                    && idlJson != null;
            }
        }

        /// <summary>
        /// Chama a instrução `initialize` do programa.
        /// 
        /// POC mínimo — prova que Unity consegue chamar o smart contract.
        /// 
        /// Resultado esperado no log do programa:
        ///   "Chicken Wars program initialized!"
        ///   "Signer: <wallet_public_key>"
        /// </summary>
        public async void CallInitialize()
        {
            if (idlJson == null)
                BindIdl(null);

            if (!IsReady)
            {
                Debug.LogError("[ChickenWarsProgram] Programa não está pronto. " +
                    DescribeReadiness());
                return;
            }

            Debug.Log("[ChickenWarsProgram] Chamando instrução 'initialize'...");

            // TODO: Quando o Solana Unity SDK for instalado:
            //
            // 1. Deserializar o IDL
            //    var idl = JsonUtility.FromJson<AnchorIdl>(idlJson.text);
            //
            // 2. Construir a transação usando o SDK
            //    var tx = new Transaction();
            //    tx.Add(/* instruction baseada no IDL */);
            //
            // 3. Enviar via WalletManager para assinatura
            //    var signature = await WalletManager.Instance.SignAndSend(tx);
            //
            // 4. Confirmar
            //    await SolanaConnection.ConfirmTransaction(signature);
            //
            // 5. Log resultado
            //    Debug.Log($"[ChickenWarsProgram] Initialize confirmed: {signature}");

            await System.Threading.Tasks.Task.CompletedTask;
            Debug.Log("[ChickenWarsProgram] Initialize chamado (placeholder — aguardando SDK).");
        }
    }
}
