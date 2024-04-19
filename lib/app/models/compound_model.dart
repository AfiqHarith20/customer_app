import 'package:cloud_firestore/cloud_firestore.dart';

class CompoundModel {
  String? amount;
  Timestamp? dateTime;
  String? id;
  String? userId;
  String? compoundNo;
  String? status;
  String? vehicleNo;
  String? offence;
  String? kodHasil;
  String? msg;
  bool? isSelected;

  CompoundModel({
    this.amount,
    this.dateTime,
    this.offence,
    this.id,
    this.userId,
    this.compoundNo,
    this.status,
    this.vehicleNo,
    this.kodHasil,
    this.msg,
    this.isSelected = false,
  });

  CompoundModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    dateTime = json['datetime'];
    id = json['id'];
    userId = json['userId'];
    compoundNo = json['compound_num'];
    status = json['status'];
    vehicleNo = json['vehicle_num'];
    kodHasil = json['kod_hasil'];
    offence = json['offence'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['datetime'] = dateTime;
    data['id'] = id;
    data['compound_num'] = compoundNo;
    data['userId'] = userId;
    data['status'] = status;
    data['vehicle_num'] = vehicleNo;
    data['kod_hasil'] = kodHasil;
    data['offence'] = offence;
    data['msg'] = msg;
    return data;
  }
}
