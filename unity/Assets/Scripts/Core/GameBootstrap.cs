using UnityEngine;

namespace ChickenWars.Core
{
    /// <summary>
    /// Entry point do Chicken Wars.
    /// Responsável por inicializar os sistemas core do jogo.
    /// Deve ser adicionado a um GameObject na primeira cena carregada.
    /// </summary>
    public class GameBootstrap : MonoBehaviour
    {
        [SerializeField]
        private string gameVersion = "0.1.0";

        private void Awake()
        {
            Debug.Log($"[ChickenWars] Chicken Wars iniciado. Version: {gameVersion}");
            Debug.Log($"[ChickenWars] Platform: {Application.platform}");
            Debug.Log($"[ChickenWars] Unity: {Application.unityVersion}");
        }
    }
}
