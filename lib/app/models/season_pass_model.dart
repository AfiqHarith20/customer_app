class SeasonPassModel {
  String? passid;
  String? passName;
  String? validity;
  String? price;
  String? userType;
  bool? availability;
  bool? status;

  SeasonPassModel(
      {this.passid,
      this.passName,
      this.validity,
      this.price,
      this.userType,
      this.availability,
      this.status});

  SeasonPassModel.fromJson(Map<String, dynamic> json) {
    passid = json['id'];
    passName = json['passName'];
    validity = json['validity'];
    price = json['price'];
    userType = json['userType'];
    availability = json['availability'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = passid;
    data['passName'] = passName;
    data['validity'] = validity;
    data['price'] = price;
    data['userType'] = userType;
    data['availability'] = availability;
    data['status'] = status;
    return data;
  }
}
