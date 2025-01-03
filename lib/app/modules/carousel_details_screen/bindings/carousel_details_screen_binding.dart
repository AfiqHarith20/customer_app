import 'package:customer_app/app/modules/carousel_details_screen/controllers/carousel_details_screen_controller.dart';
import 'package:get/get.dart';

class CarouselDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarouselDetailsScreenController>(
      () => CarouselDetailsScreenController(),
    );
  }
}
