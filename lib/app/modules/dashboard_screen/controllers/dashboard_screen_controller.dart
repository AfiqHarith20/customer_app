import 'package:customer_app/app/modules/MySeason_Pass/views/my_season_pass_view.dart';
import 'package:customer_app/app/modules/home/views/home_view.dart';
import 'package:customer_app/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/app/modules/search_summon_screen/views/search_summon_screen_view.dart';
import 'package:customer_app/app/modules/transaction_history_screen/views/transaction_history_screen_view.dart';
import 'package:customer_app/app/modules/wallet_screen/views/wallet_screen_view.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var isUserLoggedIn = false.obs;
  late SearchSummonScreenView controller;
  RxBool isLoading = false.obs;
  void refreshData() {
    isLoading = true.obs;
    // Call update() to force rebuild of dependent widgets
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    checkLoginStatus();
    super.onInit();
  }

  // Define the expected types for each page
  final List<Widget> pageList = [
    const HomeView(),
    const MySeasonPassView(),
    SearchSummonScreenView(
      controller: SearchSummonScreenController(),
    ),
    const TransactionHistoryScreenView(),
    const ProfileScreenView(),
  ];

  void checkLoginStatus() {
    // Assuming FireStoreUtils.isLogin() checks login state
    FireStoreUtils.isLogin().then((isLoggedIn) {
      isUserLoggedIn.value = isLoggedIn;
      isLoading.value = false; // Stop loading after check
    });
  }
}
