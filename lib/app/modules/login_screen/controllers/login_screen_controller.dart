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
    emailController.value.dispose();
    passwordController.value.dispose();
    loginformKey.value.currentState?.dispose();
    super.dispose();
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "email_not_found".tr;
      case 'wrong-password':
        return "incorrect_password".tr;
      case 'invalid-email':
        return "invalid_email_format".tr;
      case 'user-disabled':
        return "user_account_disabled".tr;
      case 'too-many-requests':
        return "too_many_login_attempts".tr;
      case 'network-request-failed':
        return "network_error_check_connection".tr;
      case 'operation-not-allowed':
        return "email_password_login_disabled".tr;
      default:
        return "authentication_failed".tr;
    }
  }

  sendSignIn() async {
    ShowToastDialog.showLoader("please_wait".tr);
    String email = emailController.value.text.trim();
    String password = passwordController.value.text;

    try {
      if (email.isEmpty) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("email_required".tr);
        return;
      }

      if (password.isEmpty) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("password_required".tr);
        return;
      }

      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Request timeout. Please check your connection.',
        );
      });

      ShowToastDialog.closeLoader();

      bool userExists =
          await FireStoreUtils.userExistOrNot(userCredential.user!.uid);
      if (userExists) {
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      } else {
        Get.offNamed(Routes.REGISTER_SCREEN);
      }
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      String errorMessage = _getFirebaseAuthErrorMessage(e);
      ShowToastDialog.showToast(errorMessage);
    } catch (e) {
      ShowToastDialog.closeLoader();
      if (e.toString().contains('SocketException')) {
        ShowToastDialog.showToast("network_error_check_connection".tr);
      } else {
        ShowToastDialog.showToast("something_went_wrong".tr);
      }
      debugPrint("Login error: $e");
    }
  }

  sendCode() async {
    ShowToastDialog.showLoader("please_wait".tr);
    String phoneNumber = phoneNumberController.value.text.trim();

    if (phoneNumber.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("phone_number_required".tr);
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode.value + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("FirebaseAuthException--> ${e.message}");
          ShowToastDialog.closeLoader();

          String errorMessage;
          if (e.code == 'invalid-phone-number') {
            errorMessage = "invalid_phone_number".tr;
          } else if (e.code == 'too-many-requests') {
            errorMessage = "too_many_verification_requests".tr;
          } else if (e.code == 'network-request-failed') {
            errorMessage = "network_error_check_connection".tr;
          } else {
            errorMessage = "verification_failed".tr;
          }
          ShowToastDialog.showToast(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          ShowToastDialog.closeLoader();
          Get.toNamed(Routes.OTP_SCREEN, arguments: {
            "countryCode": countryCode.value,
            "phoneNumber": phoneNumber,
            "verificationId": verificationId,
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      debugPrint("Send code error: $e");
      ShowToastDialog.closeLoader();

      if (e.toString().contains('SocketException')) {
        ShowToastDialog.showToast("network_error_check_connection".tr);
      } else if (e.toString().contains('PlatformException')) {
        ShowToastDialog.showToast("verification_service_error".tr);
      } else {
        ShowToastDialog.showToast("something_went_wrong".tr);
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().timeout(
                const Duration(seconds: 30),
                onTimeout: () => throw Exception('Google sign-in timeout'),
              );

      if (googleUser == null) {
        ShowToastDialog.showToast("google_signin_cancelled".tr);
        return null;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessage(e);
      ShowToastDialog.showToast(errorMessage);
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      if (e.toString().contains('SocketException') ||
          e.toString().contains('timeout')) {
        ShowToastDialog.showToast("network_error_check_connection".tr);
      } else {
        ShowToastDialog.showToast("google_signin_error".tr);
      }
    }
    return null;
  }

  loginWithGoogle() async {
    try {
      ShowToastDialog.showLoader("please_wait".tr);

      UserCredential? userCredential = await signInWithGoogle();
      if (userCredential == null) {
        ShowToastDialog.closeLoader();
        return;
      }

      ShowToastDialog.closeLoader();

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
      debugPrint("Google login error: $e");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("something_went_wrong".tr);
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Apple sign-in timeout'),
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint("Apple authorization error: ${e.code}");
      if (e.code == AuthorizationErrorCode.canceled) {
        ShowToastDialog.showToast("apple_signin_cancelled".tr);
      } else if (e.code == AuthorizationErrorCode.notInteractive) {
        ShowToastDialog.showToast("apple_signin_not_interactive".tr);
      } else {
        ShowToastDialog.showToast("apple_signin_error".tr);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessage(e);
      ShowToastDialog.showToast(errorMessage);
    } catch (e) {
      debugPrint("Apple sign-in error: $e");
      if (e.toString().contains('SocketException') ||
          e.toString().contains('timeout')) {
        ShowToastDialog.showToast("network_error_check_connection".tr);
      } else {
        ShowToastDialog.showToast("apple_signin_error".tr);
      }
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

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  loginWithApple() async {
    ShowToastDialog.showLoader("please_wait".tr);
    try {
      UserCredential? userCredential = await signInWithApple();
      ShowToastDialog.closeLoader();

      if (userCredential == null) {
        return;
      }

      String fcmToken = await NotificationService.getToken();

      if (userCredential.additionalUserInfo!.isNewUser) {
        String? email = userCredential.user!.email;
        String initialName = email != null ? email.split('@')[0] : 'User';

        CustomerModel customerModel = CustomerModel();
        customerModel.id = userCredential.user!.uid ?? '';
        customerModel.email = email ?? '';
        customerModel.fullName = initialName;
        customerModel.profilePic = userCredential.user!.photoURL ?? '';
        customerModel.loginType = Constant.appleLoginType;
        customerModel.countryCode = countryCode.value;
        customerModel.phoneNumber = phoneNumberController.value.text ?? '';
        customerModel.fcmToken = fcmToken ?? '';
        customerModel.gender = selectedGender.value ?? '';
        customerModel.identificationType = selectedIc.value;
        customerModel.identificationNo =
            identificationNoController.value.text ?? '';
        customerModel.createdAt = Timestamp.now();

        try {
          await FireStoreUtils.updateUser(customerModel);
          await sendEmailVerification();
          Get.offAllNamed(Routes.DASHBOARD_SCREEN);
        } catch (e) {
          debugPrint("Error creating user profile: $e");
          ShowToastDialog.showToast("failed_create_user_profile".tr);
        }
      } else {
        try {
          bool userExists =
              await FireStoreUtils.userExistOrNot(userCredential.user!.uid);

          if (userExists) {
            CustomerModel? customerModel =
                await FireStoreUtils.getUserProfile(userCredential.user!.uid);
            if (customerModel != null) {
              if (customerModel.fcmToken != fcmToken) {
                customerModel.fcmToken = fcmToken;
                await FireStoreUtils.updateUser(customerModel);
              }

              if (customerModel.active == true) {
                Get.offAllNamed(Routes.DASHBOARD_SCREEN);
              } else {
                ShowToastDialog.showToast("account_disabled_contact_admin".tr);
              }
            } else {
              ShowToastDialog.showToast("user_profile_not_found".tr);
            }
          } else {
            ShowToastDialog.showToast("user_does_not_exist".tr);
          }
        } catch (e) {
          debugPrint("Error retrieving user profile: $e");
          if (e.toString().contains('SocketException')) {
            ShowToastDialog.showToast("network_error_check_connection".tr);
          } else {
            ShowToastDialog.showToast("error_retrieving_user_profile".tr);
          }
        }
      }
    } catch (e) {
      debugPrint("Apple login error: $e");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("something_went_wrong".tr);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      String email = FirebaseAuth.instance.currentUser?.email ?? '';
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      _showEmailVerifiedSnackbar("${"verification_email_sent".tr} $email");
    } catch (e) {
      debugPrint('Error sending verification email: $e');
      ShowToastDialog.showToast('error_sending_verification_email'.tr);
    }
  }

  void _showEmailVerifiedSnackbar(String message) {
    Get.snackbar(
      "email_verification".tr,
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
