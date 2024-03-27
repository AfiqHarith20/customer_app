import 'package:get/get.dart';

import '../controllers/booking_summary_screen_controller.dart';

class BookingSummaryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingSummaryScreenController>(
      () => BookingSummaryScreenController(),
    );
  }
}
