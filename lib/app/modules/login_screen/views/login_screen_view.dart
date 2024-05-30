import 'dart:io';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/email_textfield.dart';
import 'package:customer_app/app/widget/password_textfield.dart';
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
        backgroundColor: AppColors.lightGrey05,
        // appBar: AppBar(
        //   backgroundColor: AppColors.lightGrey05,
        //   elevation: 0,
        // ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.loginformKey.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
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
                      "Access your account with ease by simply logging in with your email and password."
                          .tr,
                      style: const TextStyle(
                          color: AppColors.lightGrey10,
                          fontFamily: AppThemData.regular),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    EmailTextField(
                      title: "Email".tr,
                      controller: controller.emailController.value,
                      onPress: () {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    PasswordTextField(
                      title: "Password".tr,
                      controller: controller.passwordController.value,
                      onPress: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Forgot the password?".tr,
                          style: const TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.RESET_PASS_SCREEN);
                          },
                          child: Text(
                            "Click Here".tr,
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
                        if (controller.loginformKey.value.currentState!
                            .validate()) {
                          controller.sendSignIn();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?".tr,
                          style: const TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.REGISTER_SCREEN);
                          },
                          child: Text(
                            "Sign Up".tr,
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
                      btnHeight: 54,
                      txtSize: 16,
                      context,
                      title: "Sign in with Google",
                      imageAsset: "assets/icons/ic_google.svg",
                      txtColor: AppColors.darkGrey09,
                      bgColor: AppColors.white,
                      onPress: () {
                        controller.loginWithGoogle();
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Visibility(
                      visible: Platform.isIOS,
                      child: ButtonThem.buildButton(
                        btnHeight: 54,
                        txtSize: 16,
                        context,
                        title: "Sign in with Apple",
                        imageAsset: "assets/icons/ic_apple.svg",
                        txtColor: AppColors.darkGrey09,
                        bgColor: AppColors.white,
                        onPress: () {
                          controller.loginWithApple();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
