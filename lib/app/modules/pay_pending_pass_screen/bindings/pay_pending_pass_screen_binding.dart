import 'package:customer_app/app/modules/pay_pending_pass_screen/controllers/pay_pending_pass_screen_controller.dart';
import 'package:get/get.dart';

class PayPendingPassScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayPendingPassScreenController>(
      () => PayPendingPassScreenController(),
    );
  }
}
