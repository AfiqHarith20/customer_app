import 'package:get/get.dart';

import '../controllers/booking_detail_screen_controller.dart';

class BookingDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingDetailScreenController>(
      () => BookingDetailScreenController(),
    );
  }
}
