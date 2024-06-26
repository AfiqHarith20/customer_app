import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? fullName;
  String? id;
  String? email;
  String? loginType;
  String? address;
  String? profilePic;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  String? identificationNo;
  String? identificationType;
  String? gender;
  bool? active;
  Timestamp? createdAt;

  CustomerModel(
      {this.fullName,
      this.id,
      this.email,
      this.address,
      this.loginType,
      this.active,
      this.gender,
      this.profilePic,
      this.fcmToken,
      this.countryCode,
      this.phoneNumber,
      this.identificationNo,
      this.identificationType,
      this.walletAmount,
      this.createdAt});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['id'];
    email = json['email'];
    address = json['address'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    active = json['active'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    identificationNo = json['identificationNumber'];
    identificationType = json['identificationType'];
    walletAmount = json['walletAmount'] ?? "0";
    createdAt = json['createdAt'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['address'] = address;
    data['id'] = id;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['active'] = active ?? true;
    data['countryCode'] = countryCode;
    data['identificationNumber'] = identificationNo;
    data['identificationType'] = identificationType;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount ?? "0";
    data['createdAt'] = createdAt;
    data['gender'] = gender;

    return data;
  }
}
