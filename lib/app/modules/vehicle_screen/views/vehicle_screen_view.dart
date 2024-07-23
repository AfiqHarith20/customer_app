import 'package:customer_app/app/modules/vehicle_screen/controllers/vehicle_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Example function to convert color hex codes to color names
String getColorNameFromHex(String colorHex) {
  // This is just an example map, you might need to implement or use a library for this conversion
  Map<String, String> colorMap = {
    '#FF0000': 'Red',
    '#00FF00': 'Green',
    '#0000FF': 'Blue',
    // Add more color mappings as needed
  };

  // Default to returning hex if no match found
  return colorMap[colorHex] ?? colorHex;
}

// Function to convert color hex codes to Color objects
Color getColorFromHex(String colorHex) {
  return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
}

class VehicleScreenView extends StatelessWidget {
  final VehicleScreenController controller = Get.put(VehicleScreenController());

  VehicleScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: UiInterface().customAppBar(
        backgroundColor: AppColors.white,
        context,
        "My Vehicle".tr,
        onBackTap: () {
          Get.offAndToNamed(Routes.DASHBOARD_SCREEN);
        },
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                await Get.toNamed(Routes.ADD_NEW_VEHICLE);
                // Call fetchVehicle to refresh the vehicle list after returning
                await controller.fetchVehicle();
              },
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.yellow04,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Add".tr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: AppThemData.bold,
                      color: AppColors.darkGrey08,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2.0,
              strokeCap: StrokeCap.round,
            ),
          );
        }

        if (controller.vehicleList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sorry, no vehicles registered.".tr,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: AppColors.darkGrey10,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.vehicleList.length,
                  itemBuilder: (context, index) {
                    var vehicle = controller.vehicleList[index];
                    final vehicleNo = vehicle['vehicleNo'];
                    final colorHex = vehicle['colorHex'];
                    final vehicleManufacturer = vehicle['vehicleManufacturer'];
                    final vehicleModel = vehicle['vehicleModel'];
                    final vehicleDefault = vehicle['default'];
                    final colorName = getColorNameFromHex(colorHex);
                    final vehicleColor = getColorFromHex(colorHex);

                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: AppColors.yellow04,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${vehicleManufacturer ?? ''} - ${vehicleModel ?? ''}',
                                style: const TextStyle(
                                  color: AppColors.darkGrey10,
                                  fontSize: 16.0,
                                ),
                              ),
                              if (vehicleDefault ?? false)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'PRIMARY'.tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        vehicleNo ?? '',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontFamily: AppThemData.medium,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Container(
                                    width: 40,
                                    height: 47,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: vehicleColor,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 32,
                                ),
                                onPressed: () async {
                                  if (vehicle != null) {
                                    await Get.toNamed(
                                      Routes.ADD_NEW_VEHICLE,
                                      arguments: {
                                        'vehicleNo': vehicle['vehicleNo'],
                                        'colorHex': vehicle['colorHex'],
                                        'vehicleManufacturer':
                                            vehicle['vehicleManufacturer'],
                                        'vehicleModel': vehicle['vehicleModel'],
                                        'default': vehicle['default'],
                                        'documentId': vehicle['documentId'],
                                      },
                                    );
                                    // Call fetchVehicle to refresh the vehicle list after returning
                                    await controller.fetchVehicle();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      }),
    );
  }
}
