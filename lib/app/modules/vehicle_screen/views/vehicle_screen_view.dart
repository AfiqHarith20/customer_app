// ignore_for_file: deprecated_member_use

import 'package:customer_app/app/modules/vehicle_screen/controllers/vehicle_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Function to convert color hex codes to Color objects
Color getColorFromHex(String? colorHex) {
  if (colorHex == null || colorHex.isEmpty) {
    return Colors
        .transparent; // Return a default color or transparent if hex is null or empty
  }
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
          Get.back();
        },
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () async {
                await Get.toNamed(Routes.ADD_NEW_VEHICLE);
                // Call fetchVehicle to refresh the vehicle list after returning
                await controller.fetchVehicle();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.yellow04,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkGrey02.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Add".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppThemData.bold,
                      color: AppColors.darkGrey08,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.darkGrey09,
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
          child: ListView.builder(
            itemCount: controller.vehicleList.length,
            itemBuilder: (context, index) {
              var vehicle = controller.vehicleList[index];
              final vehicleNo = vehicle['vehicleNo'] ?? '';
              final colorHex = vehicle['colorHex'];
              final vehicleManufacturer = vehicle['vehicleManufacturer'] ?? '';
              final vehicleModel = vehicle['vehicleModel'] ?? '';
              final vehicleDefault = vehicle['default'] ?? false;
              final vehicleColor = getColorFromHex(colorHex);

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () async {
                    if (vehicle != null) {
                      await Get.toNamed(
                        Routes.ADD_NEW_VEHICLE,
                        arguments: {
                          'vehicleNo': vehicle['vehicleNo'],
                          'colorHex': vehicle['colorHex'],
                          'vehicleManufacturer': vehicle['vehicleManufacturer'],
                          'vehicleModel': vehicle['vehicleModel'],
                          'default': vehicle['default'],
                          'documentId': vehicle['documentId'],
                        },
                      );
                      // Call fetchVehicle to refresh the vehicle list after returning
                      await controller.fetchVehicle();
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                (vehicleManufacturer?.isEmpty ?? true) &&
                                        (vehicleModel?.isEmpty ?? true)
                                    ? 'No data'
                                    : '${vehicleManufacturer ?? ''}${vehicleManufacturer != null && vehicleModel != null ? ' - ' : ''}${vehicleModel ?? ''}',
                                style: const TextStyle(
                                  color: AppColors.darkGrey10,
                                  fontFamily: AppThemData.medium,
                                  fontSize: 16.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (vehicleDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 10.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  'PRIMARY'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: AppThemData.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                vehicleNo,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontFamily: AppThemData.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            if (colorHex != null && colorHex.isNotEmpty)
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: vehicleColor,
                                  border: Border.all(color: Colors.black12),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
