//import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
// import 'package:customer_app/app/models/customer_model.dart';
// import 'package:customer_app/app/models/season_pass_model.dart';
// import 'package:customer_app/constant/show_toast_dialogue.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:customer_app/app/models/compound_model.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import '../../../../utils/fire_store_utils.dart';
import '../../../models/my_purchase_pass_model.dart';

class QRCodeScanController extends GetxController {
//TODO: Implement MySeasonPassController

  RxBool isLoading = true.obs;
  RxString scanCompoundNo = "".obs;
  List<CompoundModel> compoundList = <CompoundModel>[].obs;

  //RxList<MyPurchasePassModel> mySeasonPassList = <MyPurchasePassModel>[].obs;
  @override
  void onInit() {
    //getMySeasonPass();
    super.onInit();
  }

  void updateCompoundList(List<CompoundModel> compounds) {
    compoundList.assignAll(compounds);
  }

  // Method to handle the scanned QR code data
  void handleScannedData(String compoundNumber) async {
    // Set loading state to true
    // You can uncomment this if you need to handle loading state
    isLoading.value = true;

    try {
      // Perform the search using the compound number
      // Replace the search logic with your actual implementation
      // For example, you can call a method to search for the compound number
      // and update the UI accordingly
      // await searchForCompound(compoundNumber);

      // Placeholder logic
      print('Scanned compound number: $compoundNumber');

      // Show a toast message indicating that the QR code has been scanned successfully
      ShowToastDialog.showToast('Scanned compound number: $compoundNumber');
    } catch (e) {
      // Handle any errors that occur during the search
      print('Error handling scanned data: $e');
    } finally {
      // Set loading state back to false after handling the scanned data
      // You can uncomment this if you need to handle loading state
      isLoading.value = false;
    }
  }

  // getMySeasonPass() async {
  //   await FireStoreUtils.getMySeasonPassData().then((value) {
  //     if (value != null) {
  //       mySeasonPassList.value = value;
  //       print('----------->${mySeasonPassList.length}');
  //     }
  //   });
  //   isLoading.value = false;
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void handleScannedDataAndNavigate(String compoundNumber) {
    // Handle scanned data here

    // Navigate back to the previous screen with the compound number data
    Get.back(result: {'compoundNumber': compoundNumber});
  }
}
