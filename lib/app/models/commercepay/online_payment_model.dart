import 'package:cloud_firestore/cloud_firestore.dart';

class OnlinePaymentModel {
  String? accessToken;
  String? customerId;
  String? channelId;
  String? selectedBankId;
  double? totalPrice;
  String? address;
  String? companyName;
  String? companyRegistrationNo;
  Timestamp? endDate;
  Timestamp? startDate;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? userName;
  String? identificationNo;
  String? identificationType;
  String? vehicleNo;
  String? lotNo;
  String? selectedPassId;

  OnlinePaymentModel({
    this.accessToken,
    this.customerId,
    this.channelId,
    this.selectedBankId,
    this.totalPrice,
    this.address,
    this.companyName,
    this.companyRegistrationNo,
    this.endDate,
    this.startDate,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.userName,
    this.identificationNo,
    this.identificationType,
    this.vehicleNo,
    this.lotNo,
    this.selectedPassId,
  });

  OnlinePaymentModel? onlinePaymentModel;

  OnlinePaymentModel.romJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    customerId = json['customerId'];
    channelId = json['channelId'];
    selectedBankId = json['providerChannelId'];
    totalPrice = json['amount'];
    address = json['address'];
    companyName = json['companyName'];
    companyRegistrationNo = json['companyRegistrationNo'];
    endDate = json['endDate'];
    startDate = json['startDate'];
    fullName = json['name'];
    email = json['email'];
    mobileNumber = json['mobileNo'];
    userName = json['username'];
    identificationNo = json['identificationNumber'];
    identificationType = json['identificationType'];
    lotNo = json['lotNo'];
    vehicleNo = json['vehicleNo'];
    selectedPassId = json['passId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['customerId'] = customerId;
    data['channelId'] = channelId;
    data['providerChannelId'] = selectedBankId;
    data['amount'] = totalPrice;
    data['address'] = address;
    data['companyName'] = companyName;
    data['companyRegistrationNo'] = companyRegistrationNo;
    data['endDate'] = endDate;
    data['startDate'] = startDate;
    data['name'] = fullName;
    data['email'] = email;
    data['mobileNo'] = mobileNumber;
    data['username'] = userName;
    data['identificationNumber'] = identificationNo;
    data['identificationType'] = identificationType;
    data['lotNo'] = lotNo;
    data['vehicleNo'] = vehicleNo;
    data['passId'] = selectedPassId;
    return data;
  }
}
