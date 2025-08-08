import 'package:get/get.dart';

import '../controllers/my_season_pass_controller.dart';

class MySeasonPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MySeasonPassController>(
      () => MySeasonPassController(),
    );
  }
}
