class TaxModel {
  String? country;
  bool? active;
  String? value;
  String? id;
  bool? isFix;
  String? name;

  TaxModel({this.country, this.active, this.value, this.id, this.isFix, this.name});

  TaxModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    active = json['active'];
    value = json['value'];
    id = json['id'];
    isFix = json['isFix'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['active'] = active;
    data['value'] = value;
    data['id'] = id;
    data['isFix'] = isFix;
    data['name'] = name;
    return data;
  }
}
