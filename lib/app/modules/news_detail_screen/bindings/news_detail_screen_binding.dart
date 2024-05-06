import 'package:customer_app/app/modules/news_detail_screen/controllers/news_detail_screen_controller.dart';
import 'package:get/get.dart';

class NewsDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsDetailScreenController>(
      () => NewsDetailScreenController(),
    );
  }
}
