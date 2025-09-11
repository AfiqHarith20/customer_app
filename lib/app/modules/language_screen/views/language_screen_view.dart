import 'dart:convert';

import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/services/localization_service.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/language_screen_controller.dart';

class LanguageScreenView extends StatelessWidget {
  const LanguageScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LanguageScreenController>(
        init: LanguageScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(context, "Change Language".tr, isBack: true, backgroundColor: AppColors.white),
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.languageList.isEmpty
                    ? Constant.showEmptyView(message: "No Language Available")
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: controller.languageList.length,
                              itemBuilder: (context, int index) {
                                return Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller.languageList[index].name.toString(),
                                          style: const TextStyle(fontSize: 16, fontFamily: AppThemData.medium),
                                        ),
                                        Radio(
                                            value: controller.languageList[index],
                                            groupValue: controller.selectedLanguage.value,
                                            activeColor: AppColors.yellow04,
                                            onChanged: (value) {
                                              controller.selectedLanguage.value = controller.languageList[index];
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ButtonThem.buildButton(
                    context,
                    title: "Save".tr,
                    txtColor: AppColors.white,
                    bgColor: AppColors.darkGrey10,
                    onPress: () {
                      LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                      Preferences.setString(
                        Preferences.languageCodeKey,
                        jsonEncode(
                          controller.selectedLanguage.value,
                        ),
                      );
                      Get.back(result: true);
                    },
                  )),
            ),
          );
        });
  }
}
