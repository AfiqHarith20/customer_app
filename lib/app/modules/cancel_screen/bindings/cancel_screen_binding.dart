import 'package:get/get.dart';

import '../controllers/cancel_screen_controller.dart';

class CancelScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancelScreenController>(
      () => CancelScreenController(),
    );
  }
}
