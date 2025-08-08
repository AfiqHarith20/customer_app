import 'package:get/get.dart';

import '../controllers/apply_coupon_screen_controller.dart';

class ApplyCouponScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplyCouponScreenController>(
      () => ApplyCouponScreenController(),
    );
  }
}
