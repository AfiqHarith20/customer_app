class ChannelModel{
  int? id;
  String? name;
  int? type;
  bool? isProviderHostChannel;
  List<CurrenciesModel>? currencyList;
  String? imageUrl;
  int? groupId;
  String? groupName;
  String? groupImageUrl;
  bool? savePayment;

  ChannelModel({
    this.id,
    this.name,
    this.type,
    this.isProviderHostChannel,
    this.currencyList,
    this.imageUrl,
    this.groupId,
    this.groupName,
    this.groupImageUrl,
    this.savePayment,
  });

  ChannelModel? channelModel;

  ChannelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    isProviderHostChannel = json['isProviderHostChannel'];
    if (json['currencyList'] != null) {
      currencyList = <CurrenciesModel>[];
      json['currencyList'].forEach((v) {
        currencyList!.add(CurrenciesModel.fromJson(v));
      });
    }
    imageUrl = json['imageUrl'];
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupImageUrl = json['groupImageUrl'];
    savePayment = json['savePayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isProviderHostChannel'] = isProviderHostChannel;
    if (currencyList != null) {
      data['currencyList'] = currencyList!.map((v) => v.toJson()).toList();
    }
    data['imageUrl'] = imageUrl;
    data['groupId'] = groupId;
    data['groupName'] = groupName;
    data['groupImageUrl'] = groupImageUrl;
    data['groupName'] = groupName;
    data['savePayment'] = savePayment;
    return data;
  }
}

class ProviderChannelModel{
  String? id;
  String? name;
  String? displayName;
  String? imageUrl;
  int? status;

  ProviderChannelModel({
    this.id,
    this.name,
    this.displayName,
    this.imageUrl,
    this.status,
  });

  ProviderChannelModel? providerChannelModel;

  // ProviderChannelModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   name = json['name'];
  //   displayName = json['displayName'];
  //   imageUrl = json['imageUrl'];
  //   status = json['status'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['name'] = name;
  //   data['displayName'] = displayName;
  //   data['imageUrl'] = imageUrl;
  //   data['status'] = status;
  //
  //   if (providerChannelModel != null) {
  //     data['providerChannelModel'] = providerChannelModel!.toJson();
  //   }
  //   return data;
  // }
}

class CurrenciesModel {
  String? acceptedCurrencyCode;
  double? minRequestAmount;
  double? maxRequestAmount;
  int? dailyTransactionCount;
  double? dailyTransactionAmount;
  double? minSurchargeAmount;
  double? maxSurchargeAmount;
  bool? isSurchargePercentage;
  double? surcharge;

  CurrenciesModel({this.acceptedCurrencyCode, this.minRequestAmount, this.maxRequestAmount, this.dailyTransactionCount, this.dailyTransactionAmount, this.minSurchargeAmount, this.maxSurchargeAmount, this.isSurchargePercentage, this.surcharge});

  CurrenciesModel.fromJson(Map<String, dynamic> json) {
    acceptedCurrencyCode = json['acceptedCurrencyCode'];
    minRequestAmount = json['minRequestAmount'];
    maxRequestAmount = json['maxRequestAmount'];
    dailyTransactionCount = json['dailyTransactionCount'];
    dailyTransactionAmount = json['dailyTransactionAmount'];
    minSurchargeAmount = json['minSurchargeAmount'];
    maxSurchargeAmount = json['maxSurchargeAmount'];
    isSurchargePercentage = json['isSurchargePercentage'];
    surcharge = json['surcharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acceptedCurrencyCode'] = acceptedCurrencyCode;
    data['minRequestAmount'] = minRequestAmount;
    data['maxRequestAmount'] = maxRequestAmount;
    data['dailyTransactionCount'] = dailyTransactionCount;
    data['dailyTransactionAmount'] = dailyTransactionAmount;
    data['minSurchargeAmount'] = minSurchargeAmount;
    data['maxSurchargeAmount'] = maxSurchargeAmount;
    data['isSurchargePercentage'] = isSurchargePercentage;
    data['surcharge'] = surcharge;
    return data;
  }
}