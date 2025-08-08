import 'package:customer_app/app/modules/reset_password_screen/controllers/reset_password_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/email_textfield.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class ResetPasswordScreenView extends GetView<ResetPasswordScreenController> {
  const ResetPasswordScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiInterface().customAppBar(
        context,
        "Reset Password".tr,
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.resetformKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Reset New Password".tr,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.darkGrey10,
                    fontFamily: AppThemData.bold,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                EmailTextField(
                  title: "Email".tr,
                  controller: controller.emailController,
                  onPress: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonThem.buildButton(
                  btnHeight: 56,
                  txtSize: 16,
                  context,
                  title: "Reset Password".tr,
                  txtColor: AppColors.lightGrey01,
                  bgColor: AppColors.darkGrey10,
                  onPress: () async {
                    if (controller.resetformKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.darkGrey10,
                              ),
                            ),
                          );
                        },
                      );
                      await controller.resetPassword();
                      Navigator.of(context).pop();
                      Get.offAndToNamed(Routes.LOGIN_SCREEN);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
