import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:get/get.dart';

import '../../../../utils/fire_store_utils.dart';

class MySeasonPassController extends GetxController {
  //TODO: Implement MySeasonPassController
  RxBool selectedSegment = false.obs;
  RxBool isLoading = true.obs;
  RxList<MyPurchasePassModel> mySeasonPassList = <MyPurchasePassModel>[].obs;
  RxList<PendingPassModel> pendingPassList = <PendingPassModel>[].obs;

  @override
  void onInit() {
    getMySeasonPass();
    getPendingPass();
    super.onInit();
  }

  getMySeasonPass() async {
    await FireStoreUtils.getMySeasonPassData().then((value) {
      if (value != null) {
        mySeasonPassList.value = value;
        print('----------->${mySeasonPassList.length}');
      }
    });
    isLoading.value = false;
  }

  getPendingPass() async {
    await FireStoreUtils.getPendingPassData().then((value) {
      if (value != null) {
        pendingPassList.value = value;
        print('----------->${pendingPassList.length}');
      }
    });
  }

  void changeSegment(bool value) {
    selectedSegment.value = value; // Convert int to bool
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
