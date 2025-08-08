import 'dart:ffi';

class AuthModel{
  String? userNameOrEmailAddress;
  String? password;

  AuthModel({
    this.userNameOrEmailAddress,
    this.password,
  });

  AuthModel? authModel;

  AuthModel.fromJson(Map<String, dynamic> json) {
    userNameOrEmailAddress = json['userNameOrEmailAddress'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userNameOrEmailAddress'] = userNameOrEmailAddress;
    data['password'] = password;

    if (authModel != null) {
      data['authModel'] = authModel!.toJson();
    }
    return data;
  }
}

class AuthResultModel{
  String? accessToken;
  int? expireInSeconds;

  AuthResultModel({
    this.accessToken,
    this.expireInSeconds,
  });

  AuthResultModel? authResultModel;

  AuthResultModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    expireInSeconds = json['expireInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['expireInSeconds'] = expireInSeconds;

    if (authResultModel != null) {
      data['authResultModel'] = authResultModel!.toJson();
    }
    return data;
  }
}