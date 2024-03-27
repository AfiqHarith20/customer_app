import 'package:customer_app/app/modules/MySeason_Pass/views/my_season_pass_view.dart';
import 'package:customer_app/app/modules/booking_screen/views/booking_screen_view.dart';
import 'package:customer_app/app/modules/home/views/home_view.dart';
import 'package:customer_app/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:customer_app/app/modules/qrcode_screen/views/qrcode_screen_view.dart';
import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/app/modules/search_summon_screen/views/search_summon_screen_view.dart';
import 'package:customer_app/app/modules/wallet_screen/views/wallet_screen_view.dart';
import 'package:customer_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList pageList = [const HomeView(), const MySeasonPassView(), const SearchSummonScreenView(), const WalletScreenView(), const ProfileScreenView()].obs;

  // const SizedBox()
}
