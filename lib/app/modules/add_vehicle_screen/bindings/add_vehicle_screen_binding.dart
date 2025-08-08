import 'package:customer_app/app/modules/add_vehicle_screen/controllers/add_vehicle_screen_controller.dart';
import 'package:get/get.dart';

class AddVehicleScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddVehicleScreenController>(
      () => AddVehicleScreenController(),
    );
  }
}
