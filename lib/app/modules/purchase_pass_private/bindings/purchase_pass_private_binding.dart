import 'package:get/get.dart';

import '../controllers/purchase_pass_private_controller.dart';

class PurchasePassPrivateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchasePassPrivateController>(
      () => PurchasePassPrivateController(),
    );
  }
}