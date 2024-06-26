import 'dart:io';

import 'package:customer_app/app/models/app_version_model.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/firebase_options.dart';
import 'package:customer_app/services/localization_service.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPref();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final bool shouldShowUpdateDialog = await checkForAppUpdate();

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.locale,
      translations: LocalizationService(),
      builder: (context, child) {
        if (shouldShowUpdateDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogBoxNotify(
                  imageAsset: "assets/images/certificate.png",
                  onPressConfirm: () async {
                    // Close the app when the user clicks "Ok"
                    exit(0);
                  },
                  onPressConfirmBtnName: "Ok".tr,
                  onPressConfirmColor: AppColors.red04,
                  content:
                      "Please download the latest version of the apps in Google Play Store (for Android)/ App Store (for iOS)."
                          .tr,
                  subTitle: "Update Available".tr,
                );
              },
            );
          });
        }
        return EasyLoading.init()(context, child);
      },
      title: "Nazifa Parking",
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
    ),
  );
}

Future<bool> checkForAppUpdate() async {
  print('Fetching platform info...');
  final platformInfo = await FireStoreUtils.fetchPlatformInfo();

  if (platformInfo == null) {
    print('No platform info found.');
    return false;
  }

  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;
  print('Current app version: $currentVersion');

  VersionInfo? versionInfo;
  if (Platform.isAndroid) {
    versionInfo = platformInfo.android;
    print('Checking Android version...');
  } else if (Platform.isIOS) {
    versionInfo = platformInfo.ios;
    print('Checking iOS version...');
  }

  if (versionInfo == null) {
    print('No version info found for the platform.');
    return false;
  }

  final latestVersion = versionInfo.versionName;
  final latestVersionNumber = versionInfo.versionNumber;
  print('Latest version from Firebase: $latestVersion');
  print('Latest version number from Firebase: $latestVersionNumber');

  final currentVersionNumber = int.tryParse(currentVersion.replaceAll('.', ''));
  final latestVersionInt = int.tryParse(latestVersion!.replaceAll('.', ''));

  final shouldUpdate = latestVersionInt != null &&
      currentVersionNumber != null &&
      currentVersionNumber < latestVersionInt;

  if (shouldUpdate) {
    print('App needs to be updated.');
  } else {
    print('App is up-to-date.');
  }

  return shouldUpdate;
}
