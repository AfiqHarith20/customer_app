import 'package:get/get.dart';

import '../controllers/select_payment_screen_controller.dart';

class SelectPaymentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectPaymentScreenController>(
      () => SelectPaymentScreenController(),
    );
  }
}
