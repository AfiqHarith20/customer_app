import 'package:customer_app/app/models/coupon_model.dart';
import 'package:customer_app/app/modules/booking_detail_screen/controllers/booking_detail_screen_controller.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/apply_coupon_screen_controller.dart';

class ApplyCouponScreenView extends GetView<ApplyCouponScreenController> {
  const ApplyCouponScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UiInterface().customAppBar(context, "Apply Coupon".tr, backgroundColor: AppColors.white),
        body: Obx(() => (controller.isLoading.value)
            ? Constant.loader()
            : (controller.couponList.isEmpty)
                ? Constant.showEmptyView(message: "No Coupon Available")
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: controller.couponList.length,
                    itemBuilder: (context, index) {
                      CouponModel couponModel = controller.couponList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.orange04),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Center(
                                        child: Text(
                                      couponModel.code.toString(),
                                      style: const TextStyle(color: AppColors.white, fontFamily: AppThemData.semiBold),
                                    )),
                                  )),
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                      color: AppColors.white),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          couponModel.title.toString(),
                                          style: const TextStyle(color: AppColors.darkGrey07, fontFamily: AppThemData.medium, fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "Expires on ${Constant.timestampToDate(couponModel.expireAt!)}",
                                          style: const TextStyle(color: AppColors.darkGrey04, fontFamily: AppThemData.medium, fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "Minimum Amount ${Constant.amountShow(amount: couponModel.minAmount)}",
                                          style: const TextStyle(color: AppColors.darkGrey04, fontFamily: AppThemData.medium, fontSize: 12),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 16.0),
                                          child: Divider(
                                            color: AppColors.darkGrey01,
                                          ),
                                        ),
                                        Center(
                                          child: TextButton(
                                              isSemanticButton: true,
                                              onPressed: () {
                                                BookingDetailScreenController controller = Get.put(BookingDetailScreenController());

                                                if (double.parse(controller.bookingModel.value.subTotal.toString()) <
                                                    double.parse(couponModel.minAmount.toString())) {
                                                  ShowToastDialog.showToast(
                                                      "Minimum amount ${Constant.amountShow(amount: couponModel.minAmount)} required");
                                                  return;
                                                }
                                                controller.selectedCouponModel.value = couponModel;
                                                controller.couponCodeController.value.text =
                                                    controller.selectedCouponModel.value.code.toString();
                                                if (couponModel.isFix == true) {
                                                  controller.couponAmount.value = double.parse(couponModel.amount.toString());
                                                } else {
                                                  controller.couponAmount.value =
                                                      double.parse(controller.bookingModel.value.subTotal.toString()) *
                                                          double.parse(couponModel.amount.toString()) /
                                                          100;
                                                }
                                                Get.back();
                                              },
                                              child: Text(
                                                "Tap To Apply".tr,
                                                style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.orange04),
                                              )),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  )));
  }
}
