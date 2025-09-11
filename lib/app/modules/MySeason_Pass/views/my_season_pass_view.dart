// ignore_for_file: deprecated_member_use

import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
    // We are no longer wrapping the entire view in a GetX widget.
    // The Obx widgets inside will handle the reactive updates.
    Get.put(MySeasonPassController());

    return WillPopScope(
      onWillPop: () async {
        _exitApp();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGrey02,
        // The app bar is now a more modern design
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "My Pass".tr,
            style: const TextStyle(
              color: AppColors.darkGrey07,
              fontFamily: AppThemData.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            // Changed the "Add" button to a more standard ElevatedButton
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(Routes.SEASON_PASS);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow04,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.add, color: AppColors.darkGrey08),
                label: Text(
                  "Add".tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppThemData.bold,
                    color: AppColors.darkGrey08,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          // This is the correct place to handle different states reactively
          if (controller.isLoading.value) {
            return Center(child: Constant.loader());
          }

          if (!controller.isUserLoggedIn.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Please proceed to login at the profile page".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppThemData.bold,
                    color: AppColors.darkGrey08,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildCustomSliding(controller),
              const SizedBox(height: 16),
              _buildPassContent(controller),
            ],
          );
        }),
      ),
    );
  }

  // A single method to build the main content
  Widget _buildPassContent(MySeasonPassController controller) {
    return Expanded(
      child: RefreshIndicator(
        color: AppColors.yellow04,
        onRefresh: () async {
          if (controller.selectedSegment.value) {
            await controller.getPendingPass();
          } else {
            await controller.getMySeasonPass();
          }
        },
        child: Obx(() {
          final isSelected = controller.selectedSegment.value;
          final purchaseList = controller.mySeasonPassList;
          final pendingList = controller.pendingPassList;

          if (isSelected) {
            return _buildPendingPassSection(pendingList, controller);
          } else {
            return _buildActivePassSection(purchaseList);
          }
        }),
      ),
    );
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
        colorOn: AppColors.darkGrey08,
        colorOff: AppColors.darkGrey08,
        background: AppColors.white,
        buttonColor: AppColors.yellow04,
        inactiveColor: AppColors.darkGrey05,
      ),
    );
  }

  Widget _buildActivePassSection(List<MyPurchasePassModel> mySeasonPassList) {
    if (mySeasonPassList.isEmpty) {
      return Constant.emptyView(
          'No OnGoing Parking Found'.tr); // Use a common empty view
    }
    return ListView.builder(
      itemCount: mySeasonPassList.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final pass = mySeasonPassList[index];
        final endDate = pass.endDate!.toDate();
        final daysUntilExpired = endDate.difference(DateTime.now()).inDays + 1;

        return _buildPassCard(
          title: pass.seasonPassModel!.passName.toString(),
          price: pass.seasonPassModel!.price.toString(),
          validity: pass.seasonPassModel!.validity.toString(),
          infoItems: [
            _buildInfoRow(
              title: 'Serial Number:'.tr,
              iconAsset: 'assets/icons/ic_hash.svg',
              child: Text(
                pass.id!.substring(0, 8).toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey08,
                  fontFamily: AppThemData.medium,
                ),
              ),
            ),
            _buildInfoRow(
              title: 'Validity:'.tr,
              iconAsset: 'assets/icons/ic_timer.svg',
              child: Text(
                Constant.timestampToDate(pass.endDate!),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey08,
                  fontFamily: AppThemData.medium,
                ),
              ),
            ),
            _buildInfoRow(
              title: 'Expired In (Day):'.tr,
              iconAsset: 'assets/icons/ic_timer.svg',
              child: Text(
                daysUntilExpired <= 0 ? '0' : '$daysUntilExpired',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey08,
                  fontFamily: AppThemData.medium,
                ),
              ),
            ),
            _buildInfoRow(
              title: 'Plate Number:'.tr,
              iconAsset: 'assets/icons/ic_carsimple.svg',
              child: Text(
                pass.vehicleNo.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey08,
                  fontFamily: AppThemData.medium,
                ),
              ),
            ),
            _buildInfoRow(
              title: 'Status:'.tr,
              iconAsset: 'assets/images/clipboard.png',
              child: Text(
                daysUntilExpired > 0 ? 'Active'.tr : 'Expired'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppThemData.bold,
                  color: daysUntilExpired > 0
                      ? AppColors.green04
                      : AppColors.red04,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingPassSection(List<PendingPassModel> pendingPassList,
      MySeasonPassController controller) {
    if (pendingPassList.isEmpty) {
      return Constant.emptyView(
          'No Active Parking Found'.tr); // Use a common empty view
    }
    return ListView.builder(
      itemCount: pendingPassList.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final pass = pendingPassList[index];

        Color statusColor;
        switch (pass.status?.toLowerCase()) {
          case 'pending':
            statusColor = AppColors.blue04;
            break;
          case 'rejected':
            statusColor = AppColors.red04;
            break;
          case 'approved':
            statusColor = AppColors.green04;
            break;
          default:
            statusColor = AppColors.darkGrey08;
        }

        return _buildPassCard(
          title: pass.privatePassModel!.passName.toString(),
          price: pass.privatePassModel!.price.toString(),
          validity: pass.privatePassModel!.validity.toString(),
          infoItems: [
            _buildInfoRow(
              title: 'Serial Number:'.tr,
              iconAsset: 'assets/icons/ic_hash.svg',
              child: Text(
                pass.id!.substring(0, 8).toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey08,
                  fontFamily: AppThemData.medium,
                ),
              ),
            ),
            _buildInfoRow(
              title: 'Lot No.:'.tr,
              iconAsset: "assets/icons/ic_note.svg",
              child: Text(
                pass.lotNo!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey08,
                  fontFamily: AppThemData.medium,
                ),
              ),
            ),
            _buildInfoRow(
              title: 'Create At:'.tr,
              iconAsset: 'assets/icons/ic_timer.svg',
              child: Text(
                Constant.timestampToDate(pass.createAt!),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey08,
                  fontFamily: AppThemData.medium,
                ),
              ),
            ),
            _buildInfoRow(
              title: 'Status:'.tr,
              iconAsset: 'assets/images/clipboard.png',
              child: Text(
                pass.status.toString().tr,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppThemData.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
          showPayButton: pass.status?.toLowerCase() == 'approved',
          onPayButtonTap: () {
            controller.handlePayNow(pass);
          },
        );
      },
    );
  }

  Widget _buildPassCard({
    required String title,
    required String price,
    required String validity,
    required List<Widget> infoItems,
    bool showPayButton = false,
    VoidCallback? onPayButtonTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: AppColors.yellow04,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/ic_pass.svg',
                        height: 24,
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
                          title.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: AppThemData.bold,
                            color: AppColors.darkGrey08,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'RM $price',
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: AppThemData.medium,
                                color: AppColors.yellow04,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '/ $validity'.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
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
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: AppColors.lightGrey05,
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: infoItems,
              ),
            ),
            if (showPayButton && onPayButtonTap != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: _buildPayButton(onPayButtonTap),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow04,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: Text(
          "Pay Now".tr,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: AppThemData.bold,
            color: AppColors.darkGrey08,
          ),
        ),
      ),
    );
  }

  // Consolidated widget for all info rows
  Widget _buildInfoRow({
    required String title,
    required String iconAsset,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Handle both SVG and other image types
          if (iconAsset.endsWith('.svg'))
            SvgPicture.asset(
              iconAsset,
              colorFilter:
                  const ColorFilter.mode(AppColors.darkGrey05, BlendMode.srcIn),
              height: 20,
              width: 20,
            )
          else
            Image.asset(
              iconAsset,
              color: AppColors.darkGrey05,
              height: 20,
              width: 20,
            ),
          const SizedBox(width: 12),
          Text(
            title.tr,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppThemData.regular,
              color: AppColors.darkGrey09,
            ),
          ),
          const Spacer(),
          // The child widget holds the dynamic content
          child,
        ],
      ),
    );
  }

  void _exitApp() {
    SystemNavigator.pop();
  }
}
