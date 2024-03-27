import 'package:customer_app/app/models/intro_screen_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/intro_screen_controller.dart';

class IntroScreenView extends GetView<IntroScreenController> {
  const IntroScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: AppBar(
          backgroundColor: AppColors.lightGrey02,
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 16,
          title: Obx(() => Row(
                children: [
                  if (controller.selectedPageIndex.value != 0)
                    InkWell(
                        onTap: () {
                          controller.selectedPageIndex.value--;
                          controller.pageController
                              .animateToPage(controller.selectedPageIndex.value, curve: Curves.linear, duration: const Duration(milliseconds: 300));
                        },
                        child: SvgPicture.asset("assets/icons/ic_arrow_left.svg")),
                  const Spacer(),
                  if (controller.selectedPageIndex.value != 1)
                    InkWell(
                      onTap: () {
                        Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                        Get.toNamed(Routes.WELCOME_SCREEN);
                      },
                      child: Row(
                        children: [
                          const Text(
                            "Skip",
                            style: TextStyle(color: AppColors.lightGrey10, fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          SvgPicture.asset("assets/icons/ic_right.svg")
                        ],
                      ),
                    )
                ],
              ))),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                controller.selectedPageIndex.value = value;
              },
              controller: controller.pageController,
              itemCount: controller.introScreenList.length,
              itemBuilder: (context, index) {
                IntroScreenModel introScreenModel = controller.introScreenList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("${introScreenModel.image}"))),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        introScreenModel.title.toString(),
                        style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 24),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        introScreenModel.description.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.lightGrey10, fontFamily: AppThemData.regular, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ButtonThem.buildButton(
            btnWidthRatio: .6,
            btnHeight: 56,
            txtSize: 16,
            context,
            title: "Next".tr,
            txtColor: AppColors.lightGrey01,
            bgColor: AppColors.darkGrey10,
            onPress: () {
              if (controller.selectedPageIndex.value == 1) {
                Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                Get.toNamed(Routes.WELCOME_SCREEN);
              } else {
                controller.selectedPageIndex.value++;
                controller.pageController.animateToPage(controller.selectedPageIndex.value, curve: Curves.linear, duration: const Duration(milliseconds: 300));
              }
            },
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
