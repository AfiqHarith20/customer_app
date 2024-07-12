import 'package:customer_app/app/modules/vehicle_screen/controllers/vehicle_screen_controller.dart';
import 'package:get/get.dart';

class VehicleScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleScreenController>(
      () => VehicleScreenController(),
    );
  }
}
