using UnityEngine;

namespace FowlgenWars.Solana
{
    /// <summary>
    /// Gerenciamento de wallet do jogador.
    /// 
    /// Responsabilidades:
    /// - Conectar/desconectar wallet
    /// - Expor public key do jogador
    /// - Solicitar assinatura de transações
    /// 
    /// PRINCÍPIO FUNDAMENTAL:
    /// O jogo NÃO possui a chave privada do jogador.
    /// A wallet é responsável pela assinatura.
    /// 
    /// Arquitetura:
    ///   Wallet
    ///     ├── Public Key (leitura)
    ///     └── Sign (assinatura)
    ///          ↓
    ///     Transaction
    ///          ↓
    ///       Solana
    /// 
    /// IMPORTANTE: A implementação concreta depende do Solana Unity SDK.
    /// O SDK define como conectar wallets (Phantom, Solflare, in-app, etc).
    /// </summary>
    public class WalletManager : MonoBehaviour
    {
        public static WalletManager Instance { get; private set; }

        /// <summary>
        /// Status da wallet.
        /// </summary>
        public enum WalletStatus
        {
            Disconnected,
            Connecting,
            Connected,
            Error
        }

        private WalletStatus status = WalletStatus.Disconnected;
        private string publicKey = string.Empty;

        /// <summary>
        /// Status atual da wallet.
        /// </summary>
        public WalletStatus Status => status;

        /// <summary>
        /// Indica se a wallet está conectada.
        /// </summary>
        public bool IsConnected => status == WalletStatus.Connected;

        /// <summary>
        /// Public key da wallet conectada.
        /// Vazio se não conectada.
        /// </summary>
        public string PublicKey => publicKey;

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
        /// Conecta a wallet do jogador.
        /// 
        /// Para POC/Devnet, pode usar uma wallet de teste.
        /// Em produção, conectará via deep link (Phantom, Solflare, etc).
        /// </summary>
        public void ConnectWallet()
        {
            Debug.Log("[WalletManager] Conectando wallet...");
            status = WalletStatus.Connecting;

            // TODO: Quando o Solana Unity SDK for instalado:
            //
            // Opção A — In-app wallet (para POC/teste):
            //   var wallet = new InAppWallet(RpcCluster.DevNet);
            //   await wallet.Login();
            //   publicKey = wallet.Account.PublicKey;
            //
            // Opção B — External wallet (Phantom, Solflare):
            //   await PhantomConnect.Connect();
            //   publicKey = PhantomConnect.PublicKey;
            //
            // NUNCA armazenar private key ou seed phrase no código!

            // Placeholder para POC
            publicKey = "WALLET_NOT_CONNECTED";
            status = WalletStatus.Connected;
            Debug.Log($"[WalletManager] Wallet conectada (placeholder): {publicKey}");
        }

        /// <summary>
        /// Desconecta a wallet.
        /// </summary>
        public void DisconnectWallet()
        {
            publicKey = string.Empty;
            status = WalletStatus.Disconnected;
            Debug.Log("[WalletManager] Wallet desconectada.");
        }

        /// <summary>
        /// Solicita assinatura de uma transação.
        /// A wallet é responsável por assinar — o jogo nunca tem a private key.
        /// </summary>
        /// <param name="transactionData">Dados da transação serializada.</param>
        /// <returns>Assinatura da transação (placeholder).</returns>
        public string SignTransaction(byte[] transactionData)
        {
            if (!IsConnected)
            {
                Debug.LogError("[WalletManager] Wallet não conectada. Conecte antes de assinar.");
                return string.Empty;
            }

            Debug.Log("[WalletManager] Solicitando assinatura...");

            // TODO: Quando o SDK for instalado:
            //   var signedTx = await wallet.SignTransaction(transaction);
            //   return signedTx.Signature;

            Debug.Log("[WalletManager] Transação assinada (placeholder).");
            return "PLACEHOLDER_SIGNATURE";
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
