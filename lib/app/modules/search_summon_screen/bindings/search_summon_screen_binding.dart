

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/search_summon_screen_controller.dart';

class SearchSummonScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchSummonScreenController>(
          () => SearchSummonScreenController(),
    );
  }
}