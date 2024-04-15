// ignore_for_file: invalid_return_type_for_catch_error, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenController extends GetxController {
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  RxString countryCode = "+60".obs;

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
    String email = emailController.value.text;
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
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
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
    } catch (e) {
      // Handle sign-up failure
      print("Sign-in failed: $e");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Something went wrong. Please try again.");
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
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().catchError((error) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("something_went_wrong".tr);
        return null;
      });

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
    }
    return null;
    // Trigger the authentication flow
  }

  loginWithGoogle() async {
    try {
      // Show loader dialog
      ShowToastDialog.showLoader("Please Wait..".tr);

      // Sign in with Google
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Google sign-in canceled or failed
        print('Google sign-in canceled or failed');
        ShowToastDialog.closeLoader();
        return;
      }
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Close loader dialog
      ShowToastDialog.closeLoader();

      // Handle user based on whether they are new or existing
      if (userCredential.additionalUserInfo!.isNewUser) {
        // New user: navigate to information screen to complete registration
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
            fullName: userCredential.user!.displayName,
            profilePic: userCredential.user!.photoURL,
            loginType: Constant.googleLoginType,
          );
          Get.toNamed(Routes.INFORMATION_SCREEN,
              arguments: {"customerModel": customerModel});
        }
      }
    } catch (e) {
      // Handle any errors
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
    await signInWithApple().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          CustomerModel customerModel = CustomerModel();
          customerModel.id = value.user!.uid;
          customerModel.email = value.user!.email;
          customerModel.profilePic = value.user!.photoURL;
          customerModel.loginType = Constant.appleLoginType;

          ShowToastDialog.closeLoader();
          Get.toNamed(Routes.INFORMATION_SCREEN,
              arguments: {"customerModel": customerModel});
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();

            if (userExit == true) {
              CustomerModel? customerModel =
                  await FireStoreUtils.getUserProfile(value.user!.uid);
              if (customerModel != null) {
                if (customerModel.active == true) {
                  Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                } else {
                  ShowToastDialog.showToast(
                      "Unable to Log In?  Please Contact the Admin for Assistance");
                }
              }
            } else {
              CustomerModel customerModel = CustomerModel();
              customerModel.id = value.user!.uid;
              customerModel.email = value.user!.email;
              customerModel.profilePic = value.user!.photoURL;
              customerModel.loginType = Constant.googleLoginType;

              Get.toNamed(Routes.INFORMATION_SCREEN,
                  arguments: {"customerModel": customerModel});
            }
          });
        }
      }
    });
  }
}
