using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace FowlgenWars.POC
{
    public class POCScreenUI : MonoBehaviour
    {
        public const string MenuSceneName = "MainMenu";

        [SerializeField] Canvas canvas;

        readonly List<Text> valueLabels = new List<Text>();
        readonly List<string> logLines = new List<string>();
        Text logText;
        Transform buttonColumn;

        public static POCScreenUI EnsureOn(GameObject host)
        {
            POCScreenUI existing = FindFirstObjectByType<POCScreenUI>();
            if (existing != null)
                return existing;

            return host.AddComponent<POCScreenUI>();
        }

        public void Configure(string subtitle, string[] labels, string[] values, params string[] unusedButtonCaptions)
        {
            EnsureCanvas();
            ClearDynamicUI();
            valueLabels.Clear();
            logLines.Clear();

            CreateText("Title", "FOWLGEN WARS", 48, new Vector2(0, 820), new Vector2(960, 80));
            CreateText("Subtitle", subtitle, 28, new Vector2(0, 740), new Vector2(960, 60));

            float y = 620;
            int count = Math.Min(labels.Length, values.Length);
            for (int i = 0; i < count; i++)
            {
                CreateText("Label_" + i, labels[i], 24, new Vector2(-260, y), new Vector2(420, 48), TextAnchor.MiddleLeft);
                valueLabels.Add(CreateText("Value_" + i, values[i], 22, new Vector2(260, y), new Vector2(420, 48), TextAnchor.MiddleRight));
                y -= 70;
            }

            buttonColumn = new GameObject("Buttons", typeof(RectTransform)).transform;
            buttonColumn.SetParent(canvas.transform, false);
            var columnRect = buttonColumn.GetComponent<RectTransform>();
            columnRect.anchoredPosition = new Vector2(0, y - 80);
            columnRect.sizeDelta = new Vector2(640, 400);

            logText = CreateText("Log", "LOG\nReady.", 20, new Vector2(0, -780), new Vector2(960, 220), TextAnchor.UpperLeft);

            if (SceneManager.GetActiveScene().name != MenuSceneName)
                AddButton("BACK TO MENU", LoadMenu, new Color(0.18f, 0.18f, 0.22f, 1f));

            if (unusedButtonCaptions != null && unusedButtonCaptions.Length > 0)
            {
                // Kept for existing Configure(subtitle, labels, values, buttonText) calls.
            }
        }

        public void SetRow(int index, string value)
        {
            if (index < 0 || index >= valueLabels.Count)
                return;
            valueLabels[index].text = value;
        }

        public Button AddButton(string caption, UnityAction action, Color? color = null)
        {
            EnsureCanvas();
            if (buttonColumn == null)
                return null;

            int index = buttonColumn.childCount;
            var go = new GameObject("POCButton_" + index, typeof(RectTransform), typeof(Image), typeof(Button));
            go.transform.SetParent(buttonColumn, false);

            var rect = go.GetComponent<RectTransform>();
            rect.sizeDelta = new Vector2(620, 88);
            rect.anchoredPosition = new Vector2(0, -index * 100);

            go.GetComponent<Image>().color = color ?? new Color(0.12f, 0.55f, 0.28f, 1f);

            var label = CreateText("Label", caption, 26, Vector2.zero, new Vector2(620, 88));
            label.transform.SetParent(go.transform, false);
            label.GetComponent<RectTransform>().anchoredPosition = Vector2.zero;

            var button = go.GetComponent<Button>();
            button.onClick.AddListener(action);
            return button;
        }

        public void SetAction(UnityAction action)
        {
            if (buttonColumn == null || buttonColumn.childCount == 0)
                return;

            var button = buttonColumn.GetChild(buttonColumn.childCount - 1).GetComponent<Button>();
            if (button == null)
                return;

            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(action);
        }

        public void SetLog(string message)
        {
            logLines.Clear();
            AppendLog(message);
        }

        public void AppendLog(string message)
        {
            string line = DateTime.Now.ToString("HH:mm:ss") + "  " + message;
            logLines.Add(line);
            while (logLines.Count > 8)
                logLines.RemoveAt(0);

            if (logText != null)
                logText.text = "LOG\n" + string.Join("\n", logLines);

            Debug.Log("[Fowlgen Wars] " + message);
        }

        public static void LoadMenu()
        {
            SceneManager.LoadScene(MenuSceneName);
        }

        public static void LoadPoc(string sceneName)
        {
            SceneManager.LoadScene(sceneName);
        }

        void EnsureCanvas()
        {
            EnsureEventSystem();

            if (canvas != null)
                return;

            var go = new GameObject("Canvas", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            go.transform.SetParent(transform, false);
            canvas = go.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;

            var scaler = go.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1080, 1920);
            scaler.matchWidthOrHeight = 0.5f;

            var bg = new GameObject("Background", typeof(RectTransform), typeof(Image));
            bg.transform.SetParent(go.transform, false);
            var bgRect = bg.GetComponent<RectTransform>();
            bgRect.anchorMin = Vector2.zero;
            bgRect.anchorMax = Vector2.one;
            bgRect.offsetMin = Vector2.zero;
            bgRect.offsetMax = Vector2.zero;
            bg.GetComponent<Image>().color = new Color(0.05f, 0.09f, 0.07f, 1f);
            bg.GetComponent<Image>().raycastTarget = false;
        }

        static void EnsureEventSystem()
        {
            if (FindFirstObjectByType<EventSystem>() != null)
                return;

            var go = new GameObject("EventSystem");
            go.AddComponent<EventSystem>();

            Type inputModule = Type.GetType("UnityEngine.InputSystem.UI.InputSystemUIInputModule, Unity.InputSystem");
            if (inputModule != null)
                go.AddComponent(inputModule);
            else
                go.AddComponent<StandaloneInputModule>();
        }

        void ClearDynamicUI()
        {
            if (canvas == null)
                return;

            for (int i = canvas.transform.childCount - 1; i >= 0; i--)
            {
                Transform child = canvas.transform.GetChild(i);
                if (child.name == "Background")
                    continue;
                Destroy(child.gameObject);
            }
        }

        Text CreateText(string objectName, string content, int fontSize, Vector2 position,
            Vector2 size, TextAnchor anchor = TextAnchor.MiddleCenter)
        {
            var go = new GameObject(objectName, typeof(RectTransform), typeof(Text));
            go.transform.SetParent(canvas.transform, false);

            var rect = go.GetComponent<RectTransform>();
            rect.anchoredPosition = position;
            rect.sizeDelta = size;

            var text = go.GetComponent<Text>();
            text.text = content;
            text.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            if (text.font == null)
                text.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
            text.fontSize = fontSize;
            text.alignment = anchor;
            text.color = Color.white;
            text.horizontalOverflow = HorizontalWrapMode.Wrap;
            text.verticalOverflow = VerticalWrapMode.Overflow;

            return text;
        }
    }
}
