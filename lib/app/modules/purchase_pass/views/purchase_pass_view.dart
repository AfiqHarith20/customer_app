// ignore_for_file: use_build_context_synchronously

import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/text_field_prefix_upper_widget.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/button_theme.dart';
import '../../../widget/mobile_number_textfield.dart';
import '../../../widget/text_field_prefix_widget.dart';
import '../controllers/purchase_pass_controller.dart';

class PurchasePassView extends GetView<PurchasePassController> {
  const PurchasePassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<PurchasePassController>(
        init: PurchasePassController(),
        dispose: (state) => state.dispose(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: AppBar(
              title: Text(
                "Pass and Contact Info".tr,
                style: const TextStyle(color: AppColors.darkGrey07),
              ),
              backgroundColor: AppColors.white,
              leading: IconButton(
                color: AppColors.darkGrey07,
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  controller.cleanup();
                  await Get.offAllNamed(Routes.SEASON_PASS);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: controller.formKeyPurchase.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_user.svg",
                          ),
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Name required'.tr,
                        title: "Full Name*".tr,
                        hintText: "Enter Full Name".tr,
                        controller: controller.fullNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_email.svg",
                          ),
                        ),
                        title: "Email*".tr,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Email required'.tr,
                        hintText: "Enter Full Email".tr,
                        controller: controller.emailController.value,
                        onPress: () {},
                      ),
                     
                      MobileNumberTextField(
                        title: "Mobile Number*".tr,
                        controller: controller.phoneNumberController.value,
                        countryCode: controller.countryCode.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefixUpper(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_carsimple.svg",
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        title: "Plate No.*".tr,
                        hintText: "Enter Plate No.".tr,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Plate No. required'.tr,
                        controller: controller.vehicleNoController.value,
                        readOnly: true,
                        onPress: () {
                          if (controller.vehicleList.isNotEmpty) {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: ListView.separated(
                                    itemCount: controller.vehicleList.length,
                                    itemBuilder: (context, index) {
                                      var vehicle =
                                          controller.vehicleList[index];
                                      return ListTile(
                                        title: Center(
                                          child: Text(vehicle['vehicleNo']),
                                        ),
                                        onTap: () {
                                          // Set selected vehicle data to the text field
                                          controller.vehicleNoController.value
                                              .text = vehicle['vehicleNo'];
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(), // Adds a separator between items
                                  ),
                                );
                              },
                            );
                          } else {
                            // Show a dialog if no vehicles are available
                            Get.dialog(
                              DialogBoxNotify(
                                imageAsset: "assets/images/car.png",
                                onPressConfirm: () async {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  // Navigate to the profile page
                                  Get.offAndToNamed(
                                    Routes.VEHICLE_SCREEN,
                                  );
                                },
                                onPressConfirmBtnName: "Ok".tr,
                                onPressConfirmColor: AppColors.green04,
                                content: "Please add your vehicle.".tr,
                                subTitle: "No Plate Number Available".tr.tr,
                              ),
                              barrierDismissible: false,
                            );
                          }
                        },
                        textCapitalization: TextCapitalization.characters,
                      ),
                      
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_buildings.svg",
                          ),
                        ),
                        title: "Company Name".tr,
                        hintText: "Enter Company Name".tr,
                        controller: controller.companyNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            "assets/images/certificate.png",
                            height: 4,
                          ),
                        ),
                        title: "Company Registration No.".tr,
                        hintText: "Enter Company Registration No.".tr,
                        controller:
                            controller.companyRegistrationNoController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            "assets/images/location.png",
                            height: 4,
                          ),
                        ),
                        title: "Address".tr,
                        hintText: "Enter Address".tr,
                        controller: controller.addressController.value,
                        onPress: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ButtonThem.buildButton(
                    context,
                    btnHeight: 48,
                    title: "Submit".tr,
                    txtColor: Colors.black,
                    bgColor: AppColors.yellow04,
                    onPress: () async {
                      if (controller.formKeyPurchase.value.currentState!
                          .validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.darkGrey10,
                                ),
                              ),
                            );
                          },
                        );
                        await controller.getQueryPass();
                        Navigator.of(context).pop();
                        await controller.addSeasonPassData();
                         controller.cleanup();
                        Get.offNamed(Routes.SELECT_PAYMENT_SCREEN, arguments: {
                          "addSeasonPassData": controller.addSeasonPassData,
                          "purchasePassModel":
                              controller.purchasePassModel.value,
                          "passId": controller
                              .purchasePassModel.value.seasonPassModel?.passid,
                          "passName": controller.purchasePassModel.value
                              .seasonPassModel?.passName,
                          "passPrice": controller
                              .purchasePassModel.value.seasonPassModel?.price,
                          "passValidity": controller.purchasePassModel.value
                              .seasonPassModel?.validity,
                        });
                      }
                    },
                  )),
            ),
          );
        });
  }
}
