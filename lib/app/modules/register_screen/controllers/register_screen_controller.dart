// ignore_for_file: invalid_use_of_protected_member

import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterScreenController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  Rx<GlobalKey<FormState>> regformKey = GlobalKey<FormState>().obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // Clean up resources here
    emailController.value.dispose();
    passwordController.value.dispose();
    regformKey.value.currentState?.dispose();
    // Dispose any other resources

    super.dispose();
  }

  sendSignUp() async {
    ShowToastDialog.showLoader("please_wait".tr);
    String email = emailController.value.text;
    String password = passwordController.value.text;

    // Validate password length
    if (password.length < 6) {
      ShowToastDialog.showToast("Password should be at least 6 characters");
      ShowToastDialog.closeLoader();
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Close loader dialog
      ShowToastDialog.closeLoader();

      // Handle user based on whether they are new or existing
      if (userCredential.additionalUserInfo!.isNewUser) {
        // New user: navigate to information screen to complete registration
        CustomerModel customerModel = CustomerModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email,
          // fullName: userCredential.user!.displayName,
          profilePic: userCredential.user!.photoURL,
          loginType: Constant.emailpassLoginType,
        );
        Get.toNamed(Routes.INFORMATION_SCREEN,
            arguments: {"customerModel": customerModel});
      } else {
        // Existing user: check if user exists in Firestore
        bool userExists =
            await FireStoreUtils.userExistOrNot(userCredential.user!.uid);
        if (userExists) {
          // User exists in Firestore, navigate to dashboard screen
          Get.offAllNamed(Routes.DASHBOARD_SCREEN);
        } else {
          // User does not exist in Firestore, navigate to information screen to complete registration
          CustomerModel customerModel = CustomerModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email,
            // fullName: userCredential.user!.displayName,
            profilePic: userCredential.user!.photoURL,
            loginType: Constant.emailpassLoginType,
          );
          Get.toNamed(Routes.INFORMATION_SCREEN,
              arguments: {"customerModel": customerModel});
        }
      }
    } catch (e) {
      // Handle sign-up failure
      print("Sign-up failed: $e");
      ShowToastDialog.closeLoader();
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          ShowToastDialog.showToast(
              "Email is already in use. Please use a different email.");
        } else {
          ShowToastDialog.showToast("Something went wrong. Please try again.");
        }
      } else {
        ShowToastDialog.showToast("Something went wrong. Please try again.");
      }
    }
  }
}
