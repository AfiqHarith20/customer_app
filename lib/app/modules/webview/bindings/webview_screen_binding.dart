import 'package:customer_app/app/modules/webview/controllers/webview_screen_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class WebviewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewScreenController>(
      () => WebviewScreenController(),
    );
  }
}
