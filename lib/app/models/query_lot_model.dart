import 'dart:convert';

import 'package:customer_app/app/models/private_pass_model.dart';

class QueryLot {
  dynamic companyName;
  dynamic passName;
  dynamic zoneName;
  dynamic roadName;
  int? lotNo;
  bool? active;
  dynamic prevStartDate;
  dynamic prevEndDate;
  int? validity;
  DateTime? newStartDate;
  DateTime? newEndDate;
  PrivatePassModel? privatePassModel;

  QueryLot({
    this.companyName,
    this.passName,
    this.zoneName,
    this.roadName,
    this.lotNo,
    this.active,
    this.prevStartDate,
    this.prevEndDate,
    this.validity,
    this.newStartDate,
    this.newEndDate,
    this.privatePassModel,
  });

  factory QueryLot.fromRawJson(String str) =>
      QueryLot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QueryLot.fromJson(Map<String, dynamic> json) => QueryLot(
        companyName: json["companyName"],
        passName: json["passName"],
        zoneName: json["zoneName"],
        roadName: json["roadName"],
        lotNo: json["lotNo"],
        active: json["active"],
        prevStartDate: json["prevStartDate"],
        prevEndDate: json["prevEndDate"],
        validity: json["validity"],
        newStartDate: json["newStartDate"] == null
            ? null
            : DateTime.parse(json["newStartDate"]),
        newEndDate: json["newEndDate"] == null
            ? null
            : DateTime.parse(json["newEndDate"]),
        privatePassModel: json["privatePassModel"] == null
            ? null
            : PrivatePassModel.fromJson(json["privatePassModel"]),
      );

  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "passName": passName,
        "zoneName": zoneName,
        "roadName": roadName,
        "lotNo": lotNo,
        "active": active,
        "prevStartDate": prevStartDate,
        "prevEndDate": prevEndDate,
        "validity": validity,
        "newStartDate": newStartDate?.toIso8601String(),
        "newEndDate": newEndDate?.toIso8601String(),
        "privatePassModel": privatePassModel?.toJson(),
      };
}
