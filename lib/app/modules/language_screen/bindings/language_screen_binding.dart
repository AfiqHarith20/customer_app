import 'package:get/get.dart';

import '../controllers/language_screen_controller.dart';

class LanguageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageScreenController>(
      () => LanguageScreenController(),
    );
  }
}
