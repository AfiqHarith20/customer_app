import 'package:get/get.dart';

import '../controllers/booking_screen_controller.dart';

class BookingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingScreenController>(
      () => BookingScreenController(),
    );
  }
}
