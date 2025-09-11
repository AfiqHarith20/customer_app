class ParkingFacilitiesModel {
  bool? active;
  String? name;
  String? id;
  String? image;

  ParkingFacilitiesModel({this.active, this.name, this.id, this.image});

  ParkingFacilitiesModel.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    name = json['name'];
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['name'] = name;
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
