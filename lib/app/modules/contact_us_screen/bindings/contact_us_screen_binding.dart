import 'package:get/get.dart';

import '../controllers/contact_us_screen_controller.dart';

class ContactUsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsScreenController>(
      () => ContactUsScreenController(),
    );
  }
}
