import 'dart:async';
import 'dart:io';

import 'package:customer_app/app/models/app_version_model.dart';
import 'package:customer_app/app/models/server_maintenance_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../models/carousel_model.dart';
import '../../../models/customer_model.dart';

class HomeController extends GetxController {
  //RxBool isLoading = false.obs;
  //Rx<TextEditingController> addressController = TextEditingController().obs;
  //RxList<ParkingModel> parkingList = <ParkingModel>[].obs;
  //Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  var box = GetStorage();
  RxBool isLoading = false.obs;
  RxList<CarouselModel> carouselData = <CarouselModel>[].obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  RxList<Map<String, dynamic>> notifyList = <Map<String, dynamic>>[].obs;

  @override
  onInit() async {
    getProfileData();
    _initializeApp();
    fetchCarousel();
    if (box.read('carouselData') != null) {
      List<dynamic>? carouselDataList = box.read('carouselData');
      if (carouselDataList != null) {
        // Convert each map to a CarouselModel
        carouselData.assignAll(
            carouselDataList.map((e) => CarouselModel.fromJson(e)).toList());
      }
    }

    super.onInit();
  }

  Future<bool> _checkForAppUpdate() async {
    final platformInfo = await FireStoreUtils.fetchPlatformInfo();

    if (platformInfo == null) {
      return false;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    VersionInfo? versionInfo;
    if (Platform.isAndroid) {
      versionInfo = platformInfo.android;
    } else if (Platform.isIOS) {
      versionInfo = platformInfo.ios;
    }

    if (versionInfo == null) {
      return false;
    }

    final latestVersion = versionInfo.versionName;
    final currentVersionNumber =
        int.tryParse(currentVersion.replaceAll('.', ''));
    final latestVersionInt = int.tryParse(latestVersion!.replaceAll('.', ''));

    return latestVersionInt != null &&
        currentVersionNumber != null &&
        currentVersionNumber < latestVersionInt;
  }

  Future<ServerMaintenanceModel?> _checkForMaintenance() async {
    final serverMaintenance = await FireStoreUtils.fetchServerMaintenance();

    if (serverMaintenance == null) {
      return null;
    }

    return serverMaintenance.active == true ? serverMaintenance : null;
  }

  void _showUpdateDialog() {
    Get.dialog(
      DialogBoxNotify(
        imageAsset: "assets/images/certificate.png",
        onPressConfirm: () async {
          exit(0); // Close the app when the user clicks "Ok"
        },
        onPressConfirmBtnName: "Ok".tr,
        onPressConfirmColor: AppColors.red04,
        content:
            "Please download the latest version of the apps in Google Play Store (for Android)/ App Store (for iOS)."
                .tr,
        subTitle: "Update Available".tr,
      ),
      barrierDismissible: false,
    );
  }

  void _showMaintenanceDialog(ServerMaintenanceModel maintenanceInfo) {
    Get.dialog(
      DialogBoxNotify(
        imageAsset: "assets/images/certificate.png",
        onPressConfirm: () async {
          exit(0); // Close the app when the user clicks "Ok"
        },
        onPressConfirmBtnName: "Ok".tr,
        onPressConfirmColor: AppColors.red04,
        content:
            "The server is currently under maintenance. Please try again later.\n\n"
                // "Maintenance Period:\n"
                // "Start: ${maintenanceInfo.startDateTime}\n"
                // "End: ${maintenanceInfo.endDateTime}"
                .tr,
        subTitle: "Maintenance".tr,
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _initializeApp() async {
    final bool shouldShowUpdateDialog = await _checkForAppUpdate();
    final ServerMaintenanceModel? maintenanceInfo =
        await _checkForMaintenance();

    if (shouldShowUpdateDialog) {
      _showUpdateDialog();
    } else if (maintenanceInfo != null) {
      _showMaintenanceDialog(maintenanceInfo);
    }
  }

  getProfileData() async {
    isLoading.value = true;
    try {
      bool isLogin = await FireStoreUtils.isLogin();
      if (isLogin) {
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
            .then((value) {
          if (value != null) {
            customerModel.value = value;
          }
        });
      } else {
        // If user is not logged in, set guest profile
        customerModel.value = CustomerModel(
          fullName: "Guest",
          countryCode: "+60",
          phoneNumber: "123456789",
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCarousel() async {
    try {
      isLoading.value = true;
      update();

      List<CarouselModel>? data = await FireStoreUtils.getCarousel();
      if (data != null) {
        carouselData.assignAll(data);
        // Store as a list of maps
        box.write('carouselData', data.map((e) => e.toJson()).toList());
      }
    } finally {
      isLoading.value = false;
      update();
      print('data fetch done');
    }
  }

  @override
  void dispose() {
    //FireStoreUtils().getNearestParkingRequestController!.close();
    super.dispose();
  }
}
