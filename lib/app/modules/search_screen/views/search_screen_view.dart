// ignore_for_file: deprecated_member_use

import 'package:customer_app/app/models/location_lat_lng.dart';
import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:place_picker/entities/location_result.dart';

import '../controllers/search_screen_controller.dart';

class SearchScreenView extends StatelessWidget {
  const SearchScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SearchScreenController>(
        init: SearchScreenController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: TextField(
                  onTap: () async {
                    LocationResult? result = await Utils.showPlacePicker(context);
                    if (result != null) {
                      controller.addressController.value.text = result.formattedAddress.toString();
                      controller.locationLatLng.value =
                          LocationLatLng(latitude: result.latLng!.latitude, longitude: result.latLng!.longitude);
                      await controller.getNearbyParking();
                    }
                  },
                  controller: controller.addressController.value,
                  onChanged: (value) {},
                  readOnly: true,
                  style: const TextStyle(
                    fontFamily: AppThemData.medium,
                    color: AppColors.darkGrey10,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset("assets/icons/ic_search.svg"),
                    ),
                    suffixIcon: (controller.addressController.value.text.isNotEmpty)
                        ? InkWell(
                            onTap: () async {
                              controller.addressController.value.text = "";
                              controller.locationLatLng.value = LocationLatLng(
                                  latitude: Constant.currentLocation!.latitude, longitude: Constant.currentLocation!.longitude);
                              await controller.getNearbyParking();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.clear,
                                color: AppColors.darkGrey06,
                              ),
                            ))
                        : null,
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.yellow07, width: 1),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.yellow07, width: 1),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.yellow07, width: 1),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.yellow07, width: 1),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.yellow07, width: 1),
                    ),
                    hintText: "Search Location/Town name".tr,
                    hintStyle: const TextStyle(
                      fontFamily: AppThemData.medium,
                      color: AppColors.yellow09,
                    ),
                  ),
                ),
              ),
              body: (controller.isLoading.value)
                  ? (controller.parkingList.isEmpty)
                      ? Constant.showEmptyView(message: "No Parking Found")
                      : ListView.separated(
                          itemCount: controller.parkingList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            ParkingModel parkingModel = controller.parkingList[index];
                            double totalDistance = Geolocator.distanceBetween(Constant.currentLocation!.latitude,
                                Constant.currentLocation!.longitude, parkingModel.location!.latitude!, parkingModel.location!.longitude!);
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
                                                style: const TextStyle(color: AppColors.darkGrey09, fontFamily: AppThemData.bold, fontSize: 18),
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
                                      parkingModel.likedUser!.contains(FireStoreUtils.getCurrentUid())
                                          ? InkWell(
                                              onTap: () {
                                                //controller.removeLikedParking(parkingModel);
                                              },
                                              child: const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                // controller.addLikedParking(parkingModel);
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/ic_favorite.svg",
                                                color: AppColors.darkGrey03,
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
                                        (parkingModel.parkingType == "4") ? "assets/icons/ic_car.svg" : "assets/icons/ic_bike.svg",
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
                                      const Text(
                                        '3.5',
                                        style: TextStyle(
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
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                              child: Divider(
                                color: AppColors.darkGrey01,
                              ),
                            );
                          },
                        )
                  : Constant.showEmptyView(message: "Search Parking"));
        });
  }
}
