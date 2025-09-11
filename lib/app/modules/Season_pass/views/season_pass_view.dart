// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, library_private_types_in_public_api

import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
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
  const SeasonPassView({super.key});

  @override
  _SeasonPassViewState createState() => _SeasonPassViewState();
}

class _SeasonPassViewState extends State<SeasonPassView> {
  late SeasonPassController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SeasonPassController());
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SeasonPassController>(
      init: controller,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: AppBar(
              title: Text(
                "Season Pass".tr,
                style: const TextStyle(
                  color: AppColors.darkGrey07,
                  fontFamily: AppThemData.bold,
                ),
              ),
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                color: AppColors.darkGrey07,
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  Get.back();
                },
              ),
            ),
            body: controller.isLoading.value
                ? Center(child: Constant.loader())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      _buildSegmentedControl(controller),
                      const SizedBox(height: 16),
                      _buildContent(context, controller.seasonPassList,
                          controller.privatePassList),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSegmentedControl(SeasonPassController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSegmentButton(
            context,
            title: "Season Pass".tr,
            isSelected: controller.selectedSegment.value == 0,
            onTap: () => controller.changeSegment(0),
          ),
          _buildSegmentButton(
            context,
            title: "Reserve Lot".tr,
            isSelected: controller.selectedSegment.value == 1,
            onTap: () => controller.changeSegment(1),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(BuildContext context,
      {required String title,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.darkGrey10 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.darkGrey07,
                fontFamily: isSelected ? AppThemData.bold : AppThemData.medium,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      List<SeasonPassModel> seasonPassList,
      List<PrivatePassModel> privatePassList) {
    return Expanded(
      child: Obx(() {
        if (controller.selectedSegment.value == 0) {
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
        ? Center(child: Constant.loader())
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: seasonPassList.length,
            itemBuilder: (context, index) {
              SeasonPassModel seasonPassModel = seasonPassList[index];
              return _buildPassCard(
                context,
                passName: seasonPassModel.passName.toString().tr,
                price: 'RM ${seasonPassModel.price}',
                validity: '${seasonPassModel.validity}'.tr,
                onBuy: () => _onBuyTapped(context, controller, seasonPassModel),
                isPrivate: false,
              );
            },
          );
  }

  Widget _buildPrivatePassSection(
      BuildContext context, List<PrivatePassModel> privatePassList) {
    return controller.isLoading.value
        ? Center(child: Constant.loader())
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: privatePassList.length,
            itemBuilder: (context, index) {
              PrivatePassModel privatePassModel = privatePassList[index];
              return _buildPassCard(
                context,
                passName: privatePassModel.passName.toString().tr,
                price: 'RM ${privatePassModel.price}',
                validity: '${privatePassModel.validity}'.tr,
                onBuy: () =>
                    _onBuyTapped(context, controller, privatePassModel),
                isPrivate: true,
              );
            },
          );
  }

  Widget _buildPassCard(BuildContext context,
      {required String passName,
      required String price,
      required String validity,
      required VoidCallback onBuy,
      required bool isPrivate}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.yellow04,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/ic_pass.svg',
                      height: 24,
                      width: 24,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: AppThemData.bold,
                          color: AppColors.darkGrey08,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: AppThemData.bold,
                          color: AppColors.yellow04,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.lightGrey05),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Validity:".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppThemData.regular,
                    color: AppColors.darkGrey07,
                  ),
                ),
                Text(
                  validity,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppThemData.medium,
                    color: AppColors.labelColorLightPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow04,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: Text(
                  "Buy".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppThemData.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBuyTapped(BuildContext context, SeasonPassController controller,
      dynamic passModel) async {
    bool isLogin = await FireStoreUtils.isLogin();
    if (!isLogin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogBox(
            imageAsset: "assets/images/ic_log_in.png",
            onPressConfirm: () async {
              Get.offAllNamed(Routes.LOGIN_SCREEN);
            },
            onPressConfirmBtnName: "Login".tr,
            onPressConfirmColor: AppColors.green04,
            onPressCancel: () {
              Get.back();
            },
            content: "Please login or register before proceeding.".tr,
            subTitle: "Login Required".tr,
            onPressCancelBtnName: "Cancel".tr,
            onPressCancelColor: AppColors.darkGrey01,
          );
        },
      );
    } else {
      bool emailVerified = await controller.isEmailVerified();
      if (!emailVerified) {
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
              content: "Please verify your email before proceeding.".tr,
              subTitle: "Email Verification".tr,
            );
          },
        );
      } else {
        if (controller.selectedSegment.value == 0 &&
            passModel is SeasonPassModel) {
          Get.toNamed(Routes.PURCHASE_PASS,
              arguments: {"seasonPassModel": passModel});
        } else if (controller.selectedSegment.value == 1 &&
            passModel is PrivatePassModel) {
          Get.toNamed(Routes.PURCHASE_PASS_PRIVATE, arguments: {
            "privatePassModel": passModel,
            "selectedSegment": controller.selectedSegment.value,
          });
        }
      }
    }
  }
}
