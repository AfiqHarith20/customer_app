import 'package:cloud_firestore/cloud_firestore.dart';

class WalletTopupModel {
  String? id;
  String? accessToken;
  String? customerId;
  int? channelId;
  String? selectedBankId;
  String? amount;
  String? email;
  String? mobileNumber;
  String? name;
  String? username;
  String? identificationNumber;
  int? identificationType;

  String? paymentType;
  Timestamp? paidTime;

  Timestamp? createAt;

  WalletTopupModel({
    this.id,
    this.accessToken,
    this.customerId,
    this.channelId,
    this.selectedBankId,
    this.amount,
    this.email,
    this.mobileNumber,
    this.name,
    this.username,
    this.identificationNumber,
    this.identificationType,
    this.paidTime,
    this.paymentType,
    this.createAt,
  });

  factory WalletTopupModel.fromJson(Map<String, dynamic> json) =>
      WalletTopupModel(
        accessToken: json["accessToken"],
        customerId: json["customerId"],
        channelId: json["channelId"],
        selectedBankId: json["providerChannelId"],
        amount: json["amount"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        username: json["username"],
        identificationNumber: json["identificationNumber"],
        identificationType: json["identificationType"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "customerId": customerId,
        "channelId": channelId,
        "providerChannelId": selectedBankId,
        "amount": amount,
        "email": email,
        "mobileNumber": mobileNumber,
        "name": name,
        "username": username,
        "identificationNumber": identificationNumber,
        "identificationType": identificationType,
      };
}
