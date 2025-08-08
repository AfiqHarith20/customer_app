import 'package:customer_app/app/modules/pay_compound_screen/controllers/pay_compoun_screen_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class PayCompoundScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayCompoundScreenController>(
      () => PayCompoundScreenController(),
    );
  }
}
