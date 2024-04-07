import 'package:get/get.dart';

import '../controllers/payment_compound_screen_controller.dart';

class PaymentCompoundScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentCompoundScreenController>(
      () => PaymentCompoundScreenController(),
    );
  }
}
