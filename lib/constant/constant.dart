import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/admin_commission.dart';
import 'package:customer_app/app/models/currency_model.dart';
import 'package:customer_app/app/models/language_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class Constant {
  static const String emailpassLoginType = 'email/pass';
  static const String googleLoginType = 'google';
  static const String phoneLoginType = 'phone';
  static const String appleLoginType = "apple";

  static const userPlaceHolder = 'assets/images/user_placeholder.png';

  static Position? currentLocation;
  static List<TaxModel>? taxList;
  static String? country;
  static String customerName = "";
  static AdminCommission? adminCommission;
  static CurrencyModel? currencyModel;

  static String googleMapKey = "";
  static String radius = "";
  static String serverKey = "";
  static String notificationServerKey = "";
  static String plateRecognizerApiToken = "";

  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String supportEmail = "";
  static String supportURL = "";
  static String minimumAmountToDeposit = "0";

  static const String placed = "placed";
  static const String onGoing = "onGoing";
  static const String completed = "completed";
  static const String canceled = "canceled";

  static String? referralAmount = "0";

  static Future<String> uploadUserImageToFireStorage(
      File image, String filePath, String fileName) async {
    Reference upload =
        FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<String> uploadPrivateParkImageToFireStorage(
      File image, String filePath, String fileName) async {
    Reference upload =
        FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static String getReferralCode(String firstTwoChar) {
    var rng = math.Random();
    return firstTwoChar + (rng.nextInt(9000) + 1000).toString();
  }

  static Widget showEmptyView({required String message}) {
    return Center(
      child: Text(message.tr,
          style: const TextStyle(
              fontSize: 18,
              color: AppColors.darkGrey10,
              fontFamily: AppThemData.bold)),
    );
  }

  static LanguageModel getLanguage() {
    final String user = Preferences.getString(Preferences.languageCodeKey);
    Map<String, dynamic> userMap = jsonDecode(user);
    log(userMap.toString());
    return LanguageModel.fromJson(userMap);
  }

  static String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null; // Return null if validation succeeds
  }

  bool hasValidUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static String getUuid() {
    return const Uuid().v4();
  }

  static Widget loader() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<TimeOfDay?> selectTime(context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? AppColors.yellow04
                        : AppColors.yellow04.withOpacity(0.4)),
                dayPeriodShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? AppColors.yellow04
                        : AppColors.yellow04.withOpacity(0.4)),
              ),
              colorScheme: const ColorScheme.light(
                primary: AppColors.darkGrey10, // header background color
                onPrimary: AppColors.darkGrey10, // header text color
                onSurface: AppColors.darkGrey10, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.darkGrey10, // button text color
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    return pickedTime;
  }

  static String timestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String timestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm aa').format(dateTime);
  }

  static String amountShow({required String? amount}) {
    if (amount != null && Constant.currencyModel != null) {
      if (Constant.currencyModel!.symbolAtRight == true) {
        return "${double.parse(amount).toStringAsFixed(Constant.currencyModel!.decimalDigits!)} ${Constant.currencyModel!.symbol}";
      } else {
        return "${Constant.currencyModel!.symbol} ${double.parse(amount).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
      }
    } else {
      return "Amount not available"; // Or any other default value or error handling mechanism
    }
  }

  double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.active == true) {
      if (taxModel.isFix == true) {
        taxAmount = double.parse(taxModel.value.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) *
                double.parse(taxModel.value!.toString())) /
            100;
      }
    }
    return taxAmount;
  }

  static double calculateAdminCommission(
      {String? amount, AdminCommission? adminCommission}) {
    double taxAmount = 0.0;
    if (adminCommission != null && adminCommission.active == true) {
      if (adminCommission.isFix == true) {
        taxAmount = double.parse(adminCommission.value.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) *
                double.parse(adminCommission.value!.toString())) /
            100;
      }
    }
    return taxAmount;
  }

  static String calculateReview(
      {required String? reviewCount, required String? reviewSum}) {
    if (reviewCount == "0.0" && reviewSum == "0.0") {
      return "0.0";
    }
    return (double.parse(reviewSum.toString()) /
            double.parse(reviewCount.toString()))
        .toStringAsFixed(1);
  }

  static Future<void> redirectMap(double latitude, double longitude) async {
    String mapUrl = '';
    if (Platform.isIOS) {
      mapUrl = 'https://maps.apple.com/?daddr=$latitude,$longitude';
    } else {
      mapUrl =
          'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving';
    }

    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> redirectCall(
      {required String countryCode, required String phoneNumber}) async {
    final Uri url = Uri.parse("tel:$countryCode $phoneNumber");
    if (!await launchUrl(url)) {
      throw Exception(
          'Could not launch ${Constant.supportEmail.toString()}'.tr);
    }
  }

  void launchEmailSupport() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    if (Constant.supportEmail.isNotEmpty) {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: Constant.supportEmail,
        query: encodeQueryParameters(<String, String>{
          'subject': 'Help & Support',
        }),
      );
      launchUrl(emailLaunchUri);
    } else {
      ShowToastDialog.showToast("Contact Not Available");
    }
  }
}
