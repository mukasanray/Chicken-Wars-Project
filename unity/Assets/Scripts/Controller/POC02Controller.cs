using UnityEngine;
using FowlgenWars.Solana;

namespace FowlgenWars.POC
{
    public class POC02Controller : POCBaseController
    {
        protected override void InitializeScreen()
        {
            SolanaRuntime.EnsureExists();

            string rpc = SolanaManager.Instance != null && SolanaManager.Instance.Config != null
                ? SolanaManager.Instance.Config.rpcUrl
                : "(no config)";

            bool sdk = SolanaSdkProbe.IsSdkAssemblyLoaded(out string sdkDetail);

            screenUI.Configure(
                "POC 02 / SOLANA DEVNET",
                new[] { "RPC", "Manager", "SDK", "Connection" },
                new[]
                {
                    rpc,
                    SolanaManager.Instance != null && SolanaManager.Instance.IsInitialized ? "INITIALIZED" : "MISSING",
                    sdk ? sdkDetail : "NOT INSTALLED",
                    ConnectionLabel()
                });

            screenUI.AddButton("TEST RPC", TestRpc);
            Log("This screen calls SolanaConnection.Connect(). Without Solana Unity SDK the result is still a placeholder.");
        }

        void TestRpc()
        {
            SolanaRuntime.EnsureExists();

            SolanaConnection connection = FindFirstObjectByType<SolanaConnection>();
            if (connection == null)
            {
                Log("SolanaConnection component not found.");
                screenUI.SetRow(3, "ERROR");
                return;
            }

            connection.Connect();
            screenUI.SetRow(3, ConnectionLabel());

            bool sdk = SolanaSdkProbe.IsSdkAssemblyLoaded(out string sdkDetail);
            screenUI.SetRow(2, sdk ? sdkDetail : "NOT INSTALLED");

            if (!sdk)
                Log("RPC placeholder ran. Install Solana Unity SDK, then this button should hit api.devnet.solana.com.");
            else
                Log("SDK assembly detected (" + sdkDetail + "). Connect() still needs the SDK client wired in SolanaConnection.");
        }

        static string ConnectionLabel()
        {
            SolanaConnection connection = Object.FindFirstObjectByType<SolanaConnection>();
            return connection == null ? "NONE" : connection.Status.ToString();
        }
    }
}
