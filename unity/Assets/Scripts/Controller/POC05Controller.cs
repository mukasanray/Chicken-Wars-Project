using UnityEngine;
using FowlgenWars.Solana;

namespace FowlgenWars.POC
{
    public class POC05Controller : POCBaseController
    {
        protected override void InitializeScreen()
        {
            SolanaRuntime.EnsureExists();

            screenUI.Configure(
                "POC 05 / WALLET & TRANSACTION",
                new[] { "Network", "Wallet", "Address", "Tx" },
                new[] { "Devnet", WalletLabel(), AddressLabel(), "IDLE" });

            screenUI.AddButton("CONNECT WALLET", ConnectWallet);
            screenUI.AddButton("SEND TX PLACEHOLDER", SendTransaction);
            Log("Wallet connect is the blockchain sign-in for this project. There is no email/password login screen.");
        }

        void ConnectWallet()
        {
            SolanaRuntime.EnsureExists();
            if (WalletManager.Instance == null)
            {
                Log("WalletManager not found.");
                return;
            }

            WalletManager.Instance.ConnectWallet();
            screenUI.SetRow(1, WalletLabel());
            screenUI.SetRow(2, AddressLabel());
            Log("ConnectWallet() ran. Value is a placeholder until Solana Unity SDK wallet adapter is wired.");
        }

        void SendTransaction()
        {
            SolanaRuntime.EnsureExists();
            if (TransactionManager.Instance == null)
            {
                Log("TransactionManager not found.");
                screenUI.SetRow(3, "NO MANAGER");
                return;
            }

            TransactionManager.Instance.SendTransaction("initialize");
            screenUI.SetRow(3, "PLACEHOLDER SENT");
            Log("SendTransaction('initialize') ran. Sign/send/confirm need SDK + connected wallet.");
        }

        static string WalletLabel()
        {
            if (WalletManager.Instance == null)
                return "NO MANAGER";
            return WalletManager.Instance.Status.ToString();
        }

        static string AddressLabel()
        {
            if (WalletManager.Instance == null || string.IsNullOrEmpty(WalletManager.Instance.PublicKey))
                return "--";
            string key = WalletManager.Instance.PublicKey;
            return key.Length <= 20 ? key : key.Substring(0, 20) + "…";
        }
    }
}
