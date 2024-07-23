import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/vehicle_model.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddVehicleScreenController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    fetchColorHex();
    fetchVehicleManufact();
  }

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await fetchColorHex();
    await fetchVehicleManufact();
    isLoading.value = false;
  }

  Future<void> addVehicle() async {
    try {
      isLoading.value = true;

      // Validate the input data
      if (!validateInput()) {
        isLoading.value = false;
        return;
      }

      // Get the current user's ID
      String currentUid = getCurrentUid();

      // Generate a unique ID for the vehicle document
      String vehicleId = const Uuid().v4();

      // Create a new vehicle document
      DocumentReference vehicleDocRef = FirebaseFirestore.instance
          .collection(CollectionName.custVehicle)
          .doc(currentUid)
          .collection('vehicles')
          .doc(vehicleId);

      await createVehicle(vehicleDocRef);

      Get.snackbar('Success'.tr, 'Vehicle added successfully'.tr);
      print('Vehicle added successfully');
    } catch (e) {
      Get.snackbar('Error'.tr, 'Error adding vehicle: $e');
      print('Error adding vehicle: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool validateInput() {
    if (plateNoController.value.text.isEmpty) {
      Get.snackbar('Error'.tr, 'Please enter a valid plate number'.tr);
      return false;
    }

    if (vehicleModelController.value.text.isEmpty) {
      Get.snackbar('Error'.tr, 'Please enter a valid vehicle model'.tr);
      return false;
    }

    if (customerVehicleModel.value.colorHex == null) {
      Get.snackbar('Error'.tr, 'Please select a color'.tr);
      return false;
    }

    if (customerVehicleModel.value.vehicleManufacturer == null) {
      Get.snackbar('Error'.tr, 'Please select a vehicle manufacturer'.tr);
      return false;
    }

    return true;
  }

  Future<void> createVehicle(DocumentReference vehicleDocRef) async {
    await vehicleDocRef.set({
      'vehicleNo': plateNoController.value.text,
      'colorHex': customerVehicleModel.value.colorHex,
      'vehicleManufacturer': customerVehicleModel.value.vehicleManufacturer,
      'vehicleModel': vehicleModelController.value.text,
      'active': true,
      'default': isDefault.value,
    });
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
