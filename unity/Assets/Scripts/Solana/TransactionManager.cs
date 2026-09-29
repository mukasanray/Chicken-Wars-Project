using UnityEngine;

namespace FowlgenWars.Solana
{
    /// <summary>
    /// Gerenciamento de transações Solana.
    /// 
    /// Responsabilidades:
    /// - Construir transações
    /// - Enviar para assinatura (via WalletManager)
    /// - Enviar para o cluster (via SolanaConnection)
    /// - Confirmar transações
    /// 
    /// Fluxo completo:
    ///   TransactionManager.BuildTransaction()
    ///     → WalletManager.SignTransaction()
    ///       → SolanaConnection.SendTransaction()
    ///         → Cluster processa
    ///           → TransactionManager.ConfirmTransaction()
    ///             → Callback com resultado
    /// 
    /// IMPORTANTE para gameplay:
    /// O combate em tempo real NÃO usa transações Solana.
    /// Transações são usadas apenas para:
    /// - Inicialização do jogador
    /// - Registro de resultados de batalha
    /// - Claim de rewards
    /// - Operações com NFTs/tokens
    /// 
    /// O gameplay roda em Unity, localmente.
    /// Solana é usado para resultados e progressão.
    /// </summary>
    public class TransactionManager : MonoBehaviour
    {
        public static TransactionManager Instance { get; private set; }

        /// <summary>
        /// Status de uma transação.
        /// </summary>
        public enum TransactionStatus
        {
            Building,
            WaitingSignature,
            Sending,
            Confirming,
            Confirmed,
            Failed
        }

        [Header("Settings")]
        [SerializeField]
        [Tooltip("Número máximo de tentativas de confirmação.")]
        private int maxConfirmRetries = 3;

        [SerializeField]
        [Tooltip("Intervalo entre tentativas de confirmação (segundos).")]
        private float confirmRetryInterval = 2f;

        /// <summary>
        /// Número máximo de tentativas de confirmação.
        /// </summary>
        public int MaxConfirmRetries => maxConfirmRetries;

        /// <summary>
        /// Intervalo entre tentativas de confirmação (segundos).
        /// </summary>
        public float ConfirmRetryInterval => confirmRetryInterval;

        private void Awake()
        {
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }

            Instance = this;
        }

        /// <summary>
        /// Constrói, assina e envia uma transação.
        /// 
        /// Fluxo:
        ///   Build → Sign (wallet) → Send → Confirm
        /// </summary>
        /// <param name="instructionName">Nome da instrução para log/debug.</param>
        public async void SendTransaction(string instructionName)
        {
            if (WalletManager.Instance == null || !WalletManager.Instance.IsConnected)
            {
                Debug.LogError("[TransactionManager] Wallet não conectada.");
                return;
            }

            if (SolanaManager.Instance == null || !SolanaManager.Instance.IsInitialized)
            {
                Debug.LogError("[TransactionManager] SolanaManager não inicializado.");
                return;
            }

            Debug.Log($"[TransactionManager] Construindo transação: {instructionName}");

            // TODO: Quando o Solana Unity SDK for instalado:
            //
            // 1. BUILD — Construir a transação
            //    var transaction = new Transaction();
            //    transaction.Add(instruction);
            //    transaction.FeePayer = WalletManager.Instance.PublicKey;
            //    var blockhash = await connection.GetLatestBlockhash();
            //    transaction.RecentBlockhash = blockhash;
            //
            // 2. SIGN — Wallet assina
            //    var signedTx = await WalletManager.Instance.SignTransaction(transaction);
            //
            // 3. SEND — Enviar para o cluster
            //    var signature = await connection.SendTransaction(signedTx);
            //    Debug.Log($"[TransactionManager] Enviada: {signature}");
            //
            // 4. CONFIRM — Aguardar confirmação
            //    await connection.ConfirmTransaction(signature);
            //    Debug.Log($"[TransactionManager] Confirmada: {signature}");

            await System.Threading.Tasks.Task.CompletedTask;
            Debug.Log($"[TransactionManager] Transação '{instructionName}' processada (placeholder: retries={maxConfirmRetries}, interval={confirmRetryInterval}s).");
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }
    }
}
