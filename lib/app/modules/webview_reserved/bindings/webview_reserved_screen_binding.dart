// ignore: unused_import
import 'package:customer_app/app/modules/webview/controllers/webview_screen_controller.dart';
import 'package:customer_app/app/modules/webview_reserved/controllers/webview_Reserved_screen_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class WebviewReservedScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewReservedScreenController>(
      () => WebviewReservedScreenController(),
    );
  }
}
