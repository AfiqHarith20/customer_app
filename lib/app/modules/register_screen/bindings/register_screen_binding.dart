import 'package:customer_app/app/modules/register_screen/controllers/register_screen_controller.dart';
import 'package:get/get.dart';

class RegisterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterScreenController>(
      () => RegisterScreenController(),
    );
  }
}
