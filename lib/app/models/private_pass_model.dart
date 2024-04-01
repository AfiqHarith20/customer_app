class PrivatePassModel {
  String? id;
  String? passName;
  String? validity;
  String? price;
  String? userType;
  bool? availability;
  bool? status;

  PrivatePassModel ({this.id, this.passName, this.validity, this.price, this.userType, this.availability, this.status});

  PrivatePassModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    passName = json['passName'];
    validity = json['validity'];
    price = json['price'];
    userType = json['userType'];
    availability = json['availability'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['passName'] = passName;
    data['validity'] = validity;
    data['price'] = price;
    data['userType'] = userType;
    data['availability'] = availability;
    data['status'] = status;
    return data;
  }
}