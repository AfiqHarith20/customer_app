import 'package:get/get.dart';

import '../controllers/rate_us_screen_controller.dart';

class RateUsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RateUsScreenController>(
      () => RateUsScreenController(),
    );
  }
}
