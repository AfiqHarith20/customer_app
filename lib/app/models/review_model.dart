import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? rating;
  String? id;
  String? customerId;
  String? parkingId;
  Timestamp? date;

  ReviewModel({this.rating, this.id, this.date, this.customerId, this.parkingId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    id = json['id'];
    date = json['date'];
    customerId = json['customerId'];
    parkingId = json['parkingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['rating'] = rating;
    data['id'] = id;
    data['date'] = date;
    data['customerId'] = customerId;
    data['parkingId'] = parkingId;
    return data;
  }
}
