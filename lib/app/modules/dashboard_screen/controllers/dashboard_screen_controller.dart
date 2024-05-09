import 'package:customer_app/app/modules/MySeason_Pass/views/my_season_pass_view.dart';
import 'package:customer_app/app/modules/home/views/home_view.dart';
import 'package:customer_app/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/app/modules/search_summon_screen/views/search_summon_screen_view.dart';
import 'package:customer_app/app/modules/wallet_screen/views/wallet_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  late SearchSummonScreenView controller;
  RxBool isLoading = false.obs;
  void refreshData() {
    isLoading = true.obs;
    // Call update() to force rebuild of dependent widgets
    update();
  }

  // Define the expected types for each page
  final List<Widget> pageList = [
    const HomeView(),
    MySeasonPassView(),
    SearchSummonScreenView(
      controller: SearchSummonScreenController(),
    ),
    WalletScreenView(
      selectedBankName: '',
      accessToken: '',
      customerId: '',
      channelId: 0,
      selectedBankId: '',
      amount: '',
      email: '',
      mobileNumber: '',
      name: '',
      username: '',
      identificationNumber: '',
      identificationType: 0,
    ),
    const ProfileScreenView(),
  ];

  // const SizedBox()
}
