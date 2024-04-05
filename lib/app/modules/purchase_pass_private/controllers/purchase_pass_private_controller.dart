import 'dart:ffi';
import 'dart:io';

import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';
import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  Rx<PrivatePassModel> selectedPrivatePass = PrivatePassModel().obs;

  Rx<PendingPassModel> pendingPassModel = PendingPassModel().obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxList<PrivatePassModel> privatePassList = <PrivatePassModel>[].obs;
  RxList<File> imageFiles = <File>[].obs;

  void removeImage(int index) {
    imageFiles.removeAt(index);
  }

  Rx<CustomerModel> customerModel = CustomerModel().obs;
  XFile? imageFile;

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
    if (argumentData != null) {
      PrivatePassModel temp = argumentData['privatePassModel'];
      selectedPrivatePass.value =
          privatePassList.where((p0) => p0.passId == temp.passId).first;
    }
    update();
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

  addPrivatePassData() async {
    pendingPassModel.value.id = Constant.getUuid();
    pendingPassModel.value.customerId = FireStoreUtils.getCurrentUid();
    pendingPassModel.value.privatePassModel = selectedPrivatePass.value;
    pendingPassModel.value.fullName = fullNameController.value.text;
    pendingPassModel.value.email = emailController.value.text;
    pendingPassModel.value.identificationNo =
        identificationNoController.value.text;
    pendingPassModel.value.mobileNumber = phoneNumberController.value.text;
    pendingPassModel.value.vehicleNo = vehicleNoController.value.text;
    pendingPassModel.value.lotNo = lotNoController.value.text;
    pendingPassModel.value.image = imageFile?.path;
    pendingPassModel.value.companyName = companyNameController.value.text;
    pendingPassModel.value.companyRegistrationNo =
        companyRegistrationNoController.value.text;
    pendingPassModel.value.address = addressController.value.text;
    pendingPassModel.value.countryCode = countryCode.reactive.toString();
    pendingPassModel.value.startDate = Timestamp.now();
    pendingPassModel.value.createAt = Timestamp.now();
    pendingPassModel.value.endDate = Timestamp.fromDate(DateTime.timestamp()
        .add(Duration(
            days:
                checkDuration(selectedPrivatePass.value.validity.toString()))));

    // Setting default status as "pending"
    pendingPassModel.value.status = "pending";

    // Now, send the data to Firestore
    await FireStoreUtils.setPendingPass(pendingPassModel.value, imageFile);
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

  pendingOrder() async {
    await FireStoreUtils.setPendingPass(pendingPassModel.value, imageFile)
        .then((value) {
      Get.back();
      Get.toNamed(Routes.DASHBOARD_SCREEN);
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFileGallery =
        await picker.pickImage(source: ImageSource.gallery);
    final pickedFileCamera = await picker.pickImage(source: ImageSource.camera);

    if (pickedFileGallery != null) {
      final image = File(pickedFileGallery.path);
      final compressedImage = await compressImage(image);
      imageFile = compressedImage;
      update();
    } else if (pickedFileCamera != null) {
      final image = File(pickedFileCamera.path);
      final compressedImage = await compressImage(image);
      imageFile = compressedImage;
      update();
    }
  }

  Future<XFile?> compressImage(File image) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      image.absolute.path,
      quality: 50, // Adjust quality as needed
    );
    return result;
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
