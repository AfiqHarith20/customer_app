import 'dart:io';

import 'package:customer_app/app/modules/edit_profile_screen/controllers/edit_profile_screen_controller.dart';
import 'package:customer_app/app/widget/mobile_number_textfield.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/app/widget/text_field_prefix_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreenView extends StatelessWidget {
  const EditProfileScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<EditProfileScreenController>(
      init: EditProfileScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.lightGrey02,
          appBar: UiInterface().customAppBar(
            backgroundColor: AppColors.white,
            context,
            "Edit Profile".tr,
          ),
          body: controller.isLoading.value
              ? SingleChildScrollView(
                  child: Form(
                    key: controller.formKeyEdit.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              buildBottomSheet(context, controller);
                            },
                            child: Center(
                              child: Stack(
                                children: [
                                  controller.profileImage.isEmpty
                                      ? CircleAvatar(
                                          radius: Responsive.width(20, context),
                                          backgroundImage: const AssetImage(
                                            'assets/images/user_placeholder.png',
                                          ),
                                        )
                                      : (Constant().hasValidUrl(
                                              controller.profileImage.value))
                                          ? CircleAvatar(
                                              radius:
                                                  Responsive.width(20, context),
                                              backgroundImage: NetworkImage(
                                                controller.profileImage.value,
                                              ),
                                              backgroundColor: Colors
                                                  .transparent, // Ensure the background is transparent
                                            )
                                          : CircleAvatar(
                                              radius:
                                                  Responsive.width(20, context),
                                              backgroundImage: FileImage(
                                                File(controller
                                                    .profileImage.value),
                                              ),
                                              backgroundColor: Colors
                                                  .transparent, // Ensure the background is transparent
                                            ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: SvgPicture.asset(
                                        "assets/icons/ic_camera.svg"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldWidgetPrefix(
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
                          Text(
                            "Select Gender".tr,
                            style: const TextStyle(
                                fontFamily: AppThemData.regular,
                                color: AppColors.darkGrey06),
                          ),
                          Row(
                              children: List.generate(
                                  controller.genderList.length, (index) {
                            return Row(
                              children: [
                                Obx(() => Radio(
                                      activeColor: AppColors.darkGrey09,
                                      value: controller.genderList[index],
                                      groupValue:
                                          controller.selectedGender.value,
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
                        ],
                      ),
                    ),
                  ),
                )
              : Constant.loader(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 16),
            child: ButtonThem.buildButton(
              btnHeight: 56,
              txtSize: 16,
              context,
              title: "Save".tr,
              txtColor: AppColors.lightGrey01,
              bgColor: AppColors.darkGrey10,
              onPress: () {
                if (controller.formKeyEdit.value.currentState!.validate()) {
                  controller.updateProfile();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

buildBottomSheet(BuildContext context, EditProfileScreenController controller) {
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
                              style: const TextStyle(
                                  fontFamily: AppThemData.regular),
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
