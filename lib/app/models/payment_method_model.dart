class PaymentModel {
  CommercePay? commercePay;
  Strip? strip;
  Wallet? wallet;
  Wallet? cash;
  Paypal? paypal;

  PaymentModel({this.commercePay, this.strip, this.wallet, this.cash, this.paypal});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    commercePay = json['commercepay'] != null ? CommercePay.fromJson(json['commercepay']) : null;
    strip = json['strip'] != null ? Strip.fromJson(json['strip']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    cash = json['cash'] != null ? Wallet.fromJson(json['cash']) : null;
    paypal = json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (commercePay != null) {
      data['strip'] = commercePay!.toJson();
    }
    if (strip != null) {
      data['strip'] = strip!.toJson();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (cash != null) {
      data['cash'] = cash!.toJson();
    }
    if (paypal != null) {
      data['paypal'] = paypal!.toJson();
    }
    return data;
  }
}

class CommercePay{
  String? secretKey;
  bool? enable;
  String? name;
  bool? isProduction;

  CommercePay({this.secretKey, this.enable, this.name, this.isProduction});

  CommercePay.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    isProduction = json['isProduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['isProduction'] = isProduction;
    return data;
  }
}

class Strip {
  String? clientpublishableKey;
  String? stripeSecret;
  bool? enable;
  String? name;
  bool? isSandbox;

  Strip({this.clientpublishableKey, this.stripeSecret, this.enable, this.name, this.isSandbox});

  Strip.fromJson(Map<String, dynamic> json) {
    clientpublishableKey = json['clientpublishableKey'];
    stripeSecret = json['stripeSecret'];
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientpublishableKey'] = clientpublishableKey;
    data['stripeSecret'] = stripeSecret;
    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    return data;
  }
}

class Wallet {
  bool? enable;
  String? name;

  Wallet({this.enable, this.name});

  Wallet.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    return data;
  }
}

class Paypal {
  bool? enable;
  String? name;
  String? paypalSecret;
  String? paypalClient;
  String? image;
  bool? isSandbox;

  Paypal({this.name, this.enable, this.paypalSecret, this.isSandbox, this.paypalClient, this.image});

  Paypal.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    paypalSecret = json['paypalSecret'];
    paypalClient = json['paypalClient'];
    isSandbox = json['isSandbox'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['paypalSecret'] = paypalSecret;
    data['isSandbox'] = isSandbox;
    data['paypalClient'] = paypalClient;
    data['image'] = image;
    return data;
  }
}
