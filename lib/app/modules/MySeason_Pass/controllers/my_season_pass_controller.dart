import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:get/get.dart';

import '../../../../utils/fire_store_utils.dart';


class MySeasonPassController extends GetxController {
  //TODO: Implement MySeasonPassController

  RxBool isLoading = true.obs;
  RxList<MyPurchasePassModel> mySeasonPassList = <MyPurchasePassModel>[].obs;
  @override
  void onInit() {
    getMySeasonPass();
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
