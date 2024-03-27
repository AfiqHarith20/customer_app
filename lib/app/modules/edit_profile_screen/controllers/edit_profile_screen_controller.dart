import 'dart:io';

import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  RxString countryCode = "+60".obs;
  RxBool isLoading = false.obs;

  RxList<String> genderList = ["Male".tr, "Female".tr].obs;
  RxString selectedGender = "Male".tr.obs;
  RxString profileImage = "".obs;
  final ImagePicker imagePicker = ImagePicker();

  Rx<CustomerModel> customerModel = CustomerModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      customerModel.value = argumentData['customerModel'];
      fullNameController.value.text = customerModel.value.fullName!;
      emailController.value.text = customerModel.value.email!;
      countryCode.value = customerModel.value.countryCode!;
      phoneNumberController.value.text = customerModel.value.phoneNumber!;
      selectedGender.value = customerModel.value.gender!;
      profileImage.value = customerModel.value.profilePic!;
      isLoading.value = true;
    }
  }

  updateProfile() async {
    ShowToastDialog.showLoader("please_wait".tr);
    if (profileImage.value.isNotEmpty && Constant().hasValidUrl(profileImage.value) == false) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "profileImage/${FireStoreUtils.getCurrentUid()}",
        File(profileImage.value).path.split('/').last,
      );
    }
    CustomerModel customerModelData = customerModel.value;
    customerModelData.fullName = fullNameController.value.text;
    customerModelData.email = emailController.value.text;
    customerModelData.countryCode = countryCode.value;
    customerModelData.phoneNumber = phoneNumberController.value.text;
    customerModelData.profilePic = profileImage.value;
    customerModelData.gender = selectedGender.value;
    Constant.customerName = customerModelData.fullName!;
    await FireStoreUtils.updateUser(customerModelData).then((value) {
      ShowToastDialog.showToast("Save Successfully");
      ShowToastDialog.closeLoader();
    });
  }

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      profileImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }
}
