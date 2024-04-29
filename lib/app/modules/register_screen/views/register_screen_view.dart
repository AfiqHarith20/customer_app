import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/email_textfield.dart';
import 'package:customer_app/app/widget/password_textfield.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';

import '../controllers/register_screen_controller.dart';

class RegisterScreenView extends GetView<RegisterScreenController> {
  const RegisterScreenView({Key? key}) : super(key: key);

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
            key: controller.regformKey.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Register_New_Account".tr,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.darkGrey10,
                        fontFamily: AppThemData.bold),
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
                  const SizedBox(
                    height: 32,
                  ),
                  ButtonThem.buildButton(
                    btnHeight: 56,
                    txtSize: 16,
                    context,
                    title: "Sign Up".tr,
                    txtColor: AppColors.lightGrey01,
                    bgColor: AppColors.darkGrey10,
                    onPress: () {
                      if (controller.regformKey.value.currentState!
                          .validate()) {
                        controller.sendSignUp();
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
                        "Already have an account?".tr,
                        style: const TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.LOGIN_SCREEN);
                        },
                        child: Text(
                          "Log in".tr,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
