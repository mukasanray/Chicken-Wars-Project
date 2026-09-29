using UnityEngine;
using FowlgenWars.Solana;

namespace FowlgenWars.POC
{
    public class POC04Controller : POCBaseController
    {
        protected override void InitializeScreen()
        {
            SolanaRuntime.EnsureExists();

            FowlgenWarsProgram program = Object.FindFirstObjectByType<FowlgenWarsProgram>();
            string programId = SolanaManager.Instance != null && SolanaManager.Instance.Config != null
                ? SolanaManager.Instance.Config.programId
                : string.Empty;

            screenUI.Configure(
                "POC 04 / UNITY ↔ ANCHOR",
                new[] { "Network", "Program", "Program ID", "Ready" },
                new[]
                {
                    "Devnet",
                    "fowlgen_wars",
                    string.IsNullOrWhiteSpace(programId) ? "NOT SET" : programId,
                    program != null ? program.DescribeReadiness() : "FowlgenWarsProgram missing"
                });

            screenUI.AddButton("CALL INITIALIZE", CallProgram);
            Log("Calls FowlgenWarsProgram.CallInitialize() for instruction initialize from the IDL.");
        }

        void CallProgram()
        {
            SolanaRuntime.EnsureExists();
            FowlgenWarsProgram program = Object.FindFirstObjectByType<FowlgenWarsProgram>();
            if (program == null)
            {
                Log("FowlgenWarsProgram not found.");
                return;
            }

            screenUI.SetRow(3, program.DescribeReadiness());
            program.CallInitialize();
            Log("CallInitialize executed. On-chain confirmation needs Solana Unity SDK + a real Program ID.");
        }
    }
}
