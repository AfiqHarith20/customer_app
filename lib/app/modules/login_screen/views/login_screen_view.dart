import 'dart:io';
import 'package:customer_app/app/widget/mobile_number_textfield.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenController> {
  const LoginScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightGrey02,
        appBar: AppBar(
          backgroundColor: AppColors.lightGrey02,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Quick Mobile Login".tr,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.darkGrey10,
                        fontFamily: AppThemData.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Access your account with ease by simply logging in with your mobile number."
                        .tr,
                    style: const TextStyle(
                        color: AppColors.lightGrey10,
                        fontFamily: AppThemData.regular),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  MobileNumberTextField(
                    title: "Mobile Number".tr,
                    controller: controller.phoneNumberController.value,
                    countryCode: controller.countryCode.value,
                    onPress: () {},
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ButtonThem.buildButton(
                    btnHeight: 56,
                    txtSize: 16,
                    context,
                    title: "Log in".tr,
                    txtColor: AppColors.lightGrey01,
                    bgColor: AppColors.darkGrey10,
                    onPress: () {
                      if (controller.formKey.value.currentState!.validate()) {
                        controller.sendCode();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(
                        thickness: 1,
                        color: AppColors.lightGrey07,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "or continue with".tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.darkGrey04,
                            fontSize: 12,
                            fontFamily: AppThemData.medium,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: Divider(
                        thickness: 1,
                        color: AppColors.lightGrey07,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonThem.buildButton(
                    btnHeight: 56,
                    txtSize: 16,
                    context,
                    title: "Google",
                    imageAsset: "assets/icons/ic_google.svg",
                    txtColor: AppColors.darkGrey07,
                    bgColor: AppColors.lightGrey06,
                    onPress: () {
                      controller.loginWithGoogle();
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: Platform.isIOS,
                    child: ButtonThem.buildButton(
                      btnHeight: 56,
                      txtSize: 16,
                      context,
                      title: "Apple",
                      imageAsset: "assets/icons/ic_apple.svg",
                      txtColor: AppColors.darkGrey07,
                      bgColor: AppColors.lightGrey06,
                      onPress: () {
                        controller.loginWithApple();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
