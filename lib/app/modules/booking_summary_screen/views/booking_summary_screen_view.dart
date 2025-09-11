// ignore_for_file: must_be_immutable
import 'dart:developer';

import 'package:customer_app/app/models/owner_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/send_notification.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/booking_summary_screen_controller.dart';

class BookingSummaryScreenView extends StatelessWidget {
  const BookingSummaryScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<BookingSummaryScreenController>(
        init: BookingSummaryScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: UiInterface().customAppBar(context, "Summary".tr, backgroundColor: Colors.white),
              body: (controller.isLoading.value)
                  ? Constant.loader()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/parking.png",
                                  height: 48,
                                  width: 48,
                                  fit: BoxFit.fill,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller.bookingModel.value.parkingDetails!.parkingName.toString(),
                                                style: const TextStyle(
                                                    color: AppColors.darkGrey09, fontFamily: AppThemData.bold, fontSize: 18),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            //   child: SvgPicture.asset(
                                            //     "assets/icons/ic_message.svg",
                                            //   ),
                                            // ),
                                            InkWell(
                                              onTap: () {
                                                Constant.redirectCall(
                                                    countryCode: controller.bookingModel.value.parkingDetails!.countryCode.toString(),
                                                    phoneNumber: controller.bookingModel.value.parkingDetails!.phoneNumber.toString());
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/ic_call.svg",
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 4.0, top: 4),
                                          child: Text(
                                            controller.bookingModel.value.parkingDetails!.address!.toString(),
                                            style: const TextStyle(
                                              color: AppColors.darkGrey07,
                                              fontFamily: AppThemData.regular,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(
                                color: AppColors.darkGrey01,
                              ),
                            ),
                            Text(
                              'Parking Status'.tr,
                              style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Payment Status'.tr,
                                        style: const TextStyle(color: AppColors.darkGrey04, fontFamily: AppThemData.medium),
                                      ),
                                    ),
                                    Text(
                                      controller.bookingModel.value.status == Constant.placed
                                          ? "Placed"
                                          : controller.bookingModel.value.status == Constant.onGoing
                                              ? "On Going"
                                              : controller.bookingModel.value.status == Constant.completed
                                                  ? "Completed"
                                                  : "Canceled",
                                      style: const TextStyle(color: AppColors.green05, fontFamily: AppThemData.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Parking Information'.tr,
                              style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              decoration: const BoxDecoration(color: AppColors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    ParkingInformationWidget(
                                        name: "Parking ID", value: controller.bookingModel.value.parkingId!.substring(0, 23)),
                                    ParkingInformationWidget(name: "Vehicle Number", value: controller.bookingModel.value.numberPlate!),
                                    ParkingInformationWidget(
                                        name: "Start",
                                        value:
                                            "${Constant.timestampToDate(controller.bookingModel.value.bookingStartTime!)}-${Constant.timestampToTime(controller.bookingModel.value.bookingStartTime!)}"),
                                    ParkingInformationWidget(
                                        name: "End",
                                        value:
                                            "${Constant.timestampToDate(controller.bookingModel.value.bookingEndTime!)}-${Constant.timestampToTime(controller.bookingModel.value.bookingEndTime!)}"),
                                    ParkingInformationWidget(
                                        name: "Durations", value: "${controller.bookingModel.value.duration.toString()} Hours"),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),

                            Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ListTile(
                                      leading: Container(
                                        height: 56,
                                        width: 56,
                                        decoration: BoxDecoration(color:  AppColors.yellow04, borderRadius: BorderRadius.circular(200)),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/icons/ic_pass.svg',
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        controller.bookingModel.value.myPurchasePassModel!.seasonPassModel!.passName.toString(),
                                        style:  const TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppThemData.bold,
                                          color: AppColors.darkGrey08,
                                        ),
                                      ),
                                      subtitle:  Row(
                                        children: [
                                          Text(
                                            'RM ${controller.bookingModel.value.myPurchasePassModel!.seasonPassModel!.price.toString()}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: AppThemData.medium,
                                              color: AppColors.yellow04,
                                            ),
                                          ),
                                          Text(
                                            '/ ${controller.bookingModel.value.myPurchasePassModel!.seasonPassModel!.validity.toString()}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: AppThemData.medium,
                                              color: AppColors.darkGrey08,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1, color: AppColors.lightGrey09),
                                  itemWidget(subText: '#125673', title: 'Serial no:', svgImage: 'assets/icons/ic_hash.svg'),
                                  itemWidget(subText: Constant.timestampToDate(controller.bookingModel.value.myPurchasePassModel!.endDate!), title: 'Validity:', svgImage: 'assets/icons/ic_timer.svg'),
                                  itemWidget(subText: '${controller.bookingModel.value.myPurchasePassModel!.vehicleNo}', title: 'Car no:', svgImage: 'assets/icons/ic_carsimple.svg'),
                                ],
                              ),
                            ),
                            // Text(
                            //   'Parking Cost'.tr,
                            //   style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18),
                            // ),
                            // const SizedBox(
                            //   height: 12,
                            // ),
                            // Container(
                            //   decoration: const BoxDecoration(color: Colors.white),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(16.0),
                            //     child: Column(
                            //       children: [
                            //         Row(
                            //           children: [
                            //             Expanded(
                            //               child: Text(
                            //                 "SubTotal".tr,
                            //                 style: const TextStyle(color: AppColors.darkGrey04, fontFamily: AppThemData.medium),
                            //               ),
                            //             ),
                            //             Text(
                            //               Constant.amountShow(amount: controller.bookingModel.value.subTotal.toString()),
                            //               style: const TextStyle(color: AppColors.darkGrey09, fontFamily: AppThemData.medium),
                            //             ),
                            //           ],
                            //         ),
                            //         const SizedBox(
                            //           height: 8,
                            //         ),
                            //         ParkingInformationWidget(
                            //             name: "Coupon Applied",
                            //             value: Constant.amountShow(amount: controller.bookingModel.value.coupon!.amount.toString())),
                            //         ListView.builder(
                            //           physics: const NeverScrollableScrollPhysics(),
                            //           itemCount: controller.bookingModel.value.taxList!.length,
                            //           shrinkWrap: true,
                            //           itemBuilder: (context, index) {
                            //             TaxModel taxModel = controller.bookingModel.value.taxList![index];
                            //             return ParkingInformationWidget(
                            //                 name:
                            //                     "${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.value) : "${taxModel.value}%"})",
                            //                 value:
                            //                     "${Constant.amountShow(amount: Constant().calculateTax(amount: (double.parse(controller.bookingModel.value.subTotal.toString()) - double.parse(controller.couponAmount.toString())).toString(), taxModel: taxModel).toStringAsFixed(Constant.currencyModel!.decimalDigits!).toString())} ");
                            //           },
                            //         ),
                            //         const Padding(
                            //           padding: EdgeInsets.symmetric(vertical: 4.0),
                            //           child: Divider(
                            //             color: AppColors.darkGrey01,
                            //           ),
                            //         ),
                            //         Row(
                            //           children: [
                            //             Expanded(
                            //               child: Text(
                            //                 "Total Cost".tr,
                            //                 style: TextStyle(
                            //                   fontFamily: AppThemData.medium,
                            //                   color: AppColors.darkGrey06,
                            //                 ),
                            //               ),
                            //             ),
                            //             Text(
                            //               Constant.amountShow(amount: controller.calculateAmount().toString()),
                            //               style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 24,
                            ),
                            if (controller.reviewModel.value.id != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Review'.tr,
                                    style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.RATE_US_SCREEN, arguments: {"bookingModel": controller.bookingModel.value})
                                          ?.then((value) {
                                        controller.getData();
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        NetworkImageWidget(
                                          borderRadius: 40,
                                          imageUrl: controller.customerModel.value.profilePic.toString(),
                                          height: 44,
                                          width: 44,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.customerModel.value.fullName.toString(),
                                              style: const TextStyle(
                                                  fontSize: 15, fontFamily: AppThemData.medium, color: AppColors.darkGrey07),
                                            ),
                                            RatingBar.builder(
                                              glow: true,
                                              initialRating: controller.rating.value,
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 30,
                                              itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: AppColors.yellow04,
                                              ),
                                              onRatingUpdate: (rating) {},
                                              ignoreGestures: true,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            const SizedBox(
                              height: 24,
                            )
                          ],
                        ),
                      ),
                    ),
              bottomNavigationBar: controller.isLoading.value
                  ? const SizedBox()
                  : (controller.bookingModel.value.status == Constant.completed)
                      ? controller.reviewModel.value.id == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 70),
                              child: ButtonThem.buildButton(
                                fontWeight: FontWeight.w700,
                                btnHeight: 56,
                                txtSize: 16,
                                btnWidthRatio: .60,
                                context,
                                title: "Add Review",
                                txtColor: AppColors.lightGrey01,
                                bgColor: AppColors.darkGrey10,
                                onPress: () {
                                  Get.toNamed(Routes.RATE_US_SCREEN, arguments: {"bookingModel": controller.bookingModel.value})
                                      ?.then((value) {
                                    controller.getData();
                                  });
                                },
                              ),
                            )
                          : const SizedBox()
                      : (controller.bookingModel.value.status == Constant.placed)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 80),
                              child: ButtonThem.buildButton(
                                fontWeight: FontWeight.w700,
                                btnHeight: 56,
                                txtSize: 16,
                                btnWidthRatio: .60,
                                context,
                                title: "Cancel",
                                txtColor: AppColors.lightGrey01,
                                bgColor: AppColors.darkGrey10,
                                onPress: () async {
                                  var startTime =
                                      DateTime.fromMillisecondsSinceEpoch(controller.bookingModel.value.bookingStartTime!.seconds * 1000);
                                  var diff = startTime.difference(DateTime.now());

                                  log(startTime.toString());

                                  if (diff.inHours < 1) {
                                    ShowToastDialog.showToast("You Can Not Cancel Before 1 Hour Of Your StartTime Booking");
                                    return;
                                  }

                                  ShowToastDialog.showLoader("Please wait".tr);
                                  controller.bookingModel.value.status = Constant.canceled;
                                  OwnerModel? receiverUserModel = await FireStoreUtils.getOwnerProfile(
                                      controller.bookingModel.value.parkingDetails!.ownerId.toString());

                                  Map<String, dynamic> playLoad = <String, dynamic>{
                                    "type": "order",
                                    "orderId": controller.bookingModel.value.id
                                  };

                                  await SendNotification.sendOneNotification(
                                      token: receiverUserModel!.fcmToken.toString(),
                                      title: 'Booking Canceled'.tr,
                                      body:
                                          '${controller.bookingModel.value.parkingDetails!.parkingName.toString()} Booking canceled on ${Constant.timestampToDate(controller.bookingModel.value.bookingDate!)}.'
                                              .tr,
                                      payload: playLoad);

                                  await controller.canceledOrderWallet();

                                  await FireStoreUtils.setOrder(controller.bookingModel.value).then((value) {
                                    ShowToastDialog.closeLoader();
                                    DashboardScreenController dashboardController = Get.put(DashboardScreenController());
                                    Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                                    dashboardController.selectedIndex.value = 1;
                                  });
                                },
                              ),
                            )
                          : null);
        });
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
                color: AppColors.lightGrey09,
              )),
          const Spacer(),
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

class ParkingInformationWidget extends StatelessWidget {
  ParkingInformationWidget({super.key, required this.name, required this.value});

  String name;
  String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name.tr,
              style: const TextStyle(
                fontFamily: AppThemData.medium,
                color: AppColors.darkGrey04,
              ),
            ),
          ),
          Text(
            (value.length > 35) ? value.substring(0, 30) : value,
            style: const TextStyle(
              fontFamily: AppThemData.medium,
              color: AppColors.darkGrey09,
            ),
          ),
        ],
      ),
    );
  }
}
