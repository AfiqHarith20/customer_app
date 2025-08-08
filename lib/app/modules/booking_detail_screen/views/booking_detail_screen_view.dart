import 'package:customer_app/app/modules/booking_summary_screen/views/booking_summary_screen_view.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/booking_detail_screen_controller.dart';

class BookingDetailScreenView extends StatelessWidget {
  const BookingDetailScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<BookingDetailScreenController>(
        init: BookingDetailScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface().customAppBar(context, "Summary".tr, backgroundColor: AppColors.white),
            body: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                              style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey09, fontSize: 16),
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
                                          style: const TextStyle(fontFamily: AppThemData.regular, color: AppColors.darkGrey07, fontSize: 13),
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
                            'Parking Information'.tr,
                            style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ParkingInformationWidget(name: "Parking ID", value: "${controller.bookingModel.value.parkingId}"),
                                  ParkingInformationWidget(name: "Vehicle Number", value: "${controller.bookingModel.value.numberPlate}"),
                                  ParkingInformationWidget(
                                      name: "Start".tr,
                                      value:
                                          "${Constant.timestampToDate(controller.bookingModel.value.bookingStartTime!)}-${Constant.timestampToTime(controller.bookingModel.value.bookingStartTime!)}"),
                                  ParkingInformationWidget(
                                      name: "End".tr,
                                      value:
                                          "${Constant.timestampToDate(controller.bookingModel.value.bookingEndTime!)}-${Constant.timestampToTime(controller.bookingModel.value.bookingEndTime!)}"),
                                  ParkingInformationWidget(name: "Durations".tr, value: "${controller.bookingModel.value.duration} Hours"),
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
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                      controller.bookingModel.value.myPurchasePassModel!.seasonPassModel!.passName.toString(),
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
                                          'RM ${controller.bookingModel.value.myPurchasePassModel!.seasonPassModel!.price.toString()}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: AppThemData.medium,
                                            color: AppColors.yellow04,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '/ ${controller.bookingModel.value.myPurchasePassModel!.seasonPassModel!.validity.toString()}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: AppThemData.medium,
                                              color: AppColors.darkGrey08,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(height: 1, color: AppColors.lightGrey09),
                                itemWidget(subText: '#125673', title: 'Serial no:', svgImage: 'assets/icons/ic_hash.svg'),
                                itemWidget(
                                    subText: Constant.timestampToDate(controller.bookingModel.value.myPurchasePassModel!.endDate!),
                                    title: 'Validity:',
                                    svgImage: 'assets/icons/ic_timer.svg'),
                                itemWidget(
                                    subText: '${controller.bookingModel.value.myPurchasePassModel!.vehicleNo}',
                                    title: 'Car no:',
                                    svgImage: 'assets/icons/ic_carsimple.svg'),
                              ],
                            ),
                          )

                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Text(
                          //         "CouponCode".tr,
                          //         style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06),
                          //       ),
                          //     ),
                          //     InkWell(
                          //       onTap: () {
                          //         Get.toNamed(Routes.APPLY_COUPON_SCREEN);
                          //       },
                          //       child: const SvgImageWidget(
                          //         imagePath: "assets/icons/ic_right.svg",
                          //         height: 22,
                          //         width: 22,
                          //         color: AppColors.lightGrey10,
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Expanded(
                          //       child: TextFieldWidgetPrefix(
                          //         hintText: "Apply Coupon Code".tr,
                          //         controller: controller.couponCodeController.value,
                          //         onPress: () {},
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 10,
                          //     ),
                          //     ButtonThem.buildButton(
                          //       btnHeight: 56,
                          //       btnWidthRatio: .25,
                          //       context,
                          //       title: "Apply".tr,
                          //       txtColor: AppColors.lightGrey01,
                          //       bgColor: AppColors.darkGrey10,
                          //       onPress: () async {
                          //         await controller.getCoupon();
                          //       },
                          //     )
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 24,
                          // ),
                          // Text(
                          //   'Parking Cost'.tr,
                          //   style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 18),
                          // ),
                          // const SizedBox(
                          //   height: 12,
                          // ),
                          // Container(
                          //   decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(16.0),
                          //     child: Column(
                          //       children: [
                          //         ParkingInformationWidget(
                          //             name: "SubTotal", value: Constant.amountShow(amount: controller.bookingModel.value.subTotal)),
                          //         ParkingInformationWidget(
                          //             name: "Coupon Applied ", value: Constant.amountShow(amount: controller.couponAmount.toString())),
                          //         controller.bookingModel.value.taxList == null
                          //             ? const SizedBox()
                          //             : ListView.builder(
                          //                 physics: const NeverScrollableScrollPhysics(),
                          //                 itemCount: controller.bookingModel.value.taxList!.length,
                          //                 shrinkWrap: true,
                          //                 itemBuilder: (context, index) {
                          //                   TaxModel taxModel = controller.bookingModel.value.taxList![index];
                          //                   return ParkingInformationWidget(
                          //                       name:
                          //                           "${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.value) : "${taxModel.value}%"})",
                          //                       value:
                          //                           "${Constant.amountShow(amount: Constant().calculateTax(amount: (double.parse(controller.bookingModel.value.subTotal.toString()) - double.parse(controller.couponAmount.value.toString())).toString(), taxModel: taxModel).toStringAsFixed(Constant.currencyModel!.decimalDigits!).toString())} ");
                          //                 },
                          //               ),
                          //         const Padding(
                          //           padding: EdgeInsets.symmetric(vertical: 8.0),
                          //           child: Divider(
                          //             color: AppColors.darkGrey01,
                          //           ),
                          //         ),
                          //         Row(
                          //           children: [
                          //             Expanded(
                          //               child: Text(
                          //                 "Total Cost".tr,
                          //                 style: const TextStyle(
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
                          // )
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: ButtonThem.buildButton(
                txtSize: 16,
                context,
                title: "complete booking".tr,
                txtColor: AppColors.lightGrey01,
                bgColor: AppColors.darkGrey10,
                onPress: () {
                  controller.completeOrder();
                  // controller.bookingModel.value.coupon = controller.selectedCouponModel.value;
                  // Get.toNamed(Routes.SELECT_PAYMENT_SCREEN, arguments: {"bookingModel": controller.bookingModel.value});
                },
              ),
            ),
          );
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
