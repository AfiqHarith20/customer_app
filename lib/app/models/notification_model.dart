import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? category;
  Timestamp? createAt;
  bool? isRead;
  String? message;
  String? reference;
  String? title;
  bool? isSelected;

  NotificationModel({
    this.title,
    this.createAt,
    this.category,
    this.reference,
    this.message,
    this.isSelected,
    this.isRead,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    createAt = json['createAt'];
    category = json['category'];
    reference = json['reference'];
    message = json['message'];
    isRead = json['isRead'];
  }
}
