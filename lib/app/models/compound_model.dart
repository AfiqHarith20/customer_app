import 'dart:convert';

import 'package:flutter/material.dart';

class CompoundModel {
  String? amount;
  String? dateTime; // Change Timestamp to String
  String? id;
  String? customerId;
  String? compoundNo;
  String? status;
  String? vehicleNum;
  String? offence;
  String? kodHasil;
  String? msg;
  bool? isSelected;
  String? imageUrl;

  CompoundModel({
    this.amount,
    this.dateTime,
    this.offence,
    this.id,
    this.customerId,
    this.compoundNo,
    this.status,
    this.vehicleNum,
    this.kodHasil,
    this.msg,
    this.isSelected = false,
    this.imageUrl,
  });

  CompoundModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];

    // Handle empty or null datetime, now it's a String
    dateTime = (json['datetime'] != null && json['datetime'].isNotEmpty)
        ? json['datetime'] // Directly assign the string value
        : null;

    id = json['id'];
    customerId = json['userId'];
    compoundNo = json['compound_num'];
    status = json['status'];
    vehicleNum = json['vehicle_num'];
    kodHasil = json['kod_hasil'];
    offence = json['offence'];
    msg = json['msg'];
    imageUrl = json['allCompoundImage'];

    if (imageUrl != null) {
      final String decodedString = utf8.decode(base64.decode(imageUrl!));
      imageUrl = decodedString;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['datetime'] = dateTime; // Keep as String
    data['id'] = id;
    data['compound_num'] = compoundNo;
    data['userId'] = customerId;
    data['status'] = status;
    data['vehicle_num'] = vehicleNum;
    data['kod_hasil'] = kodHasil;
    data['offence'] = offence;
    data['msg'] = msg;
    data['allCompoundImage'] = imageUrl;
    return data;
  }
}
