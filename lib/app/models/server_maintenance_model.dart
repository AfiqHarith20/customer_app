import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServerMaintenanceModel {
  bool? active;
  DateTime? endDateTime;
  String? id;
  DateTime? startDateTime;

  ServerMaintenanceModel({
    this.active,
    this.endDateTime,
    this.id,
    this.startDateTime,
  });

  factory ServerMaintenanceModel.fromRawJson(String str) =>
      ServerMaintenanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServerMaintenanceModel.fromJson(Map<String, dynamic> json) =>
      ServerMaintenanceModel(
        active: json["active"],
        endDateTime: json["endDateTime"] == null
            ? null
            : DateTime.parse(json["endDateTime"]),
        id: json["id"],
        startDateTime: json["startDateTime"] == null
            ? null
            : DateTime.parse(json["startDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "endDateTime": endDateTime?.toIso8601String(),
        "id": id,
        "startDateTime": startDateTime?.toIso8601String(),
      };

  // Add this factory constructor to map Firestore document data to the model
  factory ServerMaintenanceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServerMaintenanceModel(
      active: data['active'],
      endDateTime: (data['endDateTime'] as Timestamp).toDate(),
      id: data['id'],
      startDateTime: (data['startDateTime'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return 'ServerMaintenanceModel(active: $active, startDateTime: $startDateTime, endDateTime: $endDateTime, id: $id)';
  }
}
