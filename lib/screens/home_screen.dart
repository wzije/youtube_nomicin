import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_nomicin/providers/config_provider.dart';
import 'package:youtube_nomicin/config/jsscript.dart';
import 'dart:io';

import 'package:youtube_nomicin/screens/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late final WebViewController _webViewController;
  DateTime? lastBackPress;
  List<String> history = [];

  late FocusNode _focusNode;

  // TV key sequence
  final List<LogicalKeyboardKey> _tvKeySequence = [
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.select,
  ];
  final List<LogicalKeyboardKey> _keyBuffer = [];

  String getUserAgent() {
    if (Platform.isAndroid) {
      return "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 Chrome/120 Mobile Safari/537.36";
    } else if (Platform.isIOS) {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 Mobile/15E148";
    } else {
      return "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120 Safari/537.36";
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    _initWebView();
    context.read<ConfigProvider>().addListener(_handleGlobalKeywordChange);
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(getUserAgent())
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            final latestKeywords = context
                .read<ConfigProvider>()
                .blockedKeywords;

            // BLOCK SHORTS TOTAL
            if (url.contains("/shorts/")) {
              return NavigationDecision.prevent;
            }

            // OPTIONAL: block reel / weird endpoints
            if (url.contains("reel")) {
              return NavigationDecision.prevent;
            }

            // block keyword di URL (search, watch, dll)
            for (var keyword in latestKeywords) {
              if (url.contains(keyword)) {
                return NavigationDecision.prevent;
              }
            }

            return NavigationDecision.navigate;
          },

          onUrlChange: (change) {
            final url = change.url ?? "";

            final latestKeywords = context
                .read<ConfigProvider>()
                .blockedKeywords;

            if (url.contains("/shorts/")) {
              _webViewController.loadRequest(Uri.parse("https://youtube.com"));
            }

            // block keyword
            for (var keyword in latestKeywords) {
              if (url.contains(keyword)) {
                _webViewController.loadRequest(
                  Uri.parse("https://youtube.com"),
                );
                return;
              }
            }
          },

          onPageFinished: (url) {
            // inject script kamu
            _webViewController.runJavaScript(YoutubeTVModeScript);
            // simpan history
            if (history.isEmpty || history.last != url) {
              history.add(url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse("https://youtube.com"));
  }

  // Fungsi untuk mengecek URL aktif jika keyword berubah di background
  void _handleGlobalKeywordChange() async {
    final latestKeywords = context.read<ConfigProvider>().blockedKeywords;
    final currentUrl = await _webViewController.currentUrl();

    if (currentUrl == null) return;

    for (var keyword in latestKeywords) {
      if (keyword.isNotEmpty &&
          currentUrl.toLowerCase().contains(keyword.toLowerCase())) {
        _webViewController.loadRequest(Uri.parse("https://youtube.com"));
        break;
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // Lepas listener agar tidak terjadi kebocoran memori
    context.read<ConfigProvider>().removeListener(_handleGlobalKeywordChange);
    super.dispose();
  }

  void _checkTvSequence(LogicalKeyboardKey key) {
    _keyBuffer.add(key);
    if (_keyBuffer.length > _tvKeySequence.length) {
      _keyBuffer.removeAt(0);
    }

    bool match = true;
    for (int i = 0; i < _keyBuffer.length; i++) {
      if (_keyBuffer[i] != _tvKeySequence[i]) {
        match = false;
        break;
      }
    }
    if (match && _keyBuffer.length == _tvKeySequence.length) {
      _keyBuffer.clear();
      PasswordDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan agar UI tetap sinkron
    context.watch<ConfigProvider>();

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) => {
        if (event is KeyDownEvent) {_checkTvSequence(event.logicalKey)},
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final messenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(context);

          // PRIORITAS: pakai history manual
          if (history.length > 1) {
            history.removeLast();
            final previousUrl = history.last;

            _webViewController.loadRequest(Uri.parse(previousUrl));
            return;
          }

          // fallback (kalau history kosong)
          final bool canGoBack = await _webViewController.canGoBack();

          if (!mounted) return;

          // fallback (kalau history kosong)
          if (canGoBack) {
            _webViewController.goBack();
            return;
          }

          // double back to exit
          final now = DateTime.now();

          if (lastBackPress == null ||
              now.difference(lastBackPress!) > Duration(seconds: 2)) {
            lastBackPress = now;

            messenger.showSnackBar(
              const SnackBar(content: Text("Press back again to exit")),
            );

            return;
          }

          // exit
          navigator.pop();
        },
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 1),
          body: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(controller: _webViewController),
                Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: GestureDetector(
                    onLongPress: PasswordDialog.new,
                    child: Container(
                      color: Colors.transparent,
                      width: 70,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordDialog extends StatefulWidget {
  const PasswordDialog({super.key});

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController passCtrl = TextEditingController();
  String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Go To Setting"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: passCtrl,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: "Enter Password",
              errorText: errorMsg,
            ),
            onChanged: (val) {
              if (errorMsg != null) setState(() => errorMsg = null);
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Warna background
            foregroundColor: Colors.white, // Warna teks
            minimumSize: const Size(100, 45), // Lebar 100, Tinggi 45
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0, // Datar, atau kasih angka jika mau ada bayangan
          ),
          onPressed: () {
            final correctPassword = context.read<ConfigProvider>().password;
            if (passCtrl.text == correctPassword) {
              Navigator.of(context).pop(); // Tutup dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingScreen()),
              );
            } else {
              setState(() {
                errorMsg = "Invalid Password";
              });
            }
          },
          child: const Text(
            "Enter",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
