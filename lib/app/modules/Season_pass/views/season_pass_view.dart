import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/common_ui.dart';
import '../../../models/season_pass_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/season_pass_controller.dart';

class SeasonPassView extends GetView<SeasonPassController> {
  const SeasonPassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SeasonPassController>(
        init: SeasonPassController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(
              backgroundColor: AppColors.white,
              context,
              "Season Pass".tr,
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: InkWell(
              //       onTap: () {
              //         Get.toNamed(Routes.MY_SEASON_PASS);
              //       },
              //       child: Container(
              //         height: 40,
              //         width: 100,
              //         decoration: BoxDecoration(color: AppColors.yellow04, borderRadius: BorderRadius.circular(20)),
              //         child: const Center(
              //           child: Text(
              //             "My Pass",
              //             style: TextStyle(
              //               fontSize: 13,
              //               fontFamily: AppThemData.bold,
              //               color: AppColors.darkGrey08,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   )
              // ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : ListView.builder(
                    itemCount: controller.seasonPassList.length,
                    itemBuilder: (context, index) {
                      SeasonPassModel seasonPassModel = controller.seasonPassList[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.darkGrey02.withOpacity(0.5))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ListTile(
                                  leading: Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(color: AppColors.yellow04, borderRadius: BorderRadius.circular(200)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/ic_pass.svg',
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    seasonPassModel.passName.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: AppThemData.bold,
                                      color: AppColors.darkGrey08,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'RM ${seasonPassModel.price} ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: AppThemData.medium,
                                      color: AppColors.yellow04,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(height: 2, color: AppColors.darkGrey02.withOpacity(0.5)),
                              const SizedBox(
                                height: 10,
                              ),
                              itemWidget(
                                subText: '${seasonPassModel.validity}',
                                title: "Validity:",
                              ),
                              // itemWidget(
                              //   subText: '${seasonPassModel.userType}',
                              //   title: "This is for:",
                              // ),
                              // itemWidget(
                              //   subText: "Yes".tr,
                              //   title: 'Availability:',r
                              // ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.PURCHASE_PASS, arguments: {"seasonPassModel": seasonPassModel});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                                  height: 56,
                                  width: double.infinity,
                                  decoration: BoxDecoration(color: AppColors.yellow04, borderRadius: BorderRadius.circular(200)),
                                  child: Center(
                                    child: Text("Buy".tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: AppThemData.regular,
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        });
  }

  Widget itemWidget({
    required String subText,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.tr,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppThemData.regular,
                color: AppColors.darkGrey07,
              )),
          Text(subText.tr,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppThemData.medium,
                color: AppColors.labelColorLightPrimary,
              )),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }
}
