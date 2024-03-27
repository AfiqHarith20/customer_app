//import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
// import 'package:customer_app/app/models/customer_model.dart';
// import 'package:customer_app/app/models/season_pass_model.dart';
// import 'package:customer_app/constant/show_toast_dialogue.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import '../../../../utils/fire_store_utils.dart';
import '../../../models/my_purchase_pass_model.dart';

class QRCodeScanController extends GetxController {
//TODO: Implement MySeasonPassController

  //RxBool isLoading = true.obs;
  //RxList<MyPurchasePassModel> mySeasonPassList = <MyPurchasePassModel>[].obs;
  @override
  void onInit() {
    //getMySeasonPass();
    super.onInit();
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
}