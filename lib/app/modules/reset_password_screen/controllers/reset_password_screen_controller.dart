// ignore_for_file: use_build_context_synchronously

import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreenController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> resetformKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // Clean up resources here
    emailController.dispose();
    // Dispose any other resources

    super.dispose();
  }

  resetPassword() async {
    try {
      // ShowToastDialog.showLoader("please_wait".tr);
      String email = emailController.value.text;

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _showEmailVerifiedSnackbar("Your password reset has been sent to ".tr +
          email +
          ".Please verify password reset to confirm the reset.".tr);
    } on FirebaseAuthException catch (e) {
      print(e);

      Get.snackbar("Error reset password", e.message!);
    }
  }

  void _showEmailVerifiedSnackbar(String message) {
    Get.snackbar(
      "Reset Password".tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 7),
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16.0),
      borderRadius: 10.0,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
  }
}
