import 'dart:developer';

import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/language_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKeyProfile = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> countryCode = TextEditingController().obs;
  RxBool isLoading = false.obs;

  RxBool isBookingScreen = false.obs;
  RxBool isWalletScreen = false.obs;

  RxString profileImage = "".obs;
  var appVersion = ''.obs;
  final ImagePicker imagePicker = ImagePicker();

  Rx<CustomerModel> customerModel = CustomerModel().obs;

  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    getProfileData();
    getLanguage();
    getAppVersion();
    super.onInit();
  }

  Future<void> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
    } catch (e) {
      appVersion.value = 'Unknown';
    }
  }

  getProfileData() async {
    // Start loading
    isLoading.value = true;

    try {
      bool isLogin =
          await FireStoreUtils.isLogin(); // Check if the user is logged in

      if (isLogin) {
        // If logged in, fetch the user profile data
        var value =
            await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid());
        if (value != null) {
          customerModel.value = value;
          fullNameController.value.text =
              customerModel.value.fullName ?? 'Guest';
          emailController.value.text =
              customerModel.value.email ?? 'guest@email.com';
          countryCode.value.text = customerModel.value.countryCode ?? '';
          phoneNumberController.value.text =
              customerModel.value.phoneNumber ?? '';
          profileImage.value = customerModel.value.profilePic ?? '';
        }
      } else {
        // If the user is not logged in, set guest information
        customerModel.value = CustomerModel(
          fullName: 'Guest',
          email: 'guest@email.com',
          countryCode: '',
          phoneNumber: '',
          profilePic: '', // Optionally, you can use a placeholder image here
        );

        // Update the controllers with the guest info
        fullNameController.value.text = 'Guest';
        emailController.value.text = 'guest@email.com';
        countryCode.value.text = '';
        phoneNumberController.value.text = '';
        profileImage.value =
            ''; // Optionally, set a placeholder image for the guest
      }
    } catch (e) {
      // Handle any errors that may occur
      print("Error fetching profile data: $e");
      // Optionally, you can show an error message to the user or log the error
    } finally {
      // Mark loading as finished
      isLoading.value = false;
    }
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
