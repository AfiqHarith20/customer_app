import 'package:get/get.dart';

import '../controllers/completed_screen_controller.dart';

class CompletedScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompletedScreenController>(
      () => CompletedScreenController(),
    );
  }
}
