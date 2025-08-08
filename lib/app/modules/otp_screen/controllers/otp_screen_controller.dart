import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class OtpScreenController extends GetxController {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString verificationId = "".obs;
  RxInt resendToken = 0.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      countryCode.value = argumentData['countryCode'];
      phoneNumber.value = argumentData['phoneNumber'];
      verificationId.value = argumentData['verificationId'];
    }

    update();
  }

  verifyOtp() async {
    if (otpController.value.text.length == 6) {
      ShowToastDialog.showLoader("Verify OTP".tr);

      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otpController.value.text);
      String fcmToken = await NotificationService.getToken();
      await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
        if (value.additionalUserInfo!.isNewUser) {
          CustomerModel customerModel = CustomerModel();
          customerModel.id = value.user!.uid;
          customerModel.countryCode = countryCode.value;
          customerModel.phoneNumber = phoneNumber.value;
          customerModel.loginType = Constant.phoneLoginType;
          customerModel.fcmToken = fcmToken;

          ShowToastDialog.closeLoader();

          Get.offNamed(Routes.INFORMATION_SCREEN, arguments: {
            "customerModel": customerModel,
          });
        } else {
          await FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              CustomerModel? customerModel = await FireStoreUtils.getUserProfile(value.user!.uid);
              if (customerModel != null) {
                if (customerModel.active == true) {
                  Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                }
                else{
                  ShowToastDialog.showToast("Unable to Log In?  Please Contact the Admin for Assistance");
                }
              }
            } else {
              CustomerModel customerModel = CustomerModel();
              customerModel.id = value.user!.uid;
              customerModel.countryCode = countryCode.value;
              customerModel.phoneNumber = phoneNumber.value;
              customerModel.loginType = Constant.phoneLoginType;
              customerModel.fcmToken = fcmToken;

              Get.offNamed(Routes.INFORMATION_SCREEN, arguments: {
                "customerModel": customerModel,
              });
            }
          });
        }
      }).catchError((error) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("invalid_code".tr);
      });
    } else {
      ShowToastDialog.showToast("enter_valid_otp".tr);
    }
  }
}
