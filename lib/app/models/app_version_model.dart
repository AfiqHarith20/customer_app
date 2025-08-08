class VersionInfo {
  String? versionName;
  int? versionNumber;

  VersionInfo({this.versionName, this.versionNumber});

  // Factory constructor to create a VersionInfo instance from a map
  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      versionName: json['versionName'] as String?,
      versionNumber: json['versionNumber'] as int?,
    );
  }

  // Method to convert a VersionInfo instance to a map
  Map<String, dynamic> toJson() {
    return {
      'versionName': versionName,
      'versionNumber': versionNumber,
    };
  }
}

class PlatformInfo {
  VersionInfo? android;
  VersionInfo? ios;

  PlatformInfo({this.android, this.ios});

  // Factory constructor to create a PlatformInfo instance from a map
  factory PlatformInfo.fromJson(Map<String, dynamic> json) {
    return PlatformInfo(
      android: json['android'] != null
          ? VersionInfo.fromJson(json['android'] as Map<String, dynamic>)
          : null,
      ios: json['iOS'] != null
          ? VersionInfo.fromJson(json['iOS'] as Map<String, dynamic>)
          : null,
    );
  }

  // Method to convert a PlatformInfo instance to a map
  Map<String, dynamic> toJson() {
    return {
      'android': android?.toJson(),
      'iOS': ios?.toJson(),
    };
  }
}
