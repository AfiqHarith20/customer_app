import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sliding_switch/sliding_switch.dart';

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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom sliding segmented control
                    _buildCustomSliding(controller),
                    // Content based on selected segment
                    _buildContent(
                        controller.seasonPassList, controller.privatePassList),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCustomSliding(SeasonPassController controller) {
    return Center(
      child: SlidingSwitch(
        value: controller.selectedSegment == 0 ? true : false,
        width: 350,
        onChanged: (bool value) {
          controller.changeSegment(value);
        },
        height: 40,
        animationDuration: const Duration(milliseconds: 400),
        onTap: () {},
        onDoubleTap: () {},
        onSwipe: () {},
        textOff: "Season Pass".tr,
        textOn: "Special Lot".tr,
        colorOn: Colors.black,
        colorOff: Colors.black,
        background: Colors.amber,
        buttonColor: const Color(0xfff7f5f7),
        inactiveColor: const Color(0xff636f7b),
      ),
    );
  }

  Widget _buildContent(List<SeasonPassModel> seasonPassList,
      List<PrivatePassModel> privatePassList) {
    return Expanded(
      child: Obx(() {
        if (controller.selectedSegment.value == false) {
          return _buildPassSection(seasonPassList);
        } else {
          return _buildPrivatePassSection(privatePassList);
        }
      }),
    );
  }

  Widget _buildPassSection(List<SeasonPassModel> seasonPassList) {
    return ListView.builder(
      itemCount: seasonPassList.length,
      itemBuilder: (context, index) {
        SeasonPassModel seasonPassModel = seasonPassList[index];
        return _buildPassItem(seasonPassModel);
      },
    );
  }

  Widget _buildPrivatePassSection(List<PrivatePassModel> privatePassList) {
    return ListView.builder(
      itemCount: privatePassList.length,
      itemBuilder: (context, index) {
        PrivatePassModel privatePassModel = privatePassList[index];
        return _buildPassItem(privatePassModel);
      },
    );
  }

  Widget _buildPassItem(dynamic passModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkGrey02.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                leading: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                      color: AppColors.yellow04,
                      borderRadius: BorderRadius.circular(200)),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/ic_pass.svg',
                      height: 20,
                    ),
                  ),
                ),
                title: Text(
                  passModel.passName.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppThemData.bold,
                    color: AppColors.darkGrey08,
                  ),
                ),
                subtitle: Text(
                  'RM ${passModel.price} ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppThemData.medium,
                    color: AppColors.yellow04,
                  ),
                ),
              ),
            ),
            Divider(height: 2, color: AppColors.darkGrey02.withOpacity(0.5)),
            const SizedBox(height: 10),
            itemWidget(
                subText: '${passModel.validity}', title: '${"Validity".tr}:'),
            InkWell(
              onTap: () {
                // Adjust navigation based on the pass type
                if (passModel is SeasonPassModel) {
                  Get.toNamed(Routes.PURCHASE_PASS,
                      arguments: {"seasonPassModel": passModel});
                } else if (passModel is PrivatePassModel) {
                  Get.toNamed(Routes.PURCHASE_PASS_PRIVATE,
                      arguments: {"privatePassModel": passModel});
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.yellow04,
                    borderRadius: BorderRadius.circular(200)),
                child: Center(
                  child: Text(
                    passModel is SeasonPassModel ? "Buy".tr : "Buy".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: AppThemData.regular,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
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
          Text(
            title.tr,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppThemData.regular,
              color: AppColors.darkGrey07,
            ),
          ),
          Text(
            subText.tr,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppThemData.medium,
              color: AppColors.labelColorLightPrimary,
            ),
          ),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }
}
