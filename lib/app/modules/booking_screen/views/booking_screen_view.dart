import 'package:customer_app/app/modules/cancel_screen/views/cancel_screen_view.dart';
import 'package:customer_app/app/modules/completed_screen/views/completed_screen_view.dart';
import 'package:customer_app/app/modules/on_going_screen/views/on_going_screen_view.dart';
import 'package:customer_app/app/modules/placed_screen/views/placed_screen_view.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/booking_screen_controller.dart';

class BookingScreenView extends StatelessWidget {
  const BookingScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingScreenController>(
        init: BookingScreenController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              controller.profileScreenController.isBookingScreen.value = false;
              return true;
            },
            child: Scaffold(
                backgroundColor: AppColors.lightGrey02,
                appBar: (controller.profileScreenController.isBookingScreen.value)
                    ? UiInterface().customAppBar(onBackTap: () {
                        controller.profileScreenController.isBookingScreen.value = false;
                        Get.back();
                      }, isBack: true, context, 'My Booking List'.tr, backgroundColor: AppColors.white)
                    : UiInterface().customAppBar(isBack: false, context, 'Your Parking Reservations'.tr, backgroundColor: AppColors.white),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Keep track of your upcoming and past parking reservations with ease. Your parking history, all in one place.'.tr,
                          style: const TextStyle(
                            fontFamily: AppThemData.regular,
                            height: 1.2,
                            color: AppColors.lightGrey10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: AppColors.lightGrey06, borderRadius: BorderRadius.circular(40)),
                          child: TabBar(
                            onTap: (value) {},
                            controller: controller.tabController,
                            labelStyle: const TextStyle(fontFamily: AppThemData.medium, color: Colors.black),
                            unselectedLabelStyle: const TextStyle(fontFamily: AppThemData.regular, color: AppColors.darkGrey04),
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.yellow04),
                            indicatorPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            labelColor: Colors.black,
                            unselectedLabelColor: AppColors.darkGrey04,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            isScrollable: (Constant.getLanguage().name == "English") ? true : false,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: [
                              Tab(
                                text: "Placed".tr,
                              ),
                              Tab(
                                text: "On Going".tr,
                              ),
                              Tab(
                                text: "Completed".tr,
                              ),
                              Tab(
                                text: "Canceled".tr,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: TabBarView(
                            controller: controller.tabController,
                            children: const [PlacedScreenView(), OnGoingScreenView(), CompletedScreenView(), CancelScreenView()]))
                  ],
                )),
          );
        });
  }
}
