// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart'; // Add this import

import '../../../routes/app_pages.dart';
import '../controllers/profile_screen_controller.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileScreenController>(
        init: ProfileScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: UiInterface().customAppBar(
                  backgroundColor: AppColors.lightGrey02,
                  context,
                  "My Profile".tr,
                  isBack: false),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : SingleChildScrollView(
                      child: Form(
                        key: controller.formKeyProfile.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: controller.profileImage.isEmpty
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
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                  child: Text(
                                controller.customerModel.value.fullName
                                    .toString(),
                                style: const TextStyle(
                                    fontFamily: AppThemData.bold,
                                    fontSize: 18,
                                    color: AppColors.darkGrey09),
                              )),
                              Center(
                                  child: Text(
                                controller.customerModel.value.email.toString(),
                                style: const TextStyle(
                                    fontFamily: AppThemData.regular,
                                    color: AppColors.darkGrey04),
                              )),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ButtonThem.buildButton(
                                    btnHeight: 45,
                                    btnWidthRatio: "Edit Profile".tr ==
                                            "تعديل الملف الشخصي"
                                        ? .50
                                        : .44,
                                    fontWeight: FontWeight.w500,
                                    imageAsset: "assets/icons/ic_edit_line.svg",
                                    context,
                                    title: "Edit Profile".tr,
                                    txtColor: AppColors.white,
                                    bgColor: AppColors.darkGrey10,
                                    onPress: () async {
                                      bool isLogin =
                                          await FireStoreUtils.isLogin();
                                      if (isLogin) {
                                        // User is logged in, navigate to Edit Profile
                                        Get.toNamed(Routes.EDIT_PROFILE_SCREEN,
                                            arguments: {
                                              "customerModel":
                                                  controller.customerModel.value
                                            })?.then((value) {
                                          controller.getProfileData();
                                        });
                                      } else {
                                        // User is not logged in, show the dialog
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DialogBox(
                                              imageAsset:
                                                  "assets/images/ic_log_in.png",
                                              onPressConfirm: () {
                                                // Redirect to login screen or registration
                                                Get.offAllNamed(
                                                    Routes.LOGIN_SCREEN);
                                              },
                                              onPressConfirmBtnName: "Login".tr,
                                              onPressConfirmColor:
                                                  AppColors.green04,
                                              onPressCancel: () {
                                                Get.back(); // Close dialog
                                              },
                                              content:
                                                  "Please login or register before proceeding."
                                                      .tr,
                                              onPressCancelColor:
                                                  AppColors.darkGrey01,
                                              subTitle: "Login Required".tr,
                                              onPressCancelBtnName: "Cancel".tr,
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              menuItemWidget(
                                onTap: () {
                                  Get.toNamed(Routes.LANGUAGE_SCREEN)
                                      ?.then((value) {
                                    if (value == true) {
                                      controller.getLanguage();
                                    }
                                  });
                                },
                                title: "Language".tr,
                                svgImage: "assets/icons/ic_language.svg",
                              ),
                              menuItemWidget(
                                onTap: () async {
                                  bool isLogin = await FireStoreUtils
                                      .isLogin(); // Check if user is logged in
                                  if (isLogin) {
                                    // User is logged in, navigate to the Vehicle Screen
                                    Get.toNamed(Routes.VEHICLE_SCREEN);
                                  } else {
                                    // User is not logged in, show login/register prompt dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DialogBox(
                                          imageAsset:
                                              "assets/images/ic_log_in.png",
                                          onPressConfirm: () {
                                            // Redirect to login screen
                                            Get.offAllNamed(
                                                Routes.LOGIN_SCREEN);
                                          },
                                          onPressConfirmBtnName: "Login".tr,
                                          onPressConfirmColor:
                                              AppColors.green04,
                                          onPressCancel: () {
                                            Get.back(); // Close dialog
                                          },
                                          content:
                                              "Please login or register before proceeding."
                                                  .tr,
                                          onPressCancelColor:
                                              AppColors.darkGrey01,
                                          subTitle: "Login Required".tr,
                                          onPressCancelBtnName: "Cancel".tr,
                                        );
                                      },
                                    );
                                  }
                                },
                                title: "My Vehicle".tr,
                                svgImage: "assets/icons/ic_vehicle.svg",
                              ),
                              const Divider(
                                  height: 0, color: AppColors.lightGrey05),
                              menuItemWidget(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      Constant.privacyPolicy.toString());
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                        'Could not launch ${Constant.supportURL.toString()}'
                                            .tr);
                                  }
                                },
                                title: "Privacy Policy".tr,
                                svgImage: "assets/icons/ic_privacy.svg",
                              ),
                              const Divider(
                                  height: 0, color: AppColors.lightGrey05),
                              menuItemWidget(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      Constant.termsAndConditions.toString());
                                  if (!await launchUrl(url)) {
                                    throw Exception(
                                        'Could not launch ${Constant.supportURL.toString()}'
                                            .tr);
                                  }
                                },
                                title: "Terms & Conditions".tr,
                                svgImage: "assets/icons/ic_note.svg",
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              menuItemWidget(
                                onTap: () async {
                                  Constant().launchEmailSupport();
                                },
                                title: "Support".tr,
                                svgImage: "assets/icons/ic_call.svg",
                              ),
                              const Divider(
                                  height: 0, color: AppColors.lightGrey05),
                              menuItemWidget(
                                onTap: () {
                                  Get.toNamed(Routes.CONTACT_US_SCREEN);
                                },
                                title: "Contact us".tr,
                                svgImage: "assets/icons/ic_info.svg",
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              FutureBuilder(
                                future: FireStoreUtils
                                    .isLogin(), // Future to check login status
                                builder:
                                    (context, AsyncSnapshot<bool> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a loader while checking login status
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasData &&
                                      snapshot.data == true) {
                                    // User is logged in, show the "Log Out" button
                                    return menuItemWidget(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DialogBox(
                                              imageAsset:
                                                  "assets/images/ic_log_out.png",
                                              onPressConfirm: () async {
                                                // Log out the user
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                await GoogleSignIn().signOut();
                                                // Navigate to login screen
                                                Get.offAllNamed(
                                                    Routes.LOGIN_SCREEN);
                                              },
                                              onPressConfirmBtnName:
                                                  "Log Out".tr,
                                              onPressConfirmColor:
                                                  AppColors.green04,
                                              onPressCancel: () {
                                                Get.back(); // Close the dialog
                                              },
                                              content:
                                                  "Are you sure you want to log out? You will be securely signed out of your account."
                                                      .tr,
                                              onPressCancelColor:
                                                  AppColors.darkGrey01,
                                              subTitle:
                                                  "Log Out Confirmation".tr,
                                              onPressCancelBtnName: "Cancel".tr,
                                            );
                                          },
                                        );
                                      },
                                      title: "Log Out".tr,
                                      svgImage: "assets/icons/ic_log_out.svg",
                                    );
                                  } else {
                                    // User is not logged in, show the "Login" button
                                    return menuItemWidget(
                                      onTap: () {
                                        Get.toNamed(Routes
                                            .LOGIN_SCREEN); // Navigate to login page
                                      },
                                      title: "Login".tr,
                                      svgImage:
                                          "assets/icons/ic_login.svg", // Use a relevant login icon
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              FutureBuilder(
                                future: FireStoreUtils
                                    .isLogin(), // Future to check login status
                                builder:
                                    (context, AsyncSnapshot<bool> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a loader while checking login status
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasData &&
                                      snapshot.data == true) {
                                    // User is logged in, show the "Delete Account" button
                                    return menuItemWidget(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DialogBox(
                                              imageAsset:
                                                  "assets/images/ic_delete.png",
                                              onPressConfirm: () async {
                                                await controller
                                                    .deleteUserAccount(); // Delete account logic
                                                await FirebaseAuth.instance
                                                    .signOut(); // Log out the user
                                                await GoogleSignIn()
                                                    .signOut(); // Log out Google if used
                                                // Navigate to login screen
                                                Get.offAllNamed(
                                                    Routes.LOGIN_SCREEN);
                                              },
                                              onPressConfirmBtnName:
                                                  "Delete".tr,
                                              onPressConfirmColor:
                                                  AppColors.red04,
                                              onPressCancel: () {
                                                Get.back(); // Close the dialog
                                              },
                                              content:
                                                  "Are you sure you want to Delete Account? All Information will be deleted of your account."
                                                      .tr,
                                              onPressCancelColor:
                                                  AppColors.darkGrey01,
                                              subTitle: "Delete Account".tr,
                                              onPressCancelBtnName: "Cancel".tr,
                                            );
                                          },
                                        );
                                      },
                                      title: "Delete Account".tr,
                                      svgImage: "assets/icons/ic_delete.svg",
                                    );
                                  } else {
                                    // If not logged in, return nothing or display a different widget (optional)
                                    return const SizedBox
                                        .shrink(); // Or you can show a login prompt
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text(
                                  'App Version: ${controller.appVersion.value}',
                                  style: const TextStyle(
                                    fontFamily: AppThemData.regular,
                                    fontSize: 14,
                                    color: AppColors.darkGrey04,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
        });
  }
}

Widget menuItemWidget({
  required String svgImage,
  required String title,
  required VoidCallback onTap,
}) {
  return GetBuilder<ProfileScreenController>(builder: (controller) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(
        svgImage,
        height: 30,
        width: 30,
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: AppThemData.medium,
            fontSize: 16,
            color: AppColors.darkGrey09),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.darkGrey07,
        size: 20,
      ),
    );
  });
}
