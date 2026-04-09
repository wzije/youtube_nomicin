class ConfigModel {
  List<String> blockedKeywords = [];
  String password = "1234";
  String version = "v1.0.0";
  String creator = "jee";

  ConfigModel();

  // Mapping dari JSON ke Object
  ConfigModel.fromJson(Map<String, dynamic> json) {
    blockedKeywords = List<String>.from(json['blocked_keywords'] ?? []);
    password = json['password'] ?? "1234";
    version = json['app_info']?['version'] ?? "v1.0.0";
    creator = json['app_info']?['creator'] ?? "jee";
  }

  // Mapping dari Object ke JSON untuk simpan file
  Map<String, dynamic> toJson() => {
    'blocked_keywords': blockedKeywords,
    'password': password,
    'app_info': {'version': version, 'creator': creator},
  };
}
