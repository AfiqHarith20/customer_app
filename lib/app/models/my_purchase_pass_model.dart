import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/app/models/season_pass_model.dart';

class MyPurchasePassModel {
  String? id;
  String? customerId;
  String? fullName;
  String? email;
  String? identificationNo;
  String? mobileNumber;
  String? vehicleNo;
  String? lotNo;
  String? companyName;
  String? companyRegistrationNo;
  String? address;
  String? countryCode;

  String? paymentType;
  Timestamp? startDate;
  Timestamp? endDate;

  Timestamp? createAt;

  SeasonPassModel? seasonPassModel;
  PrivatePassModel? privatePassModel;

  MyPurchasePassModel({
    this.id,
    this.customerId,
    this.seasonPassModel,
    this.privatePassModel,
    this.fullName,
    this.email,
    this.identificationNo,
    this.mobileNumber,
    this.vehicleNo,
    this.lotNo,
    this.companyName,
    this.companyRegistrationNo,
    this.address,
    this.countryCode,
    this.startDate,
    this.endDate,
    this.paymentType,
    this.createAt,
  });

  MyPurchasePassModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    fullName = json['fullName'];
    email = json['email'];
    identificationNo = json['identificationNo'];
    mobileNumber = json['mobileNumber'];
    vehicleNo = json['vehicleNo'];
    lotNo = json['lotNo'];
    companyName = json['companyName'];
    companyRegistrationNo = json['companyRegistrationNo'];
    address = json['address'];
    countryCode = json['countryCode'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createAt = json['createAt'];
    paymentType = json['paymentType'];
    seasonPassModel = json['seasonPassModel'] != null
        ? SeasonPassModel.fromJson(json['seasonPassModel'])
        : SeasonPassModel();
    privatePassModel = json['privatePassModel'] != null
        ? PrivatePassModel.fromJson(json['privatePassModel'])
        : PrivatePassModel();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['identificationNo'] = identificationNo;
    data['mobileNumber'] = mobileNumber;
    data['vehicleNo'] = vehicleNo;
    data['lotNo'] = lotNo;
    data['companyName'] = companyName;
    data['companyRegistrationNo'] = companyRegistrationNo;
    data['address'] = address;
    data['countryCode'] = countryCode;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['createAt'] = createAt;
    data['paymentType'] = paymentType;
    if (seasonPassModel != null) {
      data['seasonPassModel'] = seasonPassModel!.toJson();
    }
    if (privatePassModel != null) {
      data['privatePassModel'] = privatePassModel!.toJson();
    }
    return data;
  }
}
