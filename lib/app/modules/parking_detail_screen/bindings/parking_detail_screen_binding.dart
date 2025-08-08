import 'package:get/get.dart';

import '../controllers/parking_detail_screen_controller.dart';

class ParkingDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingDetailScreenController>(
      () => ParkingDetailScreenController(),
    );
  }
}
