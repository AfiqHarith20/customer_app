import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/vehicle_model.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditVehicleScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<VehicleModel> customerVehicleModel = VehicleModel().obs;
  RxList<ColorHexModel> colorHexData = <ColorHexModel>[].obs;
  RxList<VehicleManufactureModel> vehicleManufactData =
      <VehicleManufactureModel>[].obs;
  Rx<GlobalKey<FormState>> formKeyVehicle = GlobalKey<FormState>().obs;
  Rx<TextEditingController> plateNoController = TextEditingController().obs;
  Rx<TextEditingController> vehicleModelController =
      TextEditingController().obs;
  var selectedColor = Rxn<ColorHexModel>();
  var selectedVehicle = Rxn<VehicleManufactureModel>();
  RxBool isDefault = false.obs;

  String? documentId;

  @override
  void onInit() {
    super.onInit();
    fetchColorHex();
    fetchVehicleManufact();
  }

  void initWithDocumentId(String? docId) {
    documentId = docId;
    if (documentId != null) {
      loadVehicleData();
    }
  }

  Future<void> loadVehicleData() async {
    try {
      isLoading.value = true;
      String currentUid = getCurrentUid();
      DocumentSnapshot vehicleDocSnapshot = await FirebaseFirestore.instance
          .collection(CollectionName.custVehicle)
          .doc(currentUid)
          .collection('vehicles')
          .doc(documentId)
          .get();

      if (vehicleDocSnapshot.exists) {
        var data = vehicleDocSnapshot.data() as Map<String, dynamic>;
        customerVehicleModel.update((val) {
          val?.vehicleNo = data['vehicleNo'];
          val?.vehicleModel = data['vehicleModel'];
          val?.colorHex = data['colorHex'];
          val?.vehicleManufacturer = data['vehicleManufacturer'];
          val?.vehicleDefault = data['default'];
          val?.active = data['active'];
        });

        plateNoController.value.text = data['vehicleNo'];
        vehicleModelController.value.text = data['vehicleModel'];
        isDefault.value = data['default'] ?? false;

        final ColorHexModel? selectedColorData = colorHexData.firstWhereOrNull(
          (color) => color.code == data['colorHex'],
        );
        if (selectedColorData != null) {
          selectedColor.value = selectedColorData;
        }

        final VehicleManufactureModel? selectedVehicleData =
            vehicleManufactData.firstWhereOrNull(
          (vehicle) => vehicle.name == data['vehicleManufacturer'],
        );
        if (selectedVehicleData != null) {
          selectedVehicle.value = selectedVehicleData;
        }
      }
    } catch (e) {
      print('Error loading vehicle data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> updateVehicle() async {
    try {
      isLoading.value = true;

      if (!validateInput()) return;

      String currentUid = getCurrentUid();
      DocumentReference vehicleDocRef = FirebaseFirestore.instance
          .collection(CollectionName.custVehicle)
          .doc(currentUid)
          .collection('vehicles')
          .doc(documentId!);

      await vehicleDocRef.update({
        'vehicleNo': plateNoController.value.text,
        'colorHex': selectedColor.value?.code ?? '',
        'vehicleManufacturer': selectedVehicle.value?.name ?? '',
        'vehicleModel': vehicleModelController.value.text ?? '',
        'default': isDefault.value,
        'active': true,
      });

      // Get.snackbar('Success'.tr, 'Vehicle updated successfully'.tr);
      print('Vehicle updated successfully');
    } catch (e) {
      Get.snackbar('Error'.tr, 'Error updating vehicle: $e');
      print('Error updating vehicle: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteVehicle() async {
    try {
      isLoading.value = true;
      String currentUid = getCurrentUid();
      DocumentReference vehicleDocRef = FirebaseFirestore.instance
          .collection(CollectionName.custVehicle)
          .doc(currentUid)
          .collection('vehicles')
          .doc(documentId!);

      await vehicleDocRef.delete();

      // Get.snackbar('Success'.tr, 'Vehicle deleted successfully'.tr);
      print('Vehicle deleted successfully');
    } catch (e) {
      Get.snackbar('Error'.tr, 'Error deleting vehicle: $e');
      print('Error deleting vehicle: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool validateInput() {
    if (plateNoController.value.text.isEmpty) {
      Get.snackbar('Error'.tr, 'Please enter a valid plate number'.tr);
      return false;
    }

    return true;
  }

  Future<void> fetchColorHex() async {
    try {
      isLoading.value = true;
      List<ColorHexModel>? data = await FireStoreUtils.getColorHex();
      if (data != null) {
        colorHexData.assignAll(data);
      }
    } catch (e) {
      print('Error fetching color hex data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVehicleManufact() async {
    try {
      isLoading.value = true;
      List<VehicleManufactureModel>? data =
          await FireStoreUtils.getVehicleManufacture();
      if (data != null) {
        vehicleManufactData.assignAll(data);
      }
    } catch (e) {
      print('Error fetching vehicle manufacture data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
