import 'package:customer_app/app/modules/webview_compound_screen/controllers/webview_compound_screen_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class WebviewCompoundScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewCompoundScreenController>(
      () => WebviewCompoundScreenController(),
    );
  }
}
