import 'package:get/get.dart';

import '../controllers/placed_screen_controller.dart';

class PlacedScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlacedScreenController>(
      () => PlacedScreenController(),
    );
  }
}
