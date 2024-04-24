import 'dart:io';
import 'dart:math';

import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/app/widget/text_field_prefix_upper_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/button_theme.dart';
import '../../../../themes/common_ui.dart';
import '../../../widget/mobile_number_textfield.dart';
import '../../../widget/text_field_prefix_widget.dart';
import '../controllers/purchase_pass_private_controller.dart';

class PurchasePassPrivateView extends GetView<PurchasePassPrivateController> {
  const PurchasePassPrivateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<PurchasePassPrivateController>(
      init: PurchasePassPrivateController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.lightGrey02,
          appBar: UiInterface().customAppBar(
            backgroundColor: AppColors.white,
            context,
            "Purchase Special Pass".tr,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: controller.formKey.value,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
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
                          "assets/icons/ic_note.svg",
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
                                      color:
                                          AppColors.darkGrey04.withOpacity(0.5),
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
                                                      .privateParkImage.value),
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
                        // .
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
                        child: SvgPicture.asset(
                          "assets/icons/ic_hash.svg",
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
                        child: SvgPicture.asset(
                          "assets/icons/ic_map_redirect.svg",
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
                          "assets/icons/ic_ticket.svg",
                        ),
                      ),
                      title: "Referral".tr,
                      hintText: "Enter Referral".tr,
                      controller: controller.referenceController.value,
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
                title: "Submit".tr,
                txtColor: Colors.black,
                bgColor: AppColors.yellow04,
                onPress: () async {
                  if (controller.formKey.value.currentState!.validate()) {
                    await controller.addPrivatePassData();
                    controller.clearFormData();
                    // Show popup notification
                    Get.showSnackbar(
                      const GetSnackBar(
                        title: "Success",
                        message:
                            "Your request has been sent with status 'Pending'",
                        backgroundColor: Colors.green,
                        duration: Duration(
                            seconds: 3), // Adjust the duration as needed
                        snackPosition: SnackPosition
                            .BOTTOM, // Set snackbar position to bottom
                      ),
                    );
                    // Navigate to dashboard page
                    Get.toNamed(Routes.DASHBOARD_SCREEN);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
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
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "please_select".tr,
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
