using UnityEngine;

namespace FowlgenWars.Solana
{
    /// <summary>
    /// Gerencia a conexão com o cluster Solana.
    /// 
    /// Responsabilidades:
    /// - Testar conectividade com o RPC
    /// - Monitorar status da conexão
    /// - Reconectar quando necessário
    /// 
    /// IMPORTANTE: A implementação concreta depende do Solana Unity SDK escolhido.
    /// Esta classe fornece a interface e o padrão que será preenchido.
    /// 
    /// Fluxo esperado:
    /// SolanaConnection.Connect()
    ///   → SDK.CreateClient(rpcUrl)
    ///   → SDK.GetLatestBlockhash()  // health check
    ///   → Connected = true
    ///   → Log: "Connected to Solana Devnet"
    /// </summary>
    public class SolanaConnection : MonoBehaviour
    {
        /// <summary>
        /// Status atual da conexão.
        /// </summary>
        public enum ConnectionStatus
        {
            Disconnected,
            Connecting,
            Connected,
            Error
        }

        [Header("Settings")]
        [SerializeField]
        private float healthCheckInterval = 30f;

        private ConnectionStatus status = ConnectionStatus.Disconnected;
        private float lastHealthCheck;

        /// <summary>
        /// Status atual da conexão com o cluster.
        /// </summary>
        public ConnectionStatus Status => status;

        /// <summary>
        /// Indica se está conectado ao cluster.
        /// </summary>
        public bool IsConnected => status == ConnectionStatus.Connected;

        /// <summary>
        /// Tenta conectar ao cluster Solana usando o config do SolanaManager.
        /// </summary>
        public void Connect()
        {
            if (SolanaManager.Instance == null || !SolanaManager.Instance.IsInitialized)
            {
                Debug.LogError("[SolanaConnection] SolanaManager não inicializado.");
                status = ConnectionStatus.Error;
                return;
            }

            var config = SolanaManager.Instance.Config;

            Debug.Log($"[SolanaConnection] Conectando ao cluster: {config.rpcUrl}");
            status = ConnectionStatus.Connecting;

            // TODO: Quando o Solana Unity SDK for instalado:
            // 1. Criar RPC client com config.rpcUrl
            // 2. Chamar GetLatestBlockhash() como health check
            // 3. Se sucesso: status = Connected
            // 4. Se falha: status = Error

            // Placeholder — simula conexão bem-sucedida para POC
            status = ConnectionStatus.Connected;
            lastHealthCheck = Time.time;
            Debug.Log("[SolanaConnection] Connected to Solana Devnet (placeholder)");
        }

        /// <summary>
        /// Desconecta do cluster.
        /// </summary>
        public void Disconnect()
        {
            status = ConnectionStatus.Disconnected;
            Debug.Log("[SolanaConnection] Desconectado do cluster.");
        }

        private void Update()
        {
            // Health check periódico quando conectado
            if (IsConnected && Time.time - lastHealthCheck > healthCheckInterval)
            {
                lastHealthCheck = Time.time;
                // TODO: GetLatestBlockhash() como heartbeat
            }
        }
    }
}
