import 'package:get/get.dart';

import '../controllers/on_going_screen_controller.dart';

class OnGoingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnGoingScreenController>(
      () => OnGoingScreenController(),
    );
  }
}
