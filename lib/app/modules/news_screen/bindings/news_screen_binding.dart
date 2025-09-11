import 'package:customer_app/app/modules/news_screen/controllers/news_screen_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class NewsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsScreenController>(
      () => NewsScreenController(),
    );
  }
}
