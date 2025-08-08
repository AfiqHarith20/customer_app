import 'package:customer_app/app/modules/reset_password_screen/controllers/reset_password_screen_controller.dart';
import 'package:get/get.dart';

class ResetPasswordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordScreenController>(
      () => ResetPasswordScreenController(),
    );
  }
}
