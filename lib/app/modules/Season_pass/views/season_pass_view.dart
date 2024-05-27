// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, library_private_types_in_public_api

import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/constant/dialogue_box.dart';
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

class SeasonPassView extends StatefulWidget {
  const SeasonPassView({Key? key}) : super(key: key);

  @override
  _SeasonPassViewState createState() => _SeasonPassViewState();
}

class _SeasonPassViewState extends State<SeasonPassView> {
  late SeasonPassController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SeasonPassController()); // Initialize the controller
  }

  // @override
  // void dispose() {
  //   Get.delete<
  //       SeasonPassController>(); // Don't forget to delete the controller when the widget is disposed
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetX<SeasonPassController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.lightGrey02,
          appBar: AppBar(
            title: Text(
              "Season Pass".tr,
              style: const TextStyle(color: AppColors.darkGrey07),
            ),
            backgroundColor: AppColors.white,
            leading: IconButton(
              color: AppColors.darkGrey07,
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await Get.offAllNamed(Routes.DASHBOARD_SCREEN);
              },
            ),
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom sliding segmented control
                    const SizedBox(
                      height: 10,
                    ),
                    _buildCustomSliding(controller),
                    // Content based on selected segment
                    _buildContent(context, controller.seasonPassList,
                        controller.privatePassList),
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
        textOn: "Reserve Lot".tr,
        colorOn: Colors.black,
        colorOff: Colors.black,
        background: Colors.amber,
        buttonColor: const Color(0xfff7f5f7),
        inactiveColor: const Color(0xff636f7b),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      List<SeasonPassModel> seasonPassList,
      List<PrivatePassModel> privatePassList) {
    return Expanded(
      child: Obx(() {
        if (controller.selectedSegment.value == false) {
          return _buildPassSection(context, seasonPassList);
        } else {
          return _buildPrivatePassSection(context, privatePassList);
        }
      }),
    );
  }

  Widget _buildPassSection(
      BuildContext context, List<SeasonPassModel> seasonPassList) {
    return controller.isLoading.value
        ? Constant.loader()
        : ListView.builder(
            itemCount: seasonPassList.length,
            itemBuilder: (context, index) {
              SeasonPassModel seasonPassModel = seasonPassList[index];
              return _buildPassItem(context, seasonPassModel);
            },
          );
  }

  Widget _buildPrivatePassSection(
      BuildContext context, List<PrivatePassModel> privatePassList) {
    return controller.isLoading.value
        ? Constant.loader()
        : ListView.builder(
            itemCount: privatePassList.length,
            itemBuilder: (context, index) {
              PrivatePassModel privatePassModel = privatePassList[index];
              return _buildPassItem(context, privatePassModel);
            },
          );
  }

  Widget _buildPassItem(BuildContext context, dynamic passModel) {
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
                  passModel.passName.toString().tr,
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
                subText: '${passModel.validity}'.tr, title: "Validity:".tr),
            InkWell(
              onTap: () async {
                bool emailVerified = await controller.isEmailVerified();
                if (emailVerified) {
                  // Adjust navigation based on the pass type
                  if (passModel is SeasonPassModel) {
                    Get.toNamed(Routes.PURCHASE_PASS,
                        arguments: {"seasonPassModel": passModel});
                  } else if (passModel is PrivatePassModel) {
                    Get.toNamed(Routes.PURCHASE_PASS_PRIVATE, arguments: {
                      "privatePassModel": passModel,
                      "selectedSegment": controller.selectedSegment.value,
                    });
                  }
                } else {
                  // Show a message to inform the user to verify their email
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogBoxNotify(
                        imageAsset: "assets/images/ic_email.png",
                        onPressConfirm: () async {
                          Navigator.of(context).pop();
                        },
                        onPressConfirmBtnName: "Ok".tr,
                        onPressConfirmColor: AppColors.yellow04,
                        content:
                            "Please verify your email before proceeding.".tr,
                        subTitle: "Email Verification".tr,
                      );
                    },
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                height: 48,
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
