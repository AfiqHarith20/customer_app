// ignore_for_file: deprecated_member_use

import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_screen_controller.dart';

class DashboardScreenView extends GetView<DashboardScreenController> {
  const DashboardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is open.
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Obx(
      () => Scaffold(
        body: controller.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: controller.selectedIndex.value,
          showUnselectedLabels: true,
          onTap: (int index) {
            // Use a unified method to handle navigation and login checks
            controller.handleNavigation(index);
          },
          selectedItemColor: AppColors.yellow04,
          showSelectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontFamily: AppThemData.bold,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: AppColors.darkGrey04,
          unselectedLabelStyle: const TextStyle(
            fontFamily: AppThemData.medium,
            fontSize: 12,
          ),
          backgroundColor: AppColors.darkGrey10,
          items: [
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset("assets/icons/ic_home_active.svg"),
                icon: SvgPicture.asset("assets/icons/ic_home.svg"),
                label: "Home".tr),
            BottomNavigationBarItem(
                activeIcon:
                    SvgPicture.asset("assets/icons/ic_mypass_active.svg"),
                icon: SvgPicture.asset("assets/icons/ic_mypass.svg"),
                label: "My Pass".tr),
            const BottomNavigationBarItem(
              icon: Icon(null),
              label: '',
            ),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  "assets/icons/txn_active.svg",
                  height: 22,
                ),
                icon: SvgPicture.asset(
                  "assets/icons/txn.svg",
                  height: 22,
                ),
                label: "History".tr),
            BottomNavigationBarItem(
                activeIcon:
                    SvgPicture.asset("assets/icons/ic_myprofile_active.svg"),
                icon: SvgPicture.asset(
                  "assets/icons/ic_myprofile.svg",
                  colorFilter: const ColorFilter.mode(
                      AppColors.darkGrey04, BlendMode.srcIn),
                ),
                label: "My Profile".tr),
          ],
        ),
        floatingActionButton: Visibility(
          visible: !keyboardIsOpen,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.lightGrey02,
                borderRadius: BorderRadius.circular(50)),
            padding: const EdgeInsets.all(8),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: AppColors.yellow04,
              onPressed: () {
                // Use the same unified navigation method for the FAB
                controller.handleNavigation(2);
              },
              child: SvgPicture.asset(
                "assets/icons/ic_frame_inspect.svg",
                height: 32,
                width: 32,
                colorFilter: const ColorFilter.mode(
                    AppColors.darkGrey10, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}
