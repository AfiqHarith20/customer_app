import 'package:customer_app/app/models/season_pass_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/button_theme.dart';
import '../../../../themes/common_ui.dart';
import '../../../widget/mobile_number_textfield.dart';
import '../../../widget/text_field_prefix_widget.dart';
import '../controllers/purchase_pass_controller.dart';

class PurchasePassView extends GetView<PurchasePassController> {
  const PurchasePassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<PurchasePassController>(
        init: PurchasePassController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(
              backgroundColor: AppColors.white,
              context,
              "Purchase Pass".tr,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: controller.formKey.value,
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
                      // DropdownButtonFormField<SeasonPassModel>(
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
                      //     items: controller.seasonPassList.map((item) {
                      //       return DropdownMenuItem<SeasonPassModel>(
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
                      TextFieldWidgetPrefix(
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
                        onPress: () {},
                        textCapitalization: TextCapitalization.characters,
                      ),
                      // TextFieldWidgetPrefix(
                      //   prefix: Padding(
                      //     padding: const EdgeInsets.all(12.0),
                      //     child: SvgPicture.asset(
                      //       "assets/icons/ic_note.svg",
                      //     ),
                      //   ),
                      //   title: "Lot No.".tr,
                      //   hintText: "Enter Lot No.".tr,
                      //   controller: controller.lotNoController.value,
                      //   onPress: () {},
                      // ),
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
                          child: SvgPicture.asset(
                            "assets/icons/ic_hash.svg",
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
                          child: SvgPicture.asset(
                            "assets/icons/ic_map_redirect.svg",
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
                    title: "Submit".tr,
                    txtColor: Colors.black,
                    bgColor: AppColors.yellow04,
                    onPress: () async {
                      if (controller.formKey.value.currentState!.validate()) {
                        await controller.addSeasonPassData();
                        Get.toNamed(Routes.SELECT_PAYMENT_SCREEN, arguments: {
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
