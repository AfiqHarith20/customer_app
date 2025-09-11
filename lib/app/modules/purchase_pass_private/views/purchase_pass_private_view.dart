// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:customer_app/app/models/query_lot_model.dart';
import 'package:customer_app/app/models/zone_road_model.dart';
import 'package:customer_app/app/modules/MySeason_Pass/controllers/my_season_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/app/widget/text_field_prefix_upper_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:intl/intl.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/button_theme.dart';
import '../../../../themes/common_ui.dart';
import '../../../widget/mobile_number_textfield.dart';
import '../../../widget/text_field_prefix_widget.dart';
import '../controllers/purchase_pass_private_controller.dart';

class PurchasePassPrivateView extends StatefulWidget {
  const PurchasePassPrivateView({super.key});

  @override
  State<PurchasePassPrivateView> createState() =>
      _PurchasePassPrivateViewState();
}

class _PurchasePassPrivateViewState extends State<PurchasePassPrivateView> {
  final PurchasePassPrivateController controller =
      Get.put(PurchasePassPrivateController());
  @override
  Widget build(BuildContext context) {
    return GetX<PurchasePassPrivateController>(
      init: PurchasePassPrivateController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: Scaffold(
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
                  controller.clearFormData();
                  Get.back();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: controller.formKeyPurchasePrivate.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Pass Type*".tr,
                      //   style: TextStyle(fontSize: 16, color: AppColors.darkGrey06, fontFamily: AppThemData.regular),
                      // ),
                      // const SizedBox(height: 5),
                      // DropdownButtonFormField<PrivatePassModel>(
                      //     isExpanded: false,
                      //     icon: const Icon(
                      //       Icons.keyboard_arrow_down,
                      //       color: AppColors.lightGrey10,
                      //       size: 30,
                      //     ),
                      //     decoration: InputDecoration(
                      //       errorStyle: const TextStyle(color: Colors.red),
                      //       filled: true,
                      //       fillColor: AppColors.white,
                      //       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      //       disabledBorder: UnderlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: const BorderSide(color: AppColors.white, width: 1),
                      //       ),
                      //       focusedBorder: UnderlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: const BorderSide(color: AppColors.white, width: 1),
                      //       ),
                      //       enabledBorder: UnderlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: const BorderSide(color: AppColors.white, width: 1),
                      //       ),
                      //       errorBorder: UnderlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: const BorderSide(color: AppColors.white, width: 1),
                      //       ),
                      //       border: UnderlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //         borderSide: const BorderSide(color: AppColors.white, width: 1),
                      //       ),
                      //       hintStyle: const TextStyle(fontFamily: AppThemData.regular),
                      //     ),
                      //     value: controller.selectedSessionPass.value,
                      //     onChanged: (value) {
                      //       controller.selectedSessionPass.value = value!;
                      //     },
                      //     style: const TextStyle(color: AppColors.darkGrey10),
                      //     hint: Text(
                      //       "Select Pass Type".tr,
                      //       style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10),
                      //     ),
                      //     items: controller.privatePassList.map((item) {
                      //       return DropdownMenuItem<PrivatePassModel>(
                      //         value: item,
                      //         child: Text(item.passName.toString(), style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10)),
                      //       );
                      //     }).toList()),
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
                      // TextFieldWidgetPrefix(
                      //   prefix: Padding(
                      //     padding: const EdgeInsets.all(12.0),
                      //     child: SvgPicture.asset(
                      //       "assets/icons/ic_hash.svg",
                      //     ),
                      //   ),
                      //   title: "Identification Card No.*".tr,
                      //   validator: (value) => value != null && value.isNotEmpty
                      //       ? null
                      //       : "Identification Card No. required".tr,
                      //   hintText: "Enter Identification Card No.*".tr,
                      //   controller: controller.identificationNoController.value,
                      //   onPress: () {},
                      // ),
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
                        title: "Plate No.".tr,
                        hintText: "Enter Plate No.".tr,
                        // validator: (value) => value != null && value.isNotEmpty
                        //     ? null
                        //     : 'Plate No. required'.tr,
                        controller: controller.vehicleNoController.value,
                        onPress: () {},
                        textCapitalization: TextCapitalization.characters,
                      ),
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_hash.svg",
                          ),
                        ),
                        title: "Lot No.*".tr,
                        hintText: "Enter Lot No.".tr,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : "Lot No. required".tr,
                        controller: controller.lotNoController.value,
                        onPress: () {},
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Lot Image".tr,
                              // style: const TextStyle(
                              //   fontSize: 16,
                              //   fontWeight: FontWeight.bold,
                              // ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showImagePickerOptions(context, controller);
                            },
                            child: Center(
                              child: SizedBox(
                                height: Responsive.width(30, context),
                                width: Responsive.width(30, context),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors
                                              .darkGrey06, // Adjust border color as needed
                                          width:
                                              2, // Adjust border width as needed
                                        ),
                                        color: AppColors.darkGrey04
                                            .withOpacity(0.5),
                                      ),
                                      child: controller.privateParkImage.isEmpty
                                          ? const Icon(
                                              Icons.add,
                                              size: 110,
                                              color: Colors.black12,
                                            )
                                          : (Constant().hasValidUrl(controller
                                                  .privateParkImage.value))
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: NetworkImageWidget(
                                                    imageUrl: controller
                                                        .privateParkImage.value,
                                                    height: Responsive.width(
                                                        30, context),
                                                    width: Responsive.width(
                                                        30, context),
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.file(
                                                    File(controller
                                                        .privateParkImage
                                                        .value),
                                                    height: Responsive.width(
                                                        30, context),
                                                    width: Responsive.width(
                                                        30, context),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (controller.privateParkImage
                              .isEmpty) // Show warning if lot image is not selected
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Please select a lot image".tr,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_buildings.svg",
                          ),
                        ),
                        title: "Company Name*".tr,
                        hintText: "Enter Company Name".tr,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Company Name required'.tr,
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
                        title: "Company Registration No.*".tr,
                        hintText: "Enter Company Registration No.".tr,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Company Registration No. required'.tr,
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
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_calender.svg",
                          ),
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Start Date required'.tr,
                        title: "Start Date*".tr,
                        hintText: "Enter Start Date".tr,
                        controller: TextEditingController(
                          text: controller.startAtDateController.value.value !=
                                  null
                              ? DateFormat('dd/MM/yyyy').format(
                                  controller.startAtDateController.value.value!,
                                )
                              : '',
                        ),
                        readOnly: true,
                        onPress: () async {
                          List<DateTime?>? pickDate =
                              await showCalendarDatePicker2Dialog(
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              calendarViewMode: CalendarDatePicker2Mode.day,
                              currentDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              selectedDayHighlightColor: AppColors.yellow04,
                            ),
                            dialogSize: const Size(325, 400),
                          );

                          if (pickDate != null &&
                              pickDate.isNotEmpty &&
                              pickDate[0] != null) {
                            DateTime selectedDate = pickDate[
                                0]!; // Extract the first date and ensure it's not null
                            DateTime firstDayOfMonth = DateTime(
                                selectedDate.year, selectedDate.month, 1);
                            controller.startAtDateController.value.value =
                                firstDayOfMonth;
                            setState(() {});
                          }
                        },
                      ),
                      Obx(() {
                        return DropdownButtonFormField<Zone>(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                "assets/icons/ic_map_redirect.svg",
                              ),
                            ),
                            labelText: "Zone*".tr,
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
                          items: controller.zones.map((Zone zone) {
                            return DropdownMenuItem<Zone>(
                              value: zone,
                              child: Text(
                                zone.znName ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (Zone? newValue) {
                            controller.selectedZone.value = newValue;
                            if (newValue != null) {
                              controller.fetchRoads(newValue.znId!);
                            }
                          },
                          value: controller.selectedZone.value,
                          validator: (value) =>
                              value != null ? null : 'Zone required'.tr,
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      // Road Dropdown
                      Obx(() {
                        return DropdownButtonFormField<Road>(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                "assets/images/road.png",
                                height: 4,
                              ),
                            ),
                            labelText: "Road*".tr,
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
                          items: controller.roads.map((Road road) {
                            return DropdownMenuItem<Road>(
                              value: road,
                              child: Text(
                                road.jlnNama ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (Road? newValue) {
                            controller.selectedRoad.value = newValue;
                          },
                          value: controller.selectedRoad.value,
                          validator: (value) =>
                              value != null ? null : 'Road required'.tr,
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      // TextFieldWidgetPrefix(
                      //   prefix: Padding(
                      //     padding: const EdgeInsets.all(12.0),
                      //     child: SvgPicture.asset(
                      //       "assets/icons/ic_ticket.svg",
                      //     ),
                      //   ),
                      //   title: "Referral".tr,
                      //   hintText: "Enter Referral".tr,
                      //   controller: controller.referenceController.value,
                      //   onPress: () {},
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ButtonThem.buildButton(context,
                    btnHeight: 48,
                    title: "Submit".tr,
                    txtColor: Colors.black,
                    bgColor: AppColors.yellow04, onPress: () async {
                  if (controller.formKeyPurchasePrivate.value.currentState!
                          .validate() &&
                      controller.privateParkImage.value.isNotEmpty) {
                    // Show loading indicator
                    showDialog(
                      context: context,
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

                    // Call getQueryLot() first
                    await controller.getQueryLot();

                    // Show dialog box with new API response
                    bool isConfirmed = await showNewPassDialog(
                        context, controller.queryLotModel.value);

                    // If the user cancelled the dialog, stop execution here
                    if (!isConfirmed) {
                      Navigator.of(context).pop();
                      return;
                    }

                    // Call postReservePassData asynchronously
                    bool success = await controller.addPrivatePassData();

                    // Hide loading indicator
                    Navigator.of(context).pop();

                    // Show success or error dialog based on the result
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return success
                            ? DialogBoxNotify(
                                imageAsset: "assets/images/ic_parking.png",
                                onPressConfirm: () async {
                                  // Close the dialog
                                  Navigator.pop(context);

                                  // Navigate to dashboard page
                                  controller.clearFormData();
                                  Get.offAndToNamed(
                                    Routes.DASHBOARD_SCREEN,
                                  );
                                  // Reload the DASHBOARD_SCREEN
                                  Get.find<MySeasonPassController>().reload();
                                },
                                onPressConfirmBtnName: "Ok".tr,
                                onPressConfirmColor: AppColors.green04,
                                content:
                                    "Your request has been sent with status 'Pending'"
                                        .tr,
                                subTitle: "Success".tr,
                              )
                            : DialogBoxNotify(
                                imageAsset: "assets/images/ic_parking.png",
                                onPressConfirm: () async {
                                  // Close the dialog
                                  Navigator.pop(context);
                                },
                                onPressConfirmBtnName: "Ok".tr,
                                onPressConfirmColor: AppColors.red04,
                                content:
                                    "Your request is not successfully sent, please try again"
                                        .tr,
                                subTitle: "Error".tr,
                              );
                      },
                    );
                  }
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> showNewPassDialog(
      BuildContext context, QueryLot queryLot) async {
    bool isConfirmed = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
        return DialogBox(
          imageAsset: "assets/images/ic_parking.png",
          content:
              '${'As a new user, we would like to let you know that the minimum purchase for the private pass is 3 months. Below are the details:'.tr}\n${'Start Date:'.tr}${queryLot.newStartDate != null ? dateFormat.format(queryLot.newStartDate!) : ''}\n${'End Date:'.tr}${queryLot.newEndDate != null ? dateFormat.format(queryLot.newEndDate!) : ''}\n${'Price: RM'.tr}${queryLot.privatePassModel?.price ?? ''}',
          subTitle: 'New User Pass'.tr,
          onPressConfirm: () {
            isConfirmed = true;
            Navigator.pop(context, true);
          },
          onPressConfirmBtnName: "Buy Pass".tr,
          onPressConfirmColor: AppColors.green04,
          onPressCancel: () {
            Navigator.pop(context, false);
          },
          onPressCancelColor: AppColors.darkGrey01,
          onPressCancelBtnName: "Cancel".tr,
        );
      },
    ).then((value) => isConfirmed = value ?? false);
    return isConfirmed;
  }

  _showImagePickerOptions(
      BuildContext context, PurchasePassPrivateController controller) {
    bool uploading =
        false; // Indicator to track whether image upload is in progress

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(28, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select".tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppThemData.semiBold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                setState(() {
                                  uploading =
                                      true; // Set uploading indicator to true
                                });
                                await controller.pickFile(
                                    source: ImageSource.camera);
                                setState(() {
                                  uploading =
                                      false; // Set uploading indicator to false when upload is completed
                                });
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 32,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "camera".tr,
                                style: const TextStyle(
                                    fontFamily: AppThemData.regular),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                setState(() {
                                  uploading =
                                      true; // Set uploading indicator to true
                                });
                                await controller.pickFile(
                                    source: ImageSource.gallery);
                                setState(() {
                                  uploading =
                                      false; // Set uploading indicator to false when upload is completed
                                });
                              },
                              icon: const Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "gallery".tr,
                                style: const TextStyle(
                                    fontFamily: AppThemData.regular),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (uploading) // Show loading indicator if uploading is in progress
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
