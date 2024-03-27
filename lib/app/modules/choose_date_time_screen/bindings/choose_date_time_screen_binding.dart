import 'package:get/get.dart';

import '../controllers/choose_date_time_screen_controller.dart';

class ChooseDateTimeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseDateTimeScreenController>(
      () => ChooseDateTimeScreenController(),
    );
  }
}
