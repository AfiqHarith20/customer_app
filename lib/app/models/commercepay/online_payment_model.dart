import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OnlinePaymentModel {
  String? accessToken;
  String? customerId;
  String? channelId;
  String? selectedBankId;
  double? totalPrice;
  String? address;
  String? companyName;
  String? companyRegistrationNo;
  DateTime? endDate;
  DateTime? startDate;
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

  // Helper method to convert Timestamp to DateTime
  DateTime? _timestampToDateTime(Timestamp? timestamp) {
    if (timestamp == null) return null;
    return timestamp.toDate();
  }

  // Convert the model to a string representation
  @override
  String toString() {
    String formattedEndDate =
        endDate != null ? DateFormat('yyyy/MM/dd').format(endDate!) : '';
    String formattedStartDate =
        startDate != null ? DateFormat('yyyy/MM/dd').format(startDate!) : '';
    return '''{
  "accessToken": "$accessToken",
  "customerId": "$customerId",
  "channelId": "$channelId",
  "providerChannelId": "$selectedBankId",
  "amount": "${totalPrice?.toStringAsFixed(2)}",
  "address": "$address",
  "companyName": "$companyName",
  "companyRegistrationNo": "$companyRegistrationNo",
  "endDate": "${formattedEndDate.toString()}",
  "startDate": "${formattedStartDate.toString()}",
  "fullName": "$fullName",
  "email": "$email",
  "mobileNo": "$mobileNumber",
  "username": "$userName",
  "identificationNumber": "$identificationNo",
  "identificationType": "$identificationType",
  "lotNo": "$lotNo",
  "vehicleNo": "$vehicleNo",
  "passid": "$selectedPassId"
}''';
  }

  // Convert from JSON
  OnlinePaymentModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    customerId = json['customerId'];
    channelId = json['channelId'];
    selectedBankId = json['providerChannelId'];
    totalPrice = json['amount'];
    address = json['address'];
    companyName = json['companyName'];
    companyRegistrationNo = json['companyRegistrationNo'];
    endDate = _timestampToDateTime(json['endDate']);
    startDate = _timestampToDateTime(json['startDate']);
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

  // Convert to JSON
  Map<String, dynamic> toJson() {
    String formattedEndDate =
        endDate != null ? DateFormat('yyyy/MM/dd').format(endDate!) : '';
    String formattedStartDate =
        startDate != null ? DateFormat('yyyy/MM/dd').format(startDate!) : '';
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['customerId'] = customerId;
    data['channelId'] = channelId;
    data['providerChannelId'] = selectedBankId;
    data['amount'] = totalPrice;
    data['address'] = address;
    data['companyName'] = companyName;
    data['companyRegistrationNo'] = companyRegistrationNo;
    data['endDate'] = formattedEndDate;
    data['startDate'] = formattedStartDate;
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
