using UnityEngine;

namespace FowlgenWars.Solana
{
    /// <summary>
    /// Creates SolanaManager, connection, wallet, transactions and program bindings
    /// if the scene does not already contain them.
    /// </summary>
    public class SolanaRuntime : MonoBehaviour
    {
        public static SolanaRuntime Instance { get; private set; }

        SolanaConfig runtimeConfig;

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
        static void Bootstrap()
        {
            EnsureExists();
        }

        public static SolanaRuntime EnsureExists()
        {
            if (Instance != null)
                return Instance;

            SolanaRuntime existing = FindFirstObjectByType<SolanaRuntime>();
            if (existing != null)
            {
                Instance = existing;
                return existing;
            }

            var go = new GameObject("SolanaRuntime");
            DontDestroyOnLoad(go);
            return go.AddComponent<SolanaRuntime>();
        }

        void Awake()
        {
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }

            Instance = this;
            DontDestroyOnLoad(gameObject);
            BindComponents();
        }

        void BindComponents()
        {
            if (runtimeConfig == null)
            {
                runtimeConfig = ScriptableObject.CreateInstance<SolanaConfig>();
                runtimeConfig.name = "RuntimeSolanaConfig";
            }

            SolanaManager manager = GetComponent<SolanaManager>();
            if (manager == null)
                manager = gameObject.AddComponent<SolanaManager>();
            manager.BindConfig(runtimeConfig);

            if (GetComponent<SolanaConnection>() == null)
                gameObject.AddComponent<SolanaConnection>();

            if (GetComponent<WalletManager>() == null)
                gameObject.AddComponent<WalletManager>();

            if (GetComponent<TransactionManager>() == null)
                gameObject.AddComponent<TransactionManager>();

            FowlgenWarsProgram program = GetComponent<FowlgenWarsProgram>();
            if (program == null)
                program = gameObject.AddComponent<FowlgenWarsProgram>();
            program.BindIdl(IdlInspector.LoadIdlAsset());
        }
    }
}
