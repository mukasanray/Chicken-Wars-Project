using UnityEngine;

namespace FowlgenWars.POC
{
    public class POC01Controller : POCBaseController
    {
        protected override void InitializeScreen()
        {
            screenUI.Configure(
                "POC 01 / PROJECT FOUNDATION",
                new[] { "Unity", "Platform", "Scene", "Product" },
                new[]
                {
                    Application.unityVersion,
                    Application.platform.ToString(),
                    gameObject.scene.name,
                    Application.productName
                });

            screenUI.AddButton("TEST UNITY", TestFoundation);
            Log("Unity scene loaded. Foundation check is local (no blockchain).");
        }

        void TestFoundation()
        {
            screenUI.SetRow(0, Application.unityVersion);
            screenUI.SetRow(1, Application.platform.ToString());
            Log("POC 01 OK: Play Mode, canvas and button are running.");
        }
    }
}
