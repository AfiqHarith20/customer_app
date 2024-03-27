// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:customer_app/app/models/parking_facilities_model.dart';
import 'package:customer_app/app/modules/parking_detail_screen/controllers/parking_detail_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParkingDetailScreenView extends StatelessWidget {
  const ParkingDetailScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ParkingDetailScreenController>(
        dispose: (state) {},
        init: ParkingDetailScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(backgroundColor: AppColors.white, context, "Parking Detail".tr, actions: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      if (controller.parkingModel.value.likedUser!.contains(FireStoreUtils.getCurrentUid())) {
                        controller.parkingModel.value.likedUser!.remove(FireStoreUtils.getCurrentUid());
                        await FireStoreUtils.saveParkingDetails(controller.parkingModel.value).then((value) {
                          controller.parkingModel.refresh();
                        });
                      } else {
                        controller.parkingModel.value.likedUser!.add(FireStoreUtils.getCurrentUid());
                        await FireStoreUtils.saveParkingDetails(controller.parkingModel.value).then((value) {
                          controller.parkingModel.refresh();
                        });
                      }
                    },
                    child: (controller.parkingModel.value.likedUser!.contains(FireStoreUtils.getCurrentUid()))
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : SvgPicture.asset(
                            "assets/icons/ic_favorite.svg",
                            color: AppColors.darkGrey06,
                          )),
              ),
            ]),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 20),
                          child: SizedBox(
                              height: Responsive.height(22, context),
                              child: PageView.builder(
                                controller: PageController(viewportFraction: .89),
                                itemCount: controller.parkingModel.value.images!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: NetworkImageWidget(
                                        height: 200,
                                        borderRadius: 12,
                                        imageUrl: controller.parkingModel.value.images![index],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${controller.parkingModel.value.parkingName}",
                                          style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18),
                                        ),
                                        Text(
                                          "${controller.parkingModel.value.address}",
                                          style: const TextStyle(
                                            color: AppColors.darkGrey07,
                                            fontFamily: AppThemData.regular,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Constant.redirectMap(controller.parkingModel.value.location!.latitude!,
                                          controller.parkingModel.value.location!.longitude!);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.yellow04,
                                      child: SvgPicture.asset("assets/icons/ic_map_redirect.svg"),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    (controller.parkingModel.value.parkingType == "4")
                                        ? "assets/icons/ic_car.svg"
                                        : "assets/icons/ic_bike.svg",
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${controller.parkingModel.value.parkingType} Wheel'.tr,
                                    style: const TextStyle(
                                      color: AppColors.darkGrey06,
                                      fontFamily: AppThemData.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 11,
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/ic_place_marker.svg",
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${controller.calculateTotalDistance().toStringAsFixed(1)} Km',
                                      style: const TextStyle(
                                        color: AppColors.darkGrey06,
                                        fontFamily: AppThemData.bold,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/ic_star.svg",
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    Constant.calculateReview(
                                        reviewCount: controller.parkingModel.value.reviewCount,
                                        reviewSum: controller.parkingModel.value.reviewSum),
                                    style: const TextStyle(
                                      color: AppColors.darkGrey06,
                                      fontFamily: AppThemData.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Parking Information".tr,
                                style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Column(
                                children: [
                                  ParkingInformationWidget(
                                    imageAsset: "assets/icons/ic_place_marker.svg",
                                    value: "${controller.parkingModel.value.parkingSpace} Slots Available",
                                  ),
                                  ParkingInformationWidget(
                                    imageAsset: "assets/icons/ic_clock.svg",
                                    value: "${controller.parkingModel.value.startTime} - ${controller.parkingModel.value.endTime}",
                                  ),
                                  ParkingInformationWidget(
                                    imageAsset: "assets/icons/ic_call.svg",
                                    value: "${controller.parkingModel.value.countryCode} ${controller.parkingModel.value.phoneNumber}",
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Facilities".tr,
                                style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              controller.parkingModel.value.facilities!.isNotEmpty
                                  ? Column(
                                      children: List.generate(controller.parkingModel.value.facilities!.length, (index) {
                                        ParkingFacilitiesModel facilities = controller.parkingModel.value.facilities![index];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Row(
                                            children: [
                                              NetworkImageWidget(
                                                imageUrl: facilities.image.toString(),
                                                width: 20,
                                                height: 20,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6.0, right: 6),
                                                child: Text(
                                                  facilities.name.toString(),
                                                  style: const TextStyle(
                                                    color: AppColors.darkGrey07,
                                                    fontFamily: AppThemData.medium,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    )
                                  : Text(
                                      "No Facilities Available".tr,
                                      style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.regular),
                                    ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: AppColors.yellow04,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price".tr,
                                  style: const TextStyle(
                                    color: AppColors.darkGrey05,
                                  ),
                                ),
                                Text(
                                  "Start \$${controller.parkingModel.value.perHrRate}/h",
                                  style: const TextStyle(
                                    color: AppColors.darkGrey09,
                                    fontFamily: AppThemData.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: ButtonThem.buildButton(
                            btnHeight: 48,
                            txtSize: 16,
                            fontWeight: FontWeight.w500,
                            context,
                            title: "Book Place".tr,
                            txtColor: AppColors.white,
                            bgColor: AppColors.darkGrey10,
                            onPress: () {
                              Get.toNamed(Routes.CHOOSE_DATE_TIME_SCREEN, arguments: {"parkingModel": controller.parkingModel.value});
                            },
                          ))
                        ],
                      )),
                )
              ],
            ),
          );
        });
  }
}

class ParkingInformationWidget extends StatelessWidget {
  ParkingInformationWidget({super.key, required this.value, required this.imageAsset});

  String value;
  String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SvgPicture.asset(
            imageAsset,
            height: 20,
            width: 20,
            color: AppColors.darkGrey04,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkGrey07,
                fontFamily: AppThemData.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
