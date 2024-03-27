import 'package:get/get.dart';

import '../controllers/like_screen_controller.dart';

class LikeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikeScreenController>(
      () => LikeScreenController(),
    );
  }
}
