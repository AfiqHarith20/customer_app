// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:customer_app/app/widget/mobile_number_textfield.dart';
import 'package:customer_app/app/widget/text_field_prefix_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/information_screen_controller.dart';

class InformationScreenView extends GetView<InformationScreenController> {
  const InformationScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightGrey02,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset("assets/icons/ic_arrow_left.svg")),
          ),
          backgroundColor: AppColors.lightGrey02,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKeyInfo.value,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Complete Your Profile".tr,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.darkGrey10,
                        fontFamily: AppThemData.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Provide your essential details and add a profile picture to personalize your experience"
                        .tr,
                    style: const TextStyle(
                        color: AppColors.lightGrey10,
                        fontFamily: AppThemData.regular),
                  ),
                  const SizedBox(
                    height: 34,
                  ),
                  GestureDetector(
                    onTap: () {
                      buildBottomSheet(context, controller);
                    },
                    child: Obx(() => Center(
                        child: controller.profileImage.isEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  Constant.userPlaceHolder,
                                  height: Responsive.width(30, context),
                                  width: Responsive.width(30, context),
                                  fit: BoxFit.fill,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.file(
                                  File(controller.profileImage.value),
                                  height: Responsive.width(30, context),
                                  width: Responsive.width(30, context),
                                  fit: BoxFit.fill,
                                ),
                              ))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidgetPrefix(
                    validator: (value) => Constant.validateName(value),
                    prefix: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        "assets/icons/ic_user.svg",
                      ),
                    ),
                    title: "Full Name".tr,
                    hintText: "Enter Full Name".tr,
                    controller: controller.fullNameController.value,
                    onPress: () {},
                  ),
                  TextFieldWidgetPrefix(
                    validator: (value) => Constant.validateEmail(value),
                    prefix: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        "assets/icons/ic_email.svg",
                      ),
                    ),
                    title: "Email".tr,
                    hintText: "Enter Email Address".tr,
                    controller: controller.emailController.value,
                    onPress: () {},
                  ),
                  MobileNumberTextField(
                    title: "Mobile Number".tr,
                    controller: controller.phoneNumberController.value,
                    countryCode: controller.countryCode.value,
                    onPress: () {},
                  ),
                  // TextFieldWidgetPrefix(
                  //   validator: (value) => null,
                  //   prefix: Padding(
                  //     padding: const EdgeInsets.all(12.0),
                  //     child: SvgPicture.asset(
                  //       "assets/icons/ic_privacy.svg",
                  //     ),
                  //   ),
                  //   title: "Identification Card No.".tr,
                  //   hintText: "Enter Identification Card No.".tr,
                  //   controller: controller.identificationNoController.value,
                  //   onPress: () {},
                  // ),
                  // const Text(
                  //   "Select Identification Type",
                  //   style: TextStyle(
                  //     fontFamily: AppThemData.regular,
                  //     color: AppColors.darkGrey06,
                  //   ),
                  // ),
                  // Column(
                  //   children: List.generate(controller.icList.length, (index) {
                  //     return Row(
                  //       children: [
                  //         Obx(() => Radio(
                  //               activeColor: AppColors.darkGrey09,
                  //               value: controller.icList[index]["value"],
                  //               groupValue: controller.selectedIc.value,
                  //               onChanged: (value) {
                  //                 controller.selectedIc.value =
                  //                     value.toString();
                  //               },
                  //             )),
                  //         Text(
                  //           controller.icList[index]["name"]!,
                  //           style: const TextStyle(
                  //             fontFamily: AppThemData.medium,
                  //             color: AppColors.darkGrey04,
                  //             fontSize: 15,
                  //           ),
                  //         ),
                  //         const SizedBox(width: 20),
                  //       ],
                  //     );
                  //   }),
                  // ),
                  Text(
                    "Select Gender".tr,
                    style: const TextStyle(
                        fontFamily: AppThemData.regular,
                        color: AppColors.darkGrey06),
                  ),
                  Row(
                      children:
                          List.generate(controller.genderList.length, (index) {
                    return Row(
                      children: [
                        Obx(() => Radio(
                              activeColor: AppColors.darkGrey09,
                              value: controller.genderList[index],
                              groupValue: controller.selectedGender.value,
                              onChanged: (value) {
                                controller.selectedGender.value =
                                    value.toString();
                              },
                            )),
                        Text(
                          controller.genderList[index].tr,
                          style: const TextStyle(
                              fontFamily: AppThemData.medium,
                              color: AppColors.darkGrey04,
                              fontSize: 15),
                        ),
                        const SizedBox(width: 20)
                      ],
                    );
                  })),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // TextFieldWidgetPrefix(
                  //   validator: (value) => null,
                  //   prefix: Padding(
                  //     padding: const EdgeInsets.all(12.0),
                  //     child: SvgPicture.asset(
                  //       "assets/icons/ic_ticket.svg",
                  //     ),
                  //   ),
                  //   title: "Referral Code",
                  //   hintText: "Enter Referral Code ",
                  //   controller: controller.referralCodeController.value,
                  //   onPress: () {},
                  // ),
                  const SizedBox(
                    height: 33,
                  ),
                  ButtonThem.buildButton(
                    btnHeight: 56,
                    txtSize: 16,
                    context,
                    title: "Save and Continue".tr,
                    txtColor: AppColors.lightGrey01,
                    bgColor: AppColors.darkGrey10,
                    onPress: () async {
                      if (controller.formKeyInfo.value.currentState!
                          .validate()) {
                        // controller.sendEmailVerification();
                        controller.createAccount();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

buildBottomSheet(BuildContext context, InformationScreenController controller) {
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
                  child: Text("please_select".tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppThemData.semiBold,
                      )),
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
                              onPressed: () => controller.pickFile(
                                  source: ImageSource.camera),
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 32,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "camera".tr,
                              style: const TextStyle(),
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
                              onPressed: () => controller.pickFile(
                                  source: ImageSource.gallery),
                              icon: const Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "gallery".tr,
                              style: const TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// void _showEmailVerifiedDialog(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text("Email Verification"),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: const Text("OK"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
