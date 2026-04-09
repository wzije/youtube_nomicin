import 'package:flutter/material.dart';
import 'package:youtube_nomicin/services/config_service.dart';

class ConfigProvider extends ChangeNotifier {
  Map<String, dynamic> _config = {};
  bool _isLoading = false;

  Map<String, dynamic> get config => _config;
  bool get isLoading => _isLoading;

  // Shortcut akses data nested agar UI lebih bersih
  String get version => _config['app_info']?['version'] ?? 'v1.0.0';
  String get creator => _config['app_info']?['creator'] ?? 'jee';
  String get password => _config['password'] ?? '';
  List<String> get blockedKeywords =>
      List<String>.from(_config['blocked_keywords'] ?? []);

  // Load data awal
  Future<void> init() async {
    _config = await ConfigService.loadConfig();
    _isLoading = false;
    notifyListeners();
  }

  // Fungsi simpan yang akan dipanggil dari UI
  // bagian ini bisa passing class param
  Future<void> saveSettings(String newPass, String keywordsRaw) async {
    final keywordList = keywordsRaw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    _config['password'] = newPass;
    _config['blocked_keywords'] = keywordList;

    await ConfigService.saveConfig(_config);
    notifyListeners(); // Inilah yang bikin UI di halaman lain ikut berubah!
  }
}
