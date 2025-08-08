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
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Obx(
      () => Scaffold(
        body: controller.pageList[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: controller.selectedIndex.value,
          showUnselectedLabels: true,
          onTap: (int index) async {
            if (index == 3 || index == 4) {
              // Check if the user is logged in before allowing access to History or Profile
              bool isLoggedIn = await FireStoreUtils.isLogin();
              if (!isLoggedIn) {
                Get.toNamed(
                    Routes.LOGIN_SCREEN); // Redirect to login if not logged in
                return;
              }
            }
            controller.selectedIndex.value =
                index; // Normal navigation if logged in
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
                  color: AppColors.darkGrey04,
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
              onPressed: () async {
                // Check if user is logged in before allowing access to floating action
                bool isLoggedIn = await FireStoreUtils.isLogin();
                if (!isLoggedIn) {
                  Get.toNamed(Routes
                      .LOGIN_SCREEN); // Redirect to login if not logged in
                  return;
                }

                // If logged in, navigate to the inspect page
                DashboardScreenController dashboardScreenController =
                    Get.put(DashboardScreenController());
                dashboardScreenController
                    .selectedIndex(2); // Go to Inspect page
              },
              child: SvgPicture.asset(
                "assets/icons/ic_frame_inspect.svg",
                height: 32,
                width: 32,
                color: AppColors.darkGrey10,
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
