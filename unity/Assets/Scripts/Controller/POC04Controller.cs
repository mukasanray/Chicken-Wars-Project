using UnityEngine;
using ChickenWars.Solana;

namespace ChickenWars.POC
{
    public class POC04Controller : POCBaseController
    {
        protected override void InitializeScreen()
        {
            SolanaRuntime.EnsureExists();

            ChickenWarsProgram program = Object.FindFirstObjectByType<ChickenWarsProgram>();
            string programId = SolanaManager.Instance != null && SolanaManager.Instance.Config != null
                ? SolanaManager.Instance.Config.programId
                : string.Empty;

            screenUI.Configure(
                "POC 04 / UNITY ↔ ANCHOR",
                new[] { "Network", "Program", "Program ID", "Ready" },
                new[]
                {
                    "Devnet",
                    "chicken_wars",
                    string.IsNullOrWhiteSpace(programId) ? "NOT SET" : programId,
                    program != null ? program.DescribeReadiness() : "ChickenWarsProgram missing"
                });

            screenUI.AddButton("CALL INITIALIZE", CallProgram);
            Log("Calls ChickenWarsProgram.CallInitialize() for instruction initialize from the IDL.");
        }

        void CallProgram()
        {
            SolanaRuntime.EnsureExists();
            ChickenWarsProgram program = Object.FindFirstObjectByType<ChickenWarsProgram>();
            if (program == null)
            {
                Log("ChickenWarsProgram not found.");
                return;
            }

            screenUI.SetRow(3, program.DescribeReadiness());
            program.CallInitialize();
            Log("CallInitialize executed. On-chain confirmation needs Solana Unity SDK + a real Program ID.");
        }
    }
}
