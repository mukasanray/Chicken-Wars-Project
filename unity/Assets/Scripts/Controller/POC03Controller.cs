using UnityEngine;
using FowlgenWars.Solana;

namespace FowlgenWars.POC
{
    public class POC03Controller : POCBaseController
    {
        protected override void InitializeScreen()
        {
            screenUI.Configure(
                "POC 03 / ANCHOR WORKSPACE",
                new[] { "IDL file", "Program name", "Program ID", "Instructions" },
                new[] { "-", "-", "-", "-" });

            screenUI.AddButton("VERIFY IDL", VerifyIdl);
            VerifyIdl();
            Log("Anchor program lives in /program (Rust). This screen only verifies the IDL copied into Unity.");
        }

        void VerifyIdl()
        {
            TextAsset idl = IdlInspector.LoadIdlAsset();
            if (idl == null)
            {
                screenUI.SetRow(0, "MISSING");
                screenUI.SetRow(1, "-");
                screenUI.SetRow(2, "-");
                screenUI.SetRow(3, "-");
                Log("IDL not found. Expected Assets/Solana/IDL/fowlgen_wars.json (Editor) or Resources/fowlgen_wars.");
                return;
            }

            string json = idl.text;
            string address = IdlInspector.ReadAddress(json);
            string name = IdlInspector.ReadProgramName(json);
            string[] instructions = IdlInspector.ReadInstructionNames(json);

            screenUI.SetRow(0, idl.name + ".json");
            screenUI.SetRow(1, string.IsNullOrEmpty(name) ? "(none)" : name);
            screenUI.SetRow(2, string.IsNullOrEmpty(address) ? "(none)" : Truncate(address, 20));
            screenUI.SetRow(3, instructions.Length == 0 ? "(none)" : string.Join(", ", instructions));

            if (IdlInspector.IsPlaceholderProgramId(address))
                Log("IDL loaded. Program ID is still 11111111111111111111111111111111 — run anchor keys list / sync / build / deploy, then replace the IDL.");
            else
                Log("IDL loaded with program ID " + address + ".");
        }

        static string Truncate(string value, int keep)
        {
            if (string.IsNullOrEmpty(value) || value.Length <= keep)
                return value;
            return value.Substring(0, keep) + "…";
        }
    }
}
