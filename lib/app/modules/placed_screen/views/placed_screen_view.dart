import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/booking_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/placed_screen_controller.dart';

class PlacedScreenView extends StatelessWidget {
  const PlacedScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlacedScreenController>(
        init: PlacedScreenController(),
        builder: (context) {
          return Container(
            color: AppColors.lightGrey02,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(CollectionName.bookParkingOrder)
                    .where("customerId", isEqualTo: FireStoreUtils.getCurrentUid())
                    .where('status', isEqualTo: Constant.placed)
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'.tr));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Constant.loader();
                  }
                  return snapshot.data!.docs.isEmpty
                      ? Center(
                          child: Constant.showEmptyView(message: "No Active Parking Found"),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            BookingModel bookingModel = BookingModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                                child: InkWell(onTap: () {
                                  Get.toNamed(Routes.BOOKING_SUMMARY_SCREEN, arguments: {"bookingModel": bookingModel});
                                },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          NetworkImageWidget(
                                            imageUrl: bookingModel.parkingDetails!.images![0].toString(),
                                            width: Responsive.width(19, context),
                                            height: Responsive.height(12, context),
                                            fit: BoxFit.fill,
                                            borderRadius: 8,
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        bookingModel.parkingDetails!.parkingName.toString(),
                                                        style: const TextStyle(
                                                            color: AppColors.darkGrey09, fontFamily: AppThemData.semiBold, fontSize: 17),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset("assets/icons/ic_place_marker.svg"),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        bookingModel.parkingDetails!.address.toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: AppColors.darkGrey07,
                                                          fontFamily: AppThemData.medium,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      height: 18,
                                                      width: 18,
                                                      bookingModel.parkingDetails!.parkingType == "2"
                                                          ? "assets/icons/ic_bike.svg"
                                                          : "assets/icons/ic_car.svg",
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${bookingModel.parkingDetails!.parkingType} Wheel",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: AppColors.darkGrey06,
                                                          fontFamily: AppThemData.medium,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.toNamed(Routes.BOOKING_SUMMARY_SCREEN, arguments: {"bookingModel": bookingModel});
                                                      },
                                                      child: const Text(
                                                        "View Details",
                                                        style: TextStyle(
                                                            fontSize: 13, fontFamily: AppThemData.semiBold, color: AppColors.yellow04),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }),
          );
        });
  }
}
