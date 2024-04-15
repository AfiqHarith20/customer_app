import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/referral_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InformationScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  RxString countryCode = "+60".obs;
  Rx<TextEditingController> referralCodeController =
      TextEditingController().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;

  RxList<String> genderList = ["Male", "Female"].obs;
  RxString selectedGender = "Male".obs;
  RxString profileImage = "".obs;
  RxString loginType = "".obs;

  final ImagePicker imagePicker = ImagePicker();

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
        // Check if fullName is not null before assigning
        if (customerModel.value.fullName != null) {
          fullNameController.value.text =
              customerModel.value.fullName.toString();
        }
      }
    }
    update();
  }

  createAccount() async {
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

    if (referralCodeController.value.text.isNotEmpty) {
      await FireStoreUtils.checkReferralCodeValidOrNot(
              referralCodeController.value.text)
          .then((value) async {
        if (value == true) {
          ShowToastDialog.showLoader("please_wait".tr);
          CustomerModel customerModelData = customerModel.value;
          customerModelData.fullName = fullNameController.value.text;
          customerModelData.email = emailController.value.text;
          customerModelData.countryCode = countryCode.value;
          customerModelData.phoneNumber = phoneNumberController.value.text;
          customerModelData.profilePic = profileImage.value;
          customerModelData.gender = selectedGender.value;
          customerModelData.fcmToken = fcmToken;
          customerModelData.createdAt = Timestamp.now();
          Constant.customerName = customerModelData.fullName!;

          FireStoreUtils.getReferralUserByCode(
                  referralCodeController.value.text)
              .then((value) async {
            if (value != null) {
              ReferralModel ownReferralModel = ReferralModel(
                  id: FireStoreUtils.getCurrentUid(),
                  referralBy: value.id,
                  referralCode: Constant.getReferralCode(firstTwoChar));
              await FireStoreUtils.referralAdd(ownReferralModel);
            } else {
              ReferralModel referralModel = ReferralModel(
                  id: FireStoreUtils.getCurrentUid(),
                  referralBy: "",
                  referralCode: Constant.getReferralCode(firstTwoChar));
              await FireStoreUtils.referralAdd(referralModel);
            }
          });

          await FireStoreUtils.updateUser(customerModelData).then((value) {
            ShowToastDialog.closeLoader();
            if (value == true) {
              Get.offAllNamed(Routes.DASHBOARD_SCREEN);
            }
          });
        } else {
          ShowToastDialog.showToast("referral_code_invalid".tr);
        }
      });
    } else {
      ShowToastDialog.showLoader("please_wait".tr);
      CustomerModel customerModelData = customerModel.value;
      customerModelData.fullName = fullNameController.value.text;
      customerModelData.email = emailController.value.text;
      customerModelData.countryCode = countryCode.value;
      customerModelData.phoneNumber = phoneNumberController.value.text;
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
