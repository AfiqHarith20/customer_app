import 'package:customer_app/app/modules/MySeason_Pass/views/my_season_pass_view.dart';
import 'package:customer_app/app/modules/home/controllers/home_controller.dart';
import 'package:customer_app/app/modules/home/views/home_view.dart';
import 'package:customer_app/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/app/modules/search_summon_screen/views/search_summon_screen_view.dart';
import 'package:customer_app/app/modules/transaction_history_screen/views/transaction_history_screen_view.dart';
import 'package:customer_app/app/modules/wallet_screen/views/wallet_screen_view.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var isUserLoggedIn = false.obs;
  RxBool isLoading = true.obs; // Set to true initially

  // Instance of HomeController to manage its lifecycle
  late HomeController homeController;

  @override
  void onInit() {
    homeController = Get.put(HomeController());
    checkLoginStatus();
    super.onInit();
  }

  void checkLoginStatus() async {
    isUserLoggedIn.value = await FireStoreUtils.isLogin();
    isLoading.value = false;
  }

  // Use a single instance of each view
  final List<Widget> pages = [
    HomeView(),
    MySeasonPassView(),
    SearchSummonScreenView(controller: SearchSummonScreenController()),
    TransactionHistoryScreenView(),
    ProfileScreenView(),
  ];

  Widget get currentPage {
    if (isLoading.value) {
      // Show a loader while data is being fetched
      return const Center(child: CircularProgressIndicator());
    }
    return pages[selectedIndex.value];
  }

  void handleNavigation(int index) async {
    if (index == 2 || index == 3 || index == 4) {
      if (!isUserLoggedIn.value) {
        Get.toNamed(Routes.LOGIN_SCREEN);
        return;
      }
    }
    selectedIndex.value = index;
  }
}
