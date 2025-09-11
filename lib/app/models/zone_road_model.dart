class Zone {
  int? znId;
  String? znName;
  String? znStat;

  Zone({
    this.znId,
    this.znName,
    this.znStat,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      znId: json['znId'],
      znName: json['znZon'],
      znStat: json['znZonStat'],
    );
  }
}

class Road {
  int? jlnId;
  String? jlnNama;
  String? jlnKodKaw;
  String? jlnStatus;

  Road({
    this.jlnId,
    this.jlnNama,
    this.jlnKodKaw,
    this.jlnStatus,
  });

  factory Road.fromJson(Map<String, dynamic> json) {
    return Road(
      jlnId: json['jlnId'],
      jlnNama: json['jlnNama'],
      jlnKodKaw: json['jlnKodKaw'],
      jlnStatus: json['jlnStatus'],
    );
  }
}
