import 'dart:convert';

class VehicleModel {
  bool? active;
  String? colorHex;
  bool? vehicleDefault;
  String? vehicleManufacturer;
  String? vehicleModel;
  String? vehicleNo;

  VehicleModel({
    this.active,
    this.colorHex,
    this.vehicleDefault,
    this.vehicleManufacturer,
    this.vehicleModel,
    this.vehicleNo,
  });

  factory VehicleModel.fromRawJson(String str) =>
      VehicleModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        active: json["active"],
        colorHex: json["colorHex"],
        vehicleDefault: json["default"],
        vehicleManufacturer: json["vehicleManufacturer"],
        vehicleModel: json["vehicleModel"],
        vehicleNo: json["vehicleNo"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "colorHex": colorHex,
        "default": vehicleDefault,
        "vehicleManufacturer": vehicleManufacturer,
        "vehicleModel": vehicleModel,
        "vehicleNo": vehicleNo,
      };
}

class VehicleManufactureModel {
  bool? active;
  String? name;

  VehicleManufactureModel({
    this.active,
    this.name,
  });

  factory VehicleManufactureModel.fromRawJson(String str) =>
      VehicleManufactureModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleManufactureModel.fromJson(Map<String, dynamic> json) =>
      VehicleManufactureModel(
        active: json["active"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "name": name,
      };
}

class ColorHexModel {
  bool? active;
  String? name;
  String? code;

  ColorHexModel({
    this.active,
    this.name,
    this.code,
  });

  factory ColorHexModel.fromRawJson(String str) =>
      ColorHexModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ColorHexModel.fromJson(Map<String, dynamic> json) => ColorHexModel(
        active: json["active"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "name": name,
        "code": code,
      };
}
