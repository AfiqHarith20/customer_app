import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPaymentCompoundModel {
  String? accessToken;
  String? channelId;
  String? selectedBankId;
  String? id;
  String? customerId;
  String? name;
  String? userName;
  String? email;
  String? compoundNo;
  String? identificationNo;
  String? identificationType;
  String? vehicleNum;
  String? amount;
  String? vendor;
  String? mobileNumber;
  String? address;
  String? kodHasil;

  String? paymentType;
  Timestamp? paidTime;

  Timestamp? createAt;

  MyPaymentCompoundModel({
    this.accessToken,
    this.channelId,
    this.selectedBankId,
    this.id,
    this.customerId,
    this.name,
    this.userName,
    this.email,
    this.compoundNo,
    this.identificationNo,
    this.identificationType,
    this.vehicleNum,
    this.amount,
    this.vendor,
    this.mobileNumber,
    this.address,
    this.kodHasil,
    this.paidTime,
    this.paymentType,
    this.createAt,
  });

  MyPaymentCompoundModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['accessToken'];
    selectedBankId = json['providerChannelId'];
    amount = json['amount'];
    channelId = json['channelId'];
    userName = json['username'];
    identificationType = json['identificationType'];
    customerId = json['customerId'];
    name = json['name'];
    email = json['email'];
    compoundNo = json['compoundNo'];
    identificationNo = json['identificationNo'];
    mobileNumber = json['mobileNumber'];
    vehicleNum = json['vehicle_num'];
    vendor = json['vendor'];
    kodHasil = json['kod_hasil'];
    paidTime = json['paidTime'];
    address = json['address'];
    createAt = json['createAt'];
    paymentType = json['paymentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accessToken'] = accessToken;
    data['providerChannelId'] = selectedBankId;
    data['channelId'] = channelId;
    data['username'] = userName;
    data['identificationType'] = identificationType;
    data['amount'] = amount;
    data['customerId'] = customerId;
    data['email'] = email;
    data['name'] = name;
    data['compoundNo'] = compoundNo;
    data['identificationNo'] = identificationNo;
    data['mobileNumber'] = mobileNumber;
    data['vehicle_num'] = vehicleNum;
    data['kodHasil'] = kodHasil;
    data['paidTime'] = paidTime;
    data['vendor'] = vendor;
    data['address'] = address;
    data['createAt'] = createAt;
    data['paymentType'] =
        paymentType?.toString(); // Convert nullable field to string
    return data;
  }

  @override
  String toString() {
    return '''{
    "accessToken": "$accessToken",
    "customerId": "$customerId",
    "channelId": "$channelId",
    "providerChannelId": "$selectedBankId",
    "amount": "$amount",
    "address": "$address",
    "fullName": "$name",
    "username": "$userName",
    "compoundNo": "$compoundNo",
    "kod_hasil":"$kodHasil",
    "email": "$email",
    "mobileNo": "$mobileNumber",
    "username": "$userName",
    "identificationNumber": "$identificationNo",
    "identificationType": "$identificationType",
    "vehicle_num": "$vehicleNum"
  }''';
  }
}
