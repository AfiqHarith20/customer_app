import 'package:customer_app/app/modules/profile_screen/controllers/profile_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  ProfileScreenController profileScreenController = Get.put(ProfileScreenController());

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    super.onInit();
  }
}
