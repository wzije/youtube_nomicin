# Tubles – Safe Video Browser

Tubles is a Flutter-based WebView application designed to provide a cleaner, more focused, and distraction-free video browsing experience.

Built with simplicity and safety in mind, Tubles helps reduce digital addiction and creates a safer environment for children by filtering distracting and potentially harmful content.

> This project was created to promote healthy digital habits and protect users—especially kids—from addictive online video content.

---

## ✨ Key Features

- 🚫 Short Video Blocking
  Prevents access to short-form, highly addictive video content to reduce endless scrolling behavior.

- 🔍 Keyword Filtering
  Automatically filters videos and search results containing specific keywords (e.g., "gaming", "unboxing", etc.) based on your custom list.

- 💬 Distraction-Free Viewing
  Removes comment sections to help users stay focused without exposure to unnecessary or harmful interactions.

- 📺 Clean Interface Mode
  Injects a simplified layout for a more focused and minimal viewing experience.

- ⚙️ Persistent Configuration
  All settings (password, blocked keywords) are securely stored locally on your device.

- 🔒 Hidden & Protected Settings
  Settings are hidden from plain view and protected with password authentication to prevent unauthorized access.

---

## 🛠️ Installation & Setup

1. Clone the repository:

   `git clone https://github.com/wzije/tubles.git`

2. Navigate to the project directory:

   `cd tubles`

3. Install dependencies:

   `flutter pub get`

4. Prepare Assets:
   Ensure `assets/data/config.json` exists as your configuration template.

5. Run the app:

   `flutter run`

---

## ⚙️ Accessing Hidden Settings

To prevent accidental changes (especially for parental control), the settings menu is hidden:

1. Mobile: Long press on the top center of the screen
2. TV/Keyboard: Enter the sequence: Up, Up, Down, Down, Select/Enter
3. Authentication: Enter your password (default: 1234)

---

## 📂 Configuration Format

Tubles uses a JSON-based configuration system:

```json
{
  "password": "1234",
  "blocked_keywords": ["shorts", "trending", "gossip"],
}
```

---

## 🚀 Tech Stack

- Framework: Flutter
- State Management: Provider (ChangeNotifier)
- Engine: webview_flutter
- Storage: path_provider & dart:io

---

## ⚠️ Disclaimer

Tubles is an independent application and is **not affiliated with or endorsed by any video platform or service provider**.

---

## 📄 License

This project is open source and distributed under the MIT License. You are free to fork, modify, and redistribute this software with proper attribution.

