import 'dart:io';

import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PurchasePassPrivateController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> identificationNoController =
      TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> vehicleNoController = TextEditingController().obs;
  Rx<TextEditingController> lotNoController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> companyRegistrationNoController =
      TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  RxString countryCode = "+60".obs;
  List<String> type = [
    "Pas Mingguan 1",
    "Pas Mingguan 2",
    "Pas Mingguan 3",
    "Pas Bulanan 1",
    "Pas Bulanan 6",
    "Pas Bulanan 12"
  ];
  Rx<PrivatePassModel> selectedSessionPass = PrivatePassModel().obs;

  Rx<MyPurchasePassPrivateModel> purchasePassModel =
      MyPurchasePassPrivateModel().obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxList<PrivatePassModel> privatePassList = <PrivatePassModel>[].obs;
  RxList<File> imageFiles = <File>[].obs;

  void removeImage(int index) {
    imageFiles.removeAt(index);
  }

  Rx<CustomerModel> customerModel = CustomerModel().obs;
  File? imageFile;

  @override
  void onInit() {
    getArgument();
    getProfileData();
    super.onInit();
  }

  getArgument() async {
    await FireStoreUtils.getPrivatePassData().then((value) {
      if (value != null) {
        privatePassList.value = value;
      }
    });

    dynamic argumentData = Get.arguments;
    if (argumentData != null && argumentData['seasonPassModel'] != null) {
      PrivatePassModel temp = argumentData['seasonPassModel'];
      selectedSessionPass.value =
          privatePassList.firstWhereOrNull((p0) => p0.id == temp.id)!;
    }
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        customerModel.value = value;
        fullNameController.value.text = customerModel.value.fullName!;
        emailController.value.text = customerModel.value.email!;
        phoneNumberController.value.text = customerModel.value.phoneNumber!;
      }
    });
  }

  addSeasonPassData() async {
    purchasePassModel.value.id = Constant.getUuid();
    purchasePassModel.value.customerId = FireStoreUtils.getCurrentUid();
    purchasePassModel.value.privatePassModel = selectedSessionPass.value;
    purchasePassModel.value.fullName = fullNameController.value.text;
    purchasePassModel.value.email = emailController.value.text;
    purchasePassModel.value.identificationNo =
        identificationNoController.value.text;
    purchasePassModel.value.mobileNumber = phoneNumberController.value.text;
    purchasePassModel.value.vehicleNo = vehicleNoController.value.text;
    purchasePassModel.value.lotNo = lotNoController.value.text;
    purchasePassModel.value.companyName = companyNameController.value.text;
    purchasePassModel.value.companyRegistrationNo =
        companyRegistrationNoController.value.text;
    purchasePassModel.value.address = addressController.value.text;
    purchasePassModel.value.countryCode = countryCode.reactive.toString();
    purchasePassModel.value.startDate = Timestamp.now();
    purchasePassModel.value.createAt = Timestamp.now();
    purchasePassModel.value.endDate = Timestamp.fromDate(DateTime.timestamp()
        .add(Duration(
            days:
                checkDuration(selectedSessionPass.value.validity.toString()))));
  }

  checkDuration(String time) {
    if (time == "1 Minggu") {
      return 7;
    } else if (time == "2 Minggu") {
      return 14;
    } else if (time == "3 Minggu") {
      return 21;
    } else if (time == "1 Bulan") {
      return 30;
    } else if (time == "3 Bulan") {
      return 90;
    } else if (time == "6 Bulan") {
      return 182;
    } else if (time == "12 Bulan") {
      return 365;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFileGallery =
        await picker.pickImage(source: ImageSource.gallery);
    final pickedFileCamera = await picker.pickImage(source: ImageSource.camera);

    if (pickedFileGallery != null) {
      imageFile = File(pickedFileGallery.path);
      update();
    } else if (pickedFileCamera != null) {
      imageFile = File(pickedFileCamera.path);
      update();
    }
  }

  Future<void> onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile;

      if (source == ImageSource.camera) {
        pickedFile = await picker.pickImage(source: ImageSource.camera);
      } else {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        imageFiles.add(imageFile); // Add the selected image to the list
        update(); // Update the UI
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
