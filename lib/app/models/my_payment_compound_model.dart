import 'package:cloud_firestore/cloud_firestore.dart';

class MyPaymentCompoundModel {
  String? id;
  String? customerId;
  String? name;
  String? compoundNo;
  String? identificationNo;
  String? vehicleNo;
  String? amount;
  String? vendor;
  String? phoneNumber;
  String? address;
  String? kodHasil;

  String? paymentType;
  Timestamp? paidTime;

  Timestamp? createAt;

  MyPaymentCompoundModel({
    this.id,
    this.customerId,
    this.name,
    this.compoundNo,
    this.identificationNo,
    this.phoneNumber,
    this.vehicleNo,
    this.amount,
    this.vendor,
    this.address,
    this.kodHasil,
    this.paidTime,
    this.paymentType,
    this.createAt,
  });

  MyPaymentCompoundModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    name = json['name'];
    compoundNo = json['compoundNo'];
    identificationNo = json['identificationNo'];
    phoneNumber = json['phoneNumber'];
    vehicleNo = json['vehicleNo'];
    vendor = json['vendor'];
    kodHasil = json['kodHasil'];
    paidTime = json['paidTime'];
    address = json['address'];
    createAt = json['createAt'];
    paymentType = json['paymentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['name'] = name;
    data['compoundNo'] = compoundNo;
    data['identificationNo'] = identificationNo;
    data['phoneNumber'] = phoneNumber;
    data['vehicleNo'] = vehicleNo;
    data['kodHasil'] = kodHasil;
    data['paidTime'] = paidTime;
    data['vendor'] = vendor;
    data['address'] = address;
    data['createAt'] = createAt;
    data['paymentType'] = paymentType;
    return data;
  }
}
