import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/welcome_screen_controller.dart';

class WelcomeScreenView extends GetView<WelcomeScreenController> {
  const WelcomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.yellow04,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Elevate Your Parking Experience with NAZIFA PARKING".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24,
                      fontFamily: AppThemData.bold,
                      color: AppColors.darkGrey10),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Enjoy a seamless and stress-free parking experience with NAZIFA PARKING"
                      .tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.darkGrey08,
                      fontFamily: AppThemData.regular,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 24,
                ),
                ButtonThem.buildButton(
                  btnWidthRatio: .7,
                  btnHeight: 56,
                  txtSize: 16,
                  context,
                  title: "Let's Start".tr,
                  txtColor: AppColors.lightGrey01,
                  bgColor: AppColors.darkGrey10,
                  onPress: () {
                    Get.toNamed(Routes.DASHBOARD_SCREEN);
                  },
                ),
                const SizedBox(
                  height: 76,
                ),
              ],
            ),
          ),
        ));
  }
}
