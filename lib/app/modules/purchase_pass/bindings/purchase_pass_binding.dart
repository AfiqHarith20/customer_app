import 'package:get/get.dart';

import '../controllers/purchase_pass_controller.dart';

class PurchasePassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchasePassController>(
      () => PurchasePassController(),
    );
  }
}
