import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../controllers/rate_us_screen_controller.dart';

class RateUsScreenView extends StatelessWidget {
  const RateUsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<RateUsScreenController>(
        init: RateUsScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(context, "Rate us".tr, backgroundColor: Colors.white),
            body: (controller.isLoading.value)
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          "Rate Your Experience".tr,
                          style: TextStyle(fontFamily: AppThemData.bold, color: AppColors.darkGrey09, fontSize: 18),
                        ),
                         Text(
                          "Help us improve by sharing your feedback and rating your experience. Your opinion matters!".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: AppThemData.regular, color: AppColors.lightGrey10, fontSize: 15),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 20),
                            child: RatingBar.builder(
                              glow: true,
                              initialRating: controller.rating.value,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 32,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: AppColors.yellow04,
                              ),
                              onRatingUpdate: (rating) {
                                controller.rating(rating);
                              },
                            ),
                          ),
                        ),
                        ButtonThem.buildButton(
                          btnWidthRatio: .40,
                          btnHeight: 48,
                          context,
                          title: "Save your review".tr,
                          txtColor: AppColors.lightGrey01,
                          bgColor: AppColors.darkGrey10,
                          onPress: () async {
                            ShowToastDialog.showLoader("Please wait".tr);

                            await FireStoreUtils.getParkingDetail(controller.bookingModel.value.parkingId.toString()).then((value) async {
                              if (value != null) {
                                ParkingModel parkingModel = value;

                                if (controller.reviewModel.value.id != null) {
                                  parkingModel.reviewSum = (double.parse(parkingModel.reviewSum.toString()) -
                                          double.parse(controller.reviewModel.value.rating.toString()))
                                      .toString();
                                  parkingModel.reviewCount = (double.parse(parkingModel.reviewCount.toString()) - 1).toString();
                                }
                                parkingModel.reviewSum =
                                    (double.parse(parkingModel.reviewSum.toString()) + double.parse(controller.rating.value.toString()))
                                        .toString();
                                parkingModel.reviewCount = (double.parse(parkingModel.reviewCount.toString()) + 1).toString();
                                await FireStoreUtils.saveParkingDetails(parkingModel);
                              }
                            });

                            controller.reviewModel.value.id = controller.bookingModel.value.id;
                            controller.reviewModel.value.rating = controller.rating.value.toString();
                            controller.reviewModel.value.customerId = FireStoreUtils.getCurrentUid();
                            controller.reviewModel.value.parkingId = controller.bookingModel.value.parkingId;
                            controller.reviewModel.value.date = Timestamp.now();

                            await FireStoreUtils.setReview(controller.reviewModel.value).then((value) {
                              if (value != null && value == true) {
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.showToast("Review submit successfully".tr);
                                Get.back();
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
