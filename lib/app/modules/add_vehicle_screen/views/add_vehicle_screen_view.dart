import 'package:customer_app/app/models/vehicle_model.dart';
import 'package:customer_app/app/modules/add_vehicle_screen/controllers/add_vehicle_screen_controller.dart';
import 'package:customer_app/app/modules/add_vehicle_screen/controllers/edit_vehicle_screen_controller.dart';
import 'package:customer_app/app/modules/vehicle_screen/controllers/vehicle_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVehicleScreenView extends StatefulWidget {
  const AddVehicleScreenView({super.key});

  @override
  State<AddVehicleScreenView> createState() => _AddVehicleScreenViewState();
}

class _AddVehicleScreenViewState extends State<AddVehicleScreenView> {
  final AddVehicleScreenController controller =
      Get.put(AddVehicleScreenController());
  final EditVehicleScreenController controller2 =
      Get.put(EditVehicleScreenController());
  final VehicleScreenController vehicleController =
      Get.find<VehicleScreenController>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeScreen();
  }

  void initializeScreen() async {
    await controller2.loadVehicleData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? vehicleData =
        Get.arguments as Map<String, dynamic>?;

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2.0,
          ),
        ),
      );
    }

    if (vehicleData != null) {
      controller2.initWithDocumentId(vehicleData['documentId']);
      // Pre-fill form fields with vehicle data using controller2
      controller2.plateNoController.value.text = vehicleData['vehicleNo'] ?? '';
      controller2.vehicleModelController.value.text =
          vehicleData['vehicleModel'] ?? '';
      controller2.isDefault.value = vehicleData['default'] ?? false;

      // Set selected color based on vehicle colorHex
      final ColorHexModel? selectedColor =
          controller2.colorHexData.firstWhereOrNull(
        (color) => color.code == vehicleData['colorHex'],
      );
      if (selectedColor != null) {
        controller2.selectedColor.value = selectedColor;
      }

      // Set selected vehicle manufacturer based on vehicle manufacturer name
      final VehicleManufactureModel? selectedVehicle =
          controller2.vehicleManufactData.firstWhereOrNull(
        (vehicle) => vehicle.name == vehicleData['vehicleManufacturer'],
      );
      if (selectedVehicle != null) {
        controller2.selectedVehicle.value = selectedVehicle;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: AppBar(
        leading: IconButton(
          color: AppColors.darkGrey07,
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Get.back();
          },
        ),
        title: Text(
          vehicleData == null ? "New Vehicle".tr : "Edit Vehicle".tr,
          style: const TextStyle(color: AppColors.darkGrey10),
        ),
        backgroundColor: AppColors.white,
        actions: vehicleData == null
            ? []
            : [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.red04,
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return DialogBox(
                            imageAsset: "assets/images/car.png",
                            onPressConfirm: () async {
                              await controller2.deleteVehicle();
                              Navigator.pop(context); // Close the dialog
                              vehicleController.refreshVehicleData();
                              Navigator.pop(context);
                            },
                            onPressConfirmBtnName: "Delete".tr,
                            onPressConfirmColor: AppColors.red04,
                            onPressCancel: () {
                              Get.back();
                            },
                            content:
                                "Are you sure you want to Delete Vehicle.".tr,
                            onPressCancelColor: AppColors.darkGrey01,
                            subTitle: "Delete Vehicle".tr,
                            onPressCancelBtnName: "Cancel".tr);
                      },
                    );
                  },
                ),
              ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKeyVehicle.value,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'PLATE NUMBER*'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: vehicleData == null
                      ? controller.plateNoController.value
                      : controller2.plateNoController.value,
                  onChanged: (text) {
                    // Convert text to uppercase
                    if (vehicleData == null) {
                      controller.plateNoController.value.value =
                          controller.plateNoController.value.value.copyWith(
                        text: text.toUpperCase(),
                        selection: TextSelection(
                          baseOffset: text.length,
                          extentOffset: text.length,
                        ),
                      );
                    } else {
                      controller2.plateNoController.value.value =
                          controller2.plateNoController.value.value.copyWith(
                        text: text.toUpperCase(),
                        selection: TextSelection(
                          baseOffset: text.length,
                          extentOffset: text.length,
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter plate number'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.yellow04,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.yellow04,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.yellow04,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter plate number'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'VEHICLE MANUFACTURE'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return DropdownButtonFormField<VehicleManufactureModel>(
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/images/car-manufacturing.png",
                          height: 24,
                        ),
                      ),
                      labelText:
                          "Select vehicle manufacture".tr, // Optional label
                      labelStyle: const TextStyle(
                        color: AppColors.darkGrey09,
                      ),
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.yellow04,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.yellow04,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.yellow04,
                        ),
                      ),
                    ),
                    itemHeight: 48,
                    items: vehicleData == null
                        ? controller.vehicleManufactData
                            .map((VehicleManufactureModel vehicle) {
                            return DropdownMenuItem<VehicleManufactureModel>(
                              value: vehicle,
                              child: SizedBox(
                                height: 48,
                                child: Center(
                                  child: Text(
                                    vehicle.name?.tr ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            );
                          }).toList()
                        : controller2.vehicleManufactData
                            .map((VehicleManufactureModel vehicle) {
                            return DropdownMenuItem<VehicleManufactureModel>(
                              value: vehicle,
                              child: SizedBox(
                                height: 48,
                                child: Center(
                                  child: Text(
                                    vehicle.name?.tr ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    onChanged: (VehicleManufactureModel? newValue) {
                      if (vehicleData == null) {
                        controller.selectedVehicle.value = newValue;
                        controller.customerVehicleModel.update((val) {
                          val?.vehicleManufacturer = newValue?.name?.tr ?? '';
                        });
                      } else {
                        controller2.selectedVehicle.value = newValue;
                        controller2.customerVehicleModel.update((val) {
                          val?.vehicleManufacturer = newValue?.name?.tr ?? '';
                        });
                      }
                    },
                    value: vehicleData == null
                        ? controller.selectedVehicle.value
                        : controller2.selectedVehicle.value,
                    validator: (value) => null, // Optional, no validation
                  );
                }),
                const SizedBox(height: 10),
                Text(
                  'VEHICLE MODEL'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: vehicleData == null
                      ? controller.vehicleModelController.value
                      : controller2.vehicleModelController.value,
                  decoration: InputDecoration(
                    hintText: 'Enter vehicle model'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.yellow04,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.yellow04,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: AppColors.yellow04,
                      ),
                    ),
                  ),
                  validator: (value) => null, // Optional, no validation
                ),
                const SizedBox(height: 10),
                Text(
                  'COLOR'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return DropdownButtonFormField<ColorHexModel>(
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/images/pantone.png",
                          height: 24,
                        ),
                      ),
                      labelText: "Select color".tr,
                      labelStyle: const TextStyle(
                        color: AppColors.darkGrey09,
                      ),
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.yellow04,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.yellow04,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.yellow04,
                        ),
                      ),
                    ),
                    itemHeight: 48,
                    items: vehicleData == null
                        ? controller.colorHexData.map((ColorHexModel color) {
                            int colorValue = int.tryParse(
                                    color.code!.replaceAll("#", "0xFF")) ??
                                0xFF000000;
                            return DropdownMenuItem<ColorHexModel>(
                              value: color,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    color.name ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(colorValue),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList()
                        : controller2.colorHexData.map((ColorHexModel color) {
                            int colorValue = int.tryParse(
                                    color.code!.replaceAll("#", "0xFF")) ??
                                0xFF000000;
                            return DropdownMenuItem<ColorHexModel>(
                              value: color,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    color.name ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(colorValue),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    onChanged: (ColorHexModel? newValue) {
                      if (vehicleData == null) {
                        controller.selectedColor.value = newValue;
                        controller.customerVehicleModel.update((val) {
                          val?.colorHex = newValue?.code ?? '';
                        });
                      } else {
                        controller2.selectedColor.value = newValue;
                        controller2.customerVehicleModel.update((val) {
                          val?.colorHex = newValue?.code ?? '';
                        });
                      }
                    },
                    value: vehicleData == null
                        ? controller.selectedColor.value
                        : controller2.selectedColor.value,
                    // validator: (value) =>
                    //     value != null ? null : 'Color required'.tr,
                  );
                }),
                const SizedBox(height: 10),
                Text(
                  'PRIMARY'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: vehicleData == null
                            ? controller.isDefault.value
                            : controller2.isDefault.value,
                        onChanged: (bool? value) {
                          if (value != null) {
                            if (vehicleData == null) {
                              controller.isDefault.value = value;
                            } else {
                              controller2.isDefault.value = value;
                            }
                          }
                        },
                      ),
                      const Text('Yes'),
                      Radio<bool>(
                        value: false,
                        groupValue: vehicleData == null
                            ? controller.isDefault.value
                            : controller2.isDefault.value,
                        onChanged: (bool? value) {
                          if (value != null) {
                            if (vehicleData == null) {
                              controller.isDefault.value = value;
                            } else {
                              controller2.isDefault.value = value;
                            }
                          }
                        },
                      ),
                      const Text('No'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGrey09,
                      padding: const EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () async {
                      if (controller.formKeyVehicle.value.currentState!
                          .validate()) {
                        controller.formKeyVehicle.value.currentState!.save();
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevent dialog from being dismissed
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.darkGrey10),
                              ),
                            );
                          },
                        );
                        if (vehicleData == null) {
                          // Call the addVehicle method
                          controller.addVehicle();
                        } else {
                          // Ensure documentId is not null before updating
                          if (controller2.documentId != null) {
                            await controller2.updateVehicle();
                          } else {
                            print('Error: documentId is null');
                            Get.snackbar('Error',
                                'Error updating vehicle: documentId is null');
                          }
                        }
                        // After vehicle is added or updated, close the dialog
                        Navigator.pop(context);

                        // Navigate back to the vehicle screen
                        vehicleController.refreshVehicleData();
                        Get.back();
                      }
                    },
                    child: Text(
                      vehicleData == null
                          ? 'ADD VEHICLE'.tr
                          : 'UPDATE VEHICLE'.tr,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
