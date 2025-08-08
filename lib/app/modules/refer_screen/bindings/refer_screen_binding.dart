import 'package:get/get.dart';

import '../controllers/refer_screen_controller.dart';

class ReferScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferScreenController>(
      () => ReferScreenController(),
    );
  }
}
