import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHistoryModel {
  String? amount;
  String? channelId;
  DateTime? createAt;
  bool? credit;
  String? id;
  String? paymentType;
  String? passType;
  String? providerChannelId;
  String? providerPaymentMethod;
  String? providerTransactionNumber;
  String? referenceCode;
  int? status;
  String? transactionNumber;
  String? transactionType;

  TransactionHistoryModel({
    this.amount,
    this.channelId,
    this.createAt,
    this.credit,
    this.passType,
    this.id,
    this.paymentType,
    this.providerChannelId,
    this.providerPaymentMethod,
    this.providerTransactionNumber,
    this.referenceCode,
    this.status,
    this.transactionNumber,
    this.transactionType,
  });

  factory TransactionHistoryModel.fromRawJson(String str) =>
      TransactionHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
        amount: json["amount"],
        channelId: json["channelId"],
        createAt: (json["createAt"] as Timestamp).toDate(),
        credit: json["credit"],
        id: json["id"],
        paymentType: json["paymentType"],
        passType: json["passType"],
        providerChannelId: json["providerChannelId"],
        providerPaymentMethod: json["providerPaymentMethod"],
        providerTransactionNumber: json["providerTransactionNumber"],
        referenceCode: json["referenceCode"],
        status: json["status"],
        transactionNumber: json["transactionNumber"],
        transactionType: json["transactionType"],
      );

  factory TransactionHistoryModel.fromMap(Map<String, dynamic> data) {
    return TransactionHistoryModel(
      amount: data['amount'],
      channelId: data['channelId'],
      createAt: (data['createAt']),
      credit: data['credit'],
      passType: data['passType'],
      id: data['id'],
      paymentType: data['paymentType'],
      providerChannelId: data['providerChannelId'],
      providerTransactionNumber: data['providerTransactionNumber'],
      referenceCode: data['referenceCode'],
      providerPaymentMethod: data['providerPaymentMethod'],
      status: data['status'],
      transactionType: data['transactionType'],
      transactionNumber: data['transactionNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "channelId": channelId,
        "createAt": createAt,
        "credit": credit,
        "passType": passType,
        "id": id,
        "paymentType": paymentType,
        "providerChannelId": providerChannelId,
        "providerPaymentMethod": providerPaymentMethod,
        "providerTransactionNumber": providerTransactionNumber,
        "referenceCode": referenceCode,
        "status": status,
        "transactionNumber": transactionNumber,
        "transactionType": transactionType,
      };
}
