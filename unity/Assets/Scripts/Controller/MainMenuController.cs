using UnityEngine;

namespace ChickenWars.POC
{
    public class MainMenuController : POCBaseController
    {
        protected override void InitializeScreen()
        {
            screenUI.Configure(
                "POC LAB / SOLANA + ANCHOR",
                new[] { "Cluster", "Goal", "SDK", "Entry" },
                new[] { "Devnet", "Verify each POC screen", SolanaSdkStatus(), "MainMenu" });

            screenUI.AddButton("POC 01  FOUNDATION", () => POCScreenUI.LoadPoc(POCSceneRoot.ScenePoc01));
            screenUI.AddButton("POC 02  SOLANA RPC", () => POCScreenUI.LoadPoc(POCSceneRoot.ScenePoc02));
            screenUI.AddButton("POC 03  ANCHOR IDL", () => POCScreenUI.LoadPoc(POCSceneRoot.ScenePoc03));
            screenUI.AddButton("POC 04  CALL PROGRAM", () => POCScreenUI.LoadPoc(POCSceneRoot.ScenePoc04));
            screenUI.AddButton("POC 05  WALLET / TX", () => POCScreenUI.LoadPoc(POCSceneRoot.ScenePoc05));

            Log("Open each POC, press the action button, read LOG. Blockchain calls stay placeholders until the Solana Unity SDK is in Packages.");
        }

        static string SolanaSdkStatus()
        {
            return ChickenWars.Solana.SolanaSdkProbe.IsSdkAssemblyLoaded(out string detail)
                ? detail
                : "NOT INSTALLED";
        }
    }
}
