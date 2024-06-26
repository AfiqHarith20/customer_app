import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QueryPass {
  String? passName;
  String? vehicleNo;
  bool? active;
  Timestamp? prevStartDate;
  Timestamp? prevEndDate;
  int? validity;
  Timestamp? newStartDate;
  Timestamp? newEndDate;

  QueryPass({
    this.passName,
    this.vehicleNo,
    this.active,
    this.prevStartDate,
    this.prevEndDate,
    this.validity,
    this.newStartDate,
    this.newEndDate,
  });

  factory QueryPass.fromRawJson(String str) =>
      QueryPass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QueryPass.fromJson(Map<String, dynamic> json) => QueryPass(
        passName: json["passName"],
        vehicleNo: json["vehicleNo"],
        active: json["active"],
        prevStartDate: json["prevStartDate"],
        prevEndDate: json["prevEndDate"],
        validity: json["validity"],
        newStartDate: json["newStartDate"],
        newEndDate: json["newEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "passName": passName,
        "vehicleNo": vehicleNo,
        "active": active,
        "prevStartDate": prevStartDate,
        "prevEndDate": prevEndDate,
        "validity": validity,
        "newStartDate": newStartDate,
        "newEndDate": newEndDate,
      };
}
