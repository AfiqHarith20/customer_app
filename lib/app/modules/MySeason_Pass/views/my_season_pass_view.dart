import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:customer_app/app/modules/Season_pass/controllers/season_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../../../../constant/constant.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/common_ui.dart';
import '../../../routes/app_pages.dart';
import '../controllers/my_season_pass_controller.dart';

class MySeasonPassView extends GetView<MySeasonPassController> {
  const MySeasonPassView({super.key});

  @override
  Widget build(BuildContext context) {
    bool paymentCompleted = Get.arguments?['paymentCompleted'] ?? false;
    if (paymentCompleted) {
      controller.reload(); // Adjust this method to refresh your data
    }
    return GetX<MySeasonPassController>(
        init: MySeasonPassController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              Get.back();
              return false;
            },
            child: Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: UiInterface().customAppBar(
                backgroundColor: AppColors.lightGrey02,
                context,
                "My Pass".tr,
                isBack: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.SEASON_PASS);
                        // Get.find<SeasonPassController>().reload();
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            color: AppColors.yellow04,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Add".tr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: AppThemData.bold,
                              color: AppColors.darkGrey08,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom sliding segmented control
                        _buildCustomSliding(controller),
                        // Content based on selected segment
                        _buildContent(context, controller.mySeasonPassList,
                            controller.pendingPassList),
                      ],
                    ),
            ),
          );
        });
  }

  Widget _buildCustomSliding(MySeasonPassController controller) {
    return Center(
      child: SlidingSwitch(
        value: controller.selectedSegment.value,
        width: 350,
        onChanged: (bool value) {
          controller.changeSegment(value);
        },
        height: 40,
        animationDuration: const Duration(milliseconds: 400),
        onTap: () {},
        onDoubleTap: () {},
        onSwipe: () {},
        textOff: "Active Pass".tr,
        textOn: "Pending Pass".tr,
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
    List<MyPurchasePassModel> purchasePassList,
    List<PendingPassModel> pendingPassList,
  ) {
    // GlobalKey for the RefreshIndicator
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedSegment.value;

        return RefreshIndicator(
          color: Colors.black,
          key: refreshIndicatorKey,
          onRefresh: () async {
            if (isSelected) {
              // Trigger refresh for pending pass list
              await controller.getPendingPass();
            } else {
              // Trigger refresh for purchase pass list
              await controller.getMySeasonPass();
            }
          },
          child: isSelected
              ? _buildPrivatePassSection(context, pendingPassList)
              : _buildPassSection(context, purchasePassList),
        );
      }),
    );
  }

  Widget _buildPassSection(
      BuildContext context, List<MyPurchasePassModel> mySeasonPassList) {
    return RefreshIndicator(
      color: AppColors.darkGrey10,
      onRefresh: () async {
        await controller
            .getMySeasonPass(); // Call the method to refresh the pending pass list
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.mySeasonPassList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          DateTime endDate =
              controller.mySeasonPassList[index].endDate!.toDate();
          int daysUntilExpired = endDate.difference(DateTime.now()).inDays + 1;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.darkGrey02.withOpacity(0.5))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        controller
                            .mySeasonPassList[index].seasonPassModel!.passName
                            .toString()
                            .tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: AppThemData.bold,
                          color: AppColors.darkGrey08,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'RM ${controller.mySeasonPassList[index].seasonPassModel!.price.toString()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: AppThemData.medium,
                              color: AppColors.yellow04,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '/ ${controller.mySeasonPassList[index].seasonPassModel?.validity.toString().tr}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: AppThemData.medium,
                                color: AppColors.darkGrey08,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: AppColors.darkGrey02,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  itemWidget(
                      subText: controller.mySeasonPassList[index].id!
                          .substring(0, 8)
                          .toUpperCase(),
                      title: 'Serial Number:'.tr,
                      svgImage: 'assets/icons/ic_hash.svg'),
                  itemWidget(
                      subText: Constant.timestampToDate(
                          controller.mySeasonPassList[index].endDate!),
                      title: '${'Validity'.tr}:',
                      svgImage: 'assets/icons/ic_timer.svg'),
                  itemExpiredWidget(
                      daysUntilExpired: daysUntilExpired,
                      title: 'Expired In (Day):'.tr,
                      svgImage: 'assets/icons/ic_timer.svg'),
                  itemWidget(
                      subText:
                          '${controller.mySeasonPassList[index].vehicleNo}',
                      title: 'Plate Number:'.tr,
                      svgImage: 'assets/icons/ic_carsimple.svg'),
                  itemStatusWidget(
                      endDate: endDate,
                      daysUntilExpired: daysUntilExpired,
                      title: '${'Status'.tr}:',
                      image: 'assets/images/clipboard.png'),

                  // itemPayWidget(
                  //     subText:
                  //         '${controller.mySeasonPassList[index].paymentType}',
                  //     title: 'Payment Type:'.tr,
                  //     svgImage: 'assets/icons/ic_payment.svg'),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrivatePassSection(
      BuildContext context, List<PendingPassModel> pendingPassList) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller
            .getPendingPass(); // Call the method to refresh the pending pass list
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.pendingPassList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          DateTime endDate =
              controller.pendingPassList[index].endDate!.toDate();
          int daysUntilExpired = endDate.difference(DateTime.now()).inDays;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.darkGrey02.withOpacity(0.5))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        controller
                            .pendingPassList[index].privatePassModel!.passName
                            .toString()
                            .tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: AppThemData.bold,
                          color: AppColors.darkGrey08,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'RM ${controller.pendingPassList[index].privatePassModel!.price.toString()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppThemData.medium,
                                  color: AppColors.yellow04,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '/ ${controller.pendingPassList[index].privatePassModel?.validity.toString().tr}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: AppThemData.medium,
                                    color: AppColors.darkGrey08,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: AppColors.darkGrey02,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  itemWidget(
                      subText: controller.pendingPassList[index].id!
                          .substring(0, 8)
                          .toUpperCase(),
                      title: 'Serial Number:'.tr,
                      svgImage: 'assets/icons/ic_hash.svg'),
                  itemWidget(
                      subText: controller.pendingPassList[index].lotNo!
                          .toUpperCase(),
                      title: '${'Lot No.'.tr}:',
                      svgImage: "assets/icons/ic_note.svg"),
                  itemWidget(
                    subText: Constant.timestampToDate(
                        controller.pendingPassList[index].createAt!),
                    title: 'Create At:'.tr,
                    svgImage: 'assets/icons/ic_timer.svg',
                  ),
                  itemPendingWidget(
                      subText:
                          controller.pendingPassList[index].status.toString(),
                      title: '${'Status'.tr}:',
                      image: 'assets/images/clipboard.png'),
                  // Conditionally render the Pay button if status is approved
                  if (controller.pendingPassList[index].status!.toLowerCase() ==
                      'approved')
                    InkWell(
                      onTap: () {
                        final pendingPassModel =
                            controller.pendingPassList[index];
                        final myPurchasePassModel =
                            controller.purchasePassModel.value;

                        Get.toNamed(Routes.PAY_PENDING_PASS, arguments: {
                          "passId": pendingPassModel.id,
                          "passName":
                              pendingPassModel.privatePassModel!.passName,
                          "passPrice": pendingPassModel.privatePassModel!.price
                              .toString(),
                          "privatePassId": pendingPassModel
                              .privatePassModel!.passId
                              .toString(),
                          "passValidity":
                              pendingPassModel.privatePassModel!.validity,
                          'customerId': pendingPassModel.customerId,
                          'name': pendingPassModel.fullName,
                          'username': pendingPassModel.email,
                          'address': pendingPassModel.address,
                          'identificationNumber':
                              pendingPassModel.identificationNo,
                          'mobileNumber': pendingPassModel.mobileNumber,
                          'vehicleNo': pendingPassModel.vehicleNo,
                          'lotNo': pendingPassModel.lotNo,
                          'image': pendingPassModel.image,
                          'companyName': pendingPassModel.companyName,
                          'companyRegistrationNo':
                              pendingPassModel.companyRegistrationNo,
                          'countryCode': pendingPassModel.countryCode,
                          'startDate':
                              pendingPassModel.startDate?.toDate().toString(),
                          'endDate':
                              pendingPassModel.endDate!.toDate().toString(),
                          'status': pendingPassModel.status,
                          'zoneId': pendingPassModel.zoneId,
                          'zoneName': pendingPassModel.zoneName,
                          'roadId': pendingPassModel.roadId,
                          'roadName': pendingPassModel.roadName,
                          "purchasePassModel": myPurchasePassModel
                        });
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.yellow04,
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Center(
                          child: Text(
                            "Pay".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: AppThemData.regular,
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget itemWidget({
    required String subText,
    required String svgImage,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgImage,
            color: AppColors.darkGrey05,
            height: 20,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(title.tr,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppThemData.regular,
                color: AppColors.darkGrey09,
              )),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Text(
              subText.tr,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }

  static Widget itemPendingWidget({
    required String subText,
    required String image,
    required String title,
  }) {
    // Define the color based on the title value
    Color textColor;
    switch (subText.toLowerCase()) {
      case 'pending':
        textColor = Colors.blueAccent;
        break;
      case 'rejected':
        textColor = Colors.red;
        break;
      case 'approved':
        textColor = Colors.green;
        break;
      default:
        textColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            color: AppColors.darkGrey05,
            height: 20,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            title.tr,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Text(
              subText.tr,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
          ),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }

  static Widget itemPayWidget({
    required String subText,
    required String svgImage,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgImage,
            color: AppColors.darkGrey05,
            height: 20,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            title.tr,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppThemData.regular,
              color: AppColors.darkGrey09,
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              subText.tr,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }

  Widget itemExpiredWidget(
      {required int daysUntilExpired,
      required String title,
      required String svgImage}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(200),
            ),
            child: Center(
              child: SvgPicture.asset(
                svgImage,
                height: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title.tr,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppThemData.medium,
              color: AppColors.darkGrey08,
            ),
          ),
          const Spacer(),
          Text(
            daysUntilExpired <= 0 ? '0' : '$daysUntilExpired',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppThemData.medium,
              color: AppColors.darkGrey08,
            ),
          ),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }

  Widget itemStatusWidget({
    required DateTime endDate,
    required int daysUntilExpired,
    required String image,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(200),
            ),
            child: Center(
              child: Image.asset(
                image,
                height: 18,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title.tr,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppThemData.medium,
              color: AppColors.darkGrey08,
            ),
          ),
          const Spacer(),
          Text(
            daysUntilExpired > 0 ? 'Active' : 'Expired',
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppThemData.medium,
              color: daysUntilExpired > 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }
}
