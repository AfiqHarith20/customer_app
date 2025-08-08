import 'package:get/get.dart';

import '../controllers/select_bank_provider_screen_controller.dart';

class SelectBankProviderScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectBankProviderScreenController>(
          () => SelectBankProviderScreenController(),
    );
  }
}
