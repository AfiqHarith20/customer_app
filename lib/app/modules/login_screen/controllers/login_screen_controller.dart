// ignore_for_file: invalid_return_type_for_catch_error, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenController extends GetxController {
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> identificationNoController =
      TextEditingController().obs;
  RxString countryCode = "+60".obs;
  RxString selectedGender = "".obs;
  RxString selectedIc = "1".obs;

  Rx<GlobalKey<FormState>> loginformKey = GlobalKey<FormState>().obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // Clean up resources here
    emailController.value.dispose();
    passwordController.value.dispose();
    loginformKey.value.currentState?.dispose();
    // Dispose any other resources

    super.dispose();
  }

  sendSignIn() async {
    ShowToastDialog.showLoader("please_wait".tr);
    String email = emailController.value.text.trim();
    String password = passwordController.value.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Close loader dialog
      ShowToastDialog.closeLoader();

      // Existing user: check if user exists in Firestore
      bool userExists =
          await FireStoreUtils.userExistOrNot(userCredential.user!.uid);
      if (userExists) {
        // User exists in Firestore, navigate to dashboard screen
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      } else {
        Get.offNamed(Routes.REGISTER_SCREEN);
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign-in failure
      print("Sign-in failed: $e");
      ShowToastDialog.closeLoader();
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Invalid email or password
        errorMessage = "Invalid email or password. Please try again.";
      } else {
        // Other error, show generic message
        errorMessage = "Something went wrong. Please try again.";
      }
      ShowToastDialog.showToast(errorMessage);
    }
  }

  sendCode() async {
    ShowToastDialog.showLoader("please_wait".tr);
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: countryCode.value + phoneNumberController.value.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("FirebaseAuthException--->${e.message}");
        ShowToastDialog.closeLoader();
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("invalid_phone_number".tr);
        } else {
          ShowToastDialog.showToast(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();
        Get.toNamed(Routes.OTP_SCREEN, arguments: {
          "countryCode": countryCode.value,
          "phoneNumber": phoneNumberController.value.text,
          "verificationId": verificationId,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("multiple_time_request".tr);
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
      ShowToastDialog.showToast("Error signing in with Google: $e");
    }
    return null;
  }

  loginWithGoogle() async {
    try {
      // Show loader dialog
      ShowToastDialog.showLoader("Please Wait..".tr);

      // Attempt Google sign-in
      UserCredential? userCredential = await signInWithGoogle();
      if (userCredential == null) {
        print("Google sign-in canceled or failed.");
        ShowToastDialog.closeLoader();
        return;
      }

      // Close loader dialog
      ShowToastDialog.closeLoader();

      // Handle user based on whether they are new or existing
      if (userCredential.additionalUserInfo!.isNewUser) {
        CustomerModel customerModel = CustomerModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email,
          fullName: userCredential.user!.displayName,
          profilePic: userCredential.user!.photoURL,
          loginType: Constant.googleLoginType,
        );
        Get.toNamed(Routes.INFORMATION_SCREEN,
            arguments: {"customerModel": customerModel});
      } else {
        bool userExists =
            await FireStoreUtils.userExistOrNot(userCredential.user!.uid);
        if (userExists) {
          Get.offAllNamed(Routes.DASHBOARD_SCREEN);
        } else {
          CustomerModel customerModel = CustomerModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email,
            fullName: userCredential.user!.displayName,
            profilePic: userCredential.user!.photoURL,
            loginType: Constant.googleLoginType,
          );
          Get.toNamed(Routes.INFORMATION_SCREEN,
              arguments: {"customerModel": customerModel});
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Something went wrong. Please try again.");
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
        nonce: nonce,
      ).catchError((error) {
        debugPrint("catchError--->$error");
        ShowToastDialog.closeLoader();
        return null;
      });

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  loginWithApple() async {
    ShowToastDialog.showLoader("please_wait".tr);
    await signInWithApple().then((value) async {
      ShowToastDialog.closeLoader();
      if (value != null) {
        String fcmToken = await NotificationService.getToken();

        if (value.additionalUserInfo!.isNewUser) {
          String? email = value.user!.email;
          String initialName = email != null ? email.split('@')[0] : 'User';

          CustomerModel customerModel = CustomerModel();
          customerModel.id = value.user!.uid ?? '';
          customerModel.email = email ?? '';
          customerModel.fullName = initialName;
          customerModel.profilePic = value.user!.photoURL ?? '';
          customerModel.loginType = Constant.appleLoginType;
          customerModel.countryCode = countryCode.value;
          customerModel.phoneNumber = phoneNumberController.value.text ?? '';
          customerModel.fcmToken = fcmToken ?? '';
          customerModel.gender = selectedGender.value ?? '';
          customerModel.identificationType = selectedIc.value;
          customerModel.identificationNo =
              identificationNoController.value.text ?? '';
          customerModel.createdAt = Timestamp.now();

          // Update user information in Firestore
          await FireStoreUtils.updateUser(customerModel).then((success) async {
            if (success) {
              // Send email verification
              await sendEmailVerification();
              Get.offAllNamed(Routes.DASHBOARD_SCREEN);
            } else {
              ShowToastDialog.showToast(
                  "Failed to create user. Please try again.");
            }
          });
        } else {
          // User already exists, check if it exists in Firestore
          FireStoreUtils.userExistOrNot(value.user!.uid)
              .then((userExists) async {
            if (userExists == true) {
              // User exists in Firestore, retrieve user profile
              CustomerModel? customerModel =
                  await FireStoreUtils.getUserProfile(value.user!.uid);
              if (customerModel != null) {
                // Update FCM token if needed
                if (customerModel.fcmToken != fcmToken) {
                  customerModel.fcmToken = fcmToken;
                  await FireStoreUtils.updateUser(customerModel);
                }

                if (customerModel.active == true) {
                  Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                } else {
                  ShowToastDialog.showToast(
                      "Unable to Log In? Please Contact the Admin for Assistance");
                }
              }
            } else {
              // User does not exist, this should not happen in the Apple sign-in flow
              ShowToastDialog.showToast(
                  "User does not exist. Please try again.");
            }
          });
        }
      }
    });
  }

  Future<void> sendEmailVerification() async {
    try {
      String email = FirebaseAuth.instance.currentUser?.email ?? '';
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      _showEmailVerifiedSnackbar("A verification email has been sent to ".tr +
          email +
          ". Please verify your email to make sure you can make any transaction."
              .tr);
    } catch (error) {
      print('Error sending verification email: $error');
      ShowToastDialog.showToast('Error sending verification email');
    }
  }

  void _showEmailVerifiedSnackbar(String message) {
    Get.snackbar(
      "Email Verification".tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 8),
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16.0),
      borderRadius: 10.0,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
  }
}
