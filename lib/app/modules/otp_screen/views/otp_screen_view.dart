import 'package:customer_app/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../controllers/otp_screen_controller.dart';

class OtpScreenView extends GetView<OtpScreenController> {
  const OtpScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightGrey02,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SvgPicture.asset("assets/icons/ic_arrow_left.svg"),
          ),
          backgroundColor: AppColors.lightGrey02,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Text(
                "Secure Verification".tr,
                style: TextStyle(fontSize: 20, color: AppColors.darkGrey10, fontFamily: AppThemData.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Ensure security with a one-time password (OTP) verification step for your account.".tr,
                style: TextStyle(color: AppColors.lightGrey10, fontFamily: AppThemData.regular),
              ),
              const SizedBox(
                height: 62,
              ),
              PinCodeTextField(
                length: 6,
                appContext: context,
                keyboardType: TextInputType.phone,
                enablePinAutofill: true,
                hintCharacter: "-",
                enableActiveFill: true,
                hintStyle: const TextStyle(color: AppColors.darkGrey04),
                textStyle: const TextStyle(color: AppColors.darkGrey07, fontSize: 16),
                pinTheme: PinTheme(
                  selectedColor: AppColors.yellow04,
                  activeColor: AppColors.white,
                  selectedBorderWidth: 1,
                  selectedFillColor: AppColors.white,
                  activeFillColor: AppColors.white,
                  inactiveFillColor: AppColors.white,
                  inactiveColor: AppColors.white,
                  disabledColor: AppColors.white,
                  shape: PinCodeFieldShape.circle,
                ),
                cursorColor: AppColors.lightGrey10,
                controller: controller.otpController.value,
                onCompleted: (v) async {},
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 28,
              ),
              ButtonThem.buildButton(
                btnHeight: 56,
                txtSize: 16,
                context,
                title: "Verify".tr,
                txtColor: AppColors.lightGrey01,
                bgColor: AppColors.darkGrey10,
                onPress: () {
                  controller.verifyOtp();
                },
              ),
              const SizedBox(
                height: 28,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: "Didn’t get OTP?".tr,
                      style: const TextStyle(
                        color: AppColors.darkGrey04,
                        fontFamily: AppThemData.medium,
                      ),
                      children: [
                        TextSpan(
                            text: " Resend".tr,
                            style: const TextStyle(
                              color: AppColors.darkGrey07,
                              fontFamily: AppThemData.medium,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                LoginScreenController loginController = Get.put(LoginScreenController());
                                loginController.sendCode();
                              })
                      ]),
                ),
              )
            ],
          ),
        ));
  }
}
