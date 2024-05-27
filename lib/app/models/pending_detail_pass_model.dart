import 'dart:convert';

import 'package:customer_app/app/models/private_pass_model.dart';

class PendingDetailPassModel {
  String? id;
  String? customerId;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? vehicleNo;
  String? imageFileName;
  String? lotNo;
  String? companyName;
  String? companyRegistrationNo;
  String? address;
  String? countryCode;
  String? reference;
  String? status;
  String? imageBase64;
  String? zoneId;
  String? zoneName;
  String? roadId;
  String? roadName;

  String? paymentType;
  DateTime? startDate;
  DateTime? endDate;

  DateTime? createAt;

  PrivatePassModel? privatePassModel;

  PendingDetailPassModel({
    this.id,
    this.customerId,
    this.privatePassModel,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.vehicleNo,
    this.lotNo,
    this.imageFileName,
    this.companyName,
    this.companyRegistrationNo,
    this.address,
    this.countryCode,
    this.startDate,
    this.endDate,
    this.paymentType,
    this.createAt,
    this.status,
    this.reference,
    this.imageBase64,
    this.roadId,
    this.roadName,
    this.zoneId,
    this.zoneName,
  });

  PendingDetailPassModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    fullName = json['fullName'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    vehicleNo = json['vehicleNo'];
    lotNo = json['lotNo'];
    imageFileName = json['imageFileName'];
    companyName = json['companyName'];
    companyRegistrationNo = json['companyRegistrationNo'];
    address = json['address'];
    countryCode = json['countryCode'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createAt = json['createAt'];
    paymentType = json['paymentType'];
    privatePassModel = json['privatePassModel'] != null
        ? PrivatePassModel.fromJson(json['privatePassModel'])
        : PrivatePassModel();
    status = json['status'];
    reference = json['reference'];
    imageBase64 = json['imageBase64'];
    zoneId = json['zoneId'];
    zoneName = json['zoneName'];
    roadId = json['roadId'];
    roadName = json['roadName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['mobileNumber'] = mobileNumber;
    data['vehicleNo'] = vehicleNo;
    data['lotNo'] = lotNo;
    data['image'] = imageFileName;
    data['companyName'] = companyName;
    data['companyRegistrationNo'] = companyRegistrationNo;
    data['address'] = address;
    data['countryCode'] = countryCode;
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['createAt'] = createAt?.toIso8601String();
    data['paymentType'] = paymentType;
    data['reference'] = reference;
    data['status'] = status;
    data['imageBase64'] = imageBase64;
    data['zoneId'] = zoneId;
    data['roadId'] = roadId;
    data['zoneName'] = zoneName;
    data['roadName'] = roadName;
    if (privatePassModel != null) {
      data['privatePassModel'] = privatePassModel!.toJson();
    }
    return data;
  }

  String toJsonRaw() {
    // Convert the model to JSON
    Map<String, dynamic> jsonData = toJson();

    // Convert JSON data to a raw string
    return json.encode(jsonData);
  }
}
