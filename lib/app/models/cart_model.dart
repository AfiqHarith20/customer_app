import 'package:customer_app/app/models/compound_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';

class CartModel {
  CartModel({
    this.id,
    this.status,
    this.purchasePassModel,
    this.purchaseReservedLotModel,
    this.compoundModel,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      status: json['status'],
      purchasePassModel: json['purchasePassModel'] != null
          ? MyPurchasePassModel.fromJson(json['purchasePassModel'])
          : null,
      purchaseReservedLotModel: json['purchaseReservedLotModel'] != null
          ? MyPurchasePassPrivateModel.fromJson(
              json['purchaseReservedLotModel'])
          : null,
      compoundModel: json['compoundModel'] != null
          ? CompoundModel.fromJson(json['compoundModel'])
          : null,
    );
  }

  final String? id;
  final CompoundModel? compoundModel;
  final MyPurchasePassModel? purchasePassModel;
  final MyPurchasePassPrivateModel? purchaseReservedLotModel;
  final int? status;

  // Method to convert the CartModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'purchasePassModel': purchasePassModel?.toJson(),
      'purchaseReservedLotModel': purchaseReservedLotModel?.toJson(),
      'compoundModel': compoundModel?.toJson(),
    };
  }

  // Method to create a copy of CartModel with updated fields
  CartModel copyWith({
    String? id,
    int? status,
    MyPurchasePassModel? purchasePassModel,
    MyPurchasePassPrivateModel? purchaseReservedLotModel,
    CompoundModel? compoundModel,
  }) {
    return CartModel(
      id: id ?? this.id,
      status: status ?? this.status,
      purchasePassModel: purchasePassModel ?? this.purchasePassModel,
      purchaseReservedLotModel:
          purchaseReservedLotModel ?? this.purchaseReservedLotModel,
      compoundModel: compoundModel ?? this.compoundModel,
    );
  }
}
