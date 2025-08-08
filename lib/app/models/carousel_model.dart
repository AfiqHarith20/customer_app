import 'package:cloud_firestore/cloud_firestore.dart';

class CarouselModel {
  String? id;
  String? image;
  String? title;
  String? desc;
  bool? active;
  DateTime? date;

  CarouselModel({
    this.id,
    this.image,
    this.title,
    this.desc,
    this.active,
    this.date,
  });

  CarouselModel? carouselModel;

  // Updated fromJson method to handle new fields
  CarouselModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    desc = json['desc'];
    active = json['active'] ?? false;

    // Handle Timestamp for Firestore date field
    if (json['date'] != null) {
      if (json['date'] is Timestamp) {
        date = (json['date'] as Timestamp).toDate();
      } else if (json['date'] is String) {
        date = DateTime.tryParse(json['date']);
      }
    }

    // If nested carouselModel data exists, parse it as well
    carouselModel = json['carouselModel'] != null
        ? CarouselModel.fromJson(json['carouselModel'])
        : CarouselModel();
  }

  // Updated toJson method to include new fields
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['desc'] = desc;
    data['active'] = active;

    // Convert date to ISO8601 string if not null
    if (date != null) {
      data['date'] = date!.toIso8601String();
    }

    // Include nested carouselModel if it exists
    if (carouselModel != null) {
      data['carouselModel'] = carouselModel!.toJson();
    }
    return data;
  }
}
