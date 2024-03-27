import 'package:get/get.dart';

import '../controllers/season_pass_controller.dart';

class SeasonPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeasonPassController>(
      () => SeasonPassController(),
    );
  }
}
