import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/referral_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InformationScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKeyInfo = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> identificationNoController =
      TextEditingController().obs;
  RxString countryCode = "+60".obs;
  Rx<TextEditingController> referralCodeController =
      TextEditingController().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<String> genderList = ["Male", "Female"].obs;
  RxList<Map<String, String>> icList = [
    {"value": "1", "name": "New Identity Number"},
    {"value": "2", "name": "Old Identity Number"},
    {"value": "3", "name": "Passport Number"},
    {"value": "4", "name": "Business Registration"},
    {"value": "5", "name": "Others"}
  ].obs;
  RxString selectedIc = "1".obs; // Default selected value
  RxString selectedGender = "".obs;
  RxString profileImage = "".obs;
  RxString loginType = "".obs;

  final ImagePicker imagePicker = ImagePicker();

  // ActionCodeSettings for email verification
  final ActionCodeSettings acs = ActionCodeSettings(
    url:
        'https://nazifa-parking-29f2b.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
    handleCodeInApp: true,
    iOSBundleId: 'com.example.ios',
    androidPackageName: 'com.terasoft.nazifaparking',
    androidInstallApp: true,
    androidMinimumVersion: '12',
  );

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      customerModel.value = argumentData['customerModel'];
      loginType.value = customerModel.value.loginType.toString();
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.value.text =
            customerModel.value.phoneNumber.toString();
        countryCode.value = customerModel.value.countryCode.toString();
      } else {
        emailController.value.text = customerModel.value.email.toString();
        if (customerModel.value.fullName != null) {
          fullNameController.value.text =
              customerModel.value.fullName.toString();
        }
      }
    }
    update();
  }

  void goToDashboardScreen() {
    Get.offAllNamed(Routes.DASHBOARD_SCREEN);
  }

  createAccount() async {
    bool isVerified = await isEmailVerified(emailController.value.text);
    String fcmToken = await NotificationService.getToken();
    String firstTwoChar =
        fullNameController.value.text.substring(0, 2).toUpperCase();

    if (profileImage.value.isNotEmpty) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "profileImage/${FireStoreUtils.getCurrentUid()}",
        File(profileImage.value).path.split('/').last,
      );
    }

    if (isVerified) {
      goToDashboardScreen();
    } else {
      await sendEmailVerification();
    }

    if (referralCodeController.value.text.isNotEmpty) {
      await FireStoreUtils.checkReferralCodeValidOrNot(
              referralCodeController.value.text)
          .then((value) async {
        if (value == true) {
          ShowToastDialog.showLoader("please_wait".tr);
          await updateUserProfile(fcmToken, firstTwoChar);
        } else {
          ShowToastDialog.showToast("referral_code_invalid".tr);
        }
      });
    } else {
      ShowToastDialog.showLoader("please_wait".tr);
      await updateUserProfile(fcmToken, firstTwoChar);
    }
  }

  Future<void> updateUserProfile(String fcmToken, String firstTwoChar) async {
    CustomerModel customerModelData = customerModel.value;
    customerModelData.fullName = fullNameController.value.text;
    customerModelData.email = emailController.value.text;
    customerModelData.countryCode = countryCode.value;
    customerModelData.phoneNumber = phoneNumberController.value.text;
    customerModelData.identificationNo = identificationNoController.value.text;
    customerModelData.identificationType = selectedIc.value;
    customerModelData.profilePic = profileImage.value;
    customerModelData.gender = selectedGender.value;
    customerModelData.fcmToken = fcmToken;
    customerModelData.createdAt = Timestamp.now();
    Constant.customerName = customerModelData.fullName!;

    ReferralModel referralModel = ReferralModel(
        id: FireStoreUtils.getCurrentUid(),
        referralBy: "",
        referralCode: Constant.getReferralCode(firstTwoChar));
    await FireStoreUtils.referralAdd(referralModel);

    await FireStoreUtils.updateUser(customerModelData).then((value) {
      ShowToastDialog.closeLoader();
      if (value == true) {
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      }
    });
  }

  Future<bool> isEmailVerified(String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.emailVerified;
    } else {
      return false;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      String email = emailController.value.text;
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      _showEmailVerifiedSnackbar("A verification email has been sent to ".tr +
          email +
          ".Please verify your email to make sure you can make any transaction."
              .tr);
    } catch (error) {
      print('Error sending verification email: $error');
      ShowToastDialog.showToast('Error sending verification email');
    }
  }

  void _showEmailVerifiedSnackbar(String message) {
    Get.snackbar(
      "Email Verification".tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 8),
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16.0),
      borderRadius: 10.0,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
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
