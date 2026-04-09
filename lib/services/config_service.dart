import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ConfigService {
  static File? _localFile;

  //singleton
  static final ConfigService _instance = ConfigService.internal();
  factory ConfigService() => _instance;
  ConfigService.internal();

  //get local path file
  static Future<File> _getLocalFile() async {
    if (_localFile != null) return _localFile!;

    final dir = await getApplicationDocumentsDirectory();
    _localFile = File('${dir.path}/config.json');

    //jika file belum ada copy dari asset
    if (!await _localFile!.exists()) {
      final jsonStr = await rootBundle.loadString("assets/data/config.json");
      await _localFile!.writeAsString(jsonStr);
    }

    return _localFile!;
  }

  //load configs as map
  static Future<Map<String, dynamic>> loadConfig() async {
    final file = await _getLocalFile();
    final content = await file.readAsString();
    return json.decode(content);
  }

  //save configs
  static Future<void> saveConfig(Map<String, dynamic> config) async {
    final file = await _getLocalFile();
    await file.writeAsString(json.encode(config));
  }

  //save only one key config
  static Future<void> updateConfigKey(String key, dynamic val) async {
    final config = await loadConfig();
    config[key] = val;

    await saveConfig(config);
  }
}
