import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../controllers/like_screen_controller.dart';

class LikeScreenView extends StatelessWidget {
  const LikeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiInterface().customAppBar(context, "Favourite Parking".tr, backgroundColor: AppColors.white),
      body: GetX<LikeScreenController>(
          init: LikeScreenController(),
          builder: (controller) {
            return (controller.isLoading.value)
                ? Constant.loader()
                : (controller.likedParkingList.isEmpty)
                    ? Constant.showEmptyView(message: "No Favourite Parking".tr)
                    : ListView.separated(
                        itemCount: controller.likedParkingList.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemBuilder: (context, index) {
                          ParkingModel parkingModel = controller.likedParkingList[index];
                          double totalDistance = Geolocator.distanceBetween(
                              Constant.currentLocation!.latitude,
                              Constant.currentLocation!.longitude,
                              parkingModel.location!.latitude!,
                              parkingModel.location!.longitude!);
                          return InkWell(
                            onTap: () {
                              Get.toNamed(Routes.PARKING_DETAIL_SCREEN, arguments: {"parkingModel": parkingModel});
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NetworkImageWidget(
                                      imageUrl: "${parkingModel.images![0]}",
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.fill,
                                      borderRadius: 8,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${parkingModel.parkingName}',
                                              style: const TextStyle(
                                                  color: AppColors.darkGrey09,
                                                  fontFamily: AppThemData.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              '${parkingModel.address}',
                                              maxLines: 1,
                                              style: const TextStyle(
                                                color: AppColors.darkGrey07,
                                                fontFamily: AppThemData.regular,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.removeLikedParking(parkingModel);
                                      },
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
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
                                      (parkingModel.parkingType == "4")
                                          ? "assets/icons/ic_car.svg"
                                          : "assets/icons/ic_bike.svg",
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '${parkingModel.parkingType} Wheel',
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
                                        '${(totalDistance / 1000).ceil()} Km',
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
                                          reviewCount: parkingModel.reviewCount, reviewSum: parkingModel.reviewSum),
                                      style: const TextStyle(
                                        color: AppColors.darkGrey06,
                                        fontFamily: AppThemData.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            child: Divider(
                              color: AppColors.darkGrey01,
                            ),
                          );
                        },
                      );
          }),
    );
  }
}
