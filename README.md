## Here is a professional and comprehensive README.md file for your project in English.

## 📺 YOUTUBE NOMICIN

YOUTUBE NOMICIN is a Flutter-based WebView application designed to provide a cleaner, more focused, and distraction-free YouTube viewing experience.
The name "NOMICIN" (No MSG) is a local Indonesian metaphor for "No additives"—this app removes the "addictive additives" of YouTube that lead to mindless infinite scrolling.

> This project was created to prevent YouTube addiction and protect children from addictive digital content.

---

## ✨ Key Features

- 🚫 No YouTube Shorts: Blocks access to Shorts entirely, including navigation links, URLs, and accidental clicks.
- 🔍 Keyword Filtering: Automatically blocks videos or search results containing specific keywords (e.g., "gaming", "unboxing", etc.) based on your custom list.
- 💬 No Comments: Removes the comment section to keep you focused on the video content without being distracted by online arguments.
- 📺 Optimized TV UI: Injects custom scripts to ensure a clean interface, ideal for focused watching.
- ⚙️ Persistent Configuration: Your settings (passwords, blocked keywords) are saved locally on your device.
- 🔒 Stealth Settings: The settings menu is hidden from plain sight, accessible only via special gestures or secret key sequences, and protected by a password.
-

---

## 🛠️ Installation & Setup

1.  Clone the repository:

    `git clone https://github.com/wzije/youtube_nomicin.git`

2.  Navigate to the project directory:

    `cd youtube_nomicin`

3.  Install dependencies:

    `flutter pub get`

4.  Prepare Assets:
    Ensure `assets/data/config.json` exists as your  configuration template.

5.  Run the app:

    `flutter run`

---

## ⚙️ Accessing Hidden Settings

To prevent accidental changes or tampering (especially for parental control), the settings menu is hidden:

1.  Mobile: Longpress on top center of screen
2.  TV/Keyboard: Enter the sequence: Up, Up, Down, Down, Select/Enter.
3.  Authentication: Enter your password (default: 1234) to unlock the configuration screen.

---

## 📂 Configuration Format

The app uses a JSON-based system to manage your preferences:
```json
{
    "password": "1234",
    "blocked_keywords": ["shorts", "trending", "gossip"],
    "app_info": {
        "version": "1.0.0",
        "creator": "jee"
    }
}
```
---

## 🚀 Tech Stack

- Framework: Flutter
- State Management: Provider (ChangeNotifier)
- Engine: webview_flutter
- Storage: path_provider & dart:io
-

---

## 📄 License

This project is Open Source and distributed under the MIT License. You are free to fork, modify, and redistribute this software as long as the original credit is provided.

## 🤝 Contributing

Contributions are welcome! If you have ideas for new features or found a bug, feel free to open an Issue or submit a Pull Request.
Developed with ❤️ by [Jee]
