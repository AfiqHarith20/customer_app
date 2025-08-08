import 'package:customer_app/app/modules/qrcode_screen/controllers/qrcode_screen_controller.dart';
import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
//import 'package:get/get_instance/src/bindings_interface.dart';

class QRCodeScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QRCodeScanController>(
          () => QRCodeScanController(),
    );
  }
}