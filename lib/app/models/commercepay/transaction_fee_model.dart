import 'dart:convert';

class TransactionFeeModel {
  bool? active;
  String? gateway;
  String? id;
  bool? isFix;
  String? name;
  String? value;

  TransactionFeeModel({
    this.active,
    this.gateway,
    this.id,
    this.isFix,
    this.name,
    this.value,
  });

  factory TransactionFeeModel.fromRawJson(String str) =>
      TransactionFeeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionFeeModel.fromJson(Map<String, dynamic> json) =>
      TransactionFeeModel(
        active: json["active"],
        gateway: json["gateway"],
        id: json["id"],
        isFix: json["isFix"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "gateway": gateway,
        "id": id,
        "isFix": isFix,
        "name": name,
        "value": value,
      };
}
