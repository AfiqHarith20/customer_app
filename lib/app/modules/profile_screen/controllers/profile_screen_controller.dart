import 'dart:developer';

import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/language_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> countryCode = TextEditingController().obs;
  RxBool isLoading = false.obs;

  RxBool isBookingScreen = false.obs;
  RxBool isWalletScreen = false.obs;

  RxString profileImage = "".obs;
  final ImagePicker imagePicker = ImagePicker();

  Rx<CustomerModel> customerModel = CustomerModel().obs;

  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getProfileData();
    getLanguage();
    super.onInit();
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        customerModel.value = value;
        fullNameController.value.text = customerModel.value.fullName!;
        emailController.value.text = customerModel.value.email!;
        countryCode.value.text = customerModel.value.countryCode!;
        phoneNumberController.value.text = customerModel.value.phoneNumber!;

        profileImage.value = customerModel.value.profilePic!;
        isLoading.value = true;
      }
    });
  }

  getLanguage() {
    selectedLanguage.value = Constant.getLanguage();
  }

  Future<void> deleteUserAccount() async {
    try {
      await FireStoreUtils.deleteUser().then((value) async {
        if (value == true) {
          await FirebaseAuth.instance.currentUser!.delete();
        }
      });
    } catch (e) {
      log(e.toString());
      // Handle general exception
    }
  }
}
