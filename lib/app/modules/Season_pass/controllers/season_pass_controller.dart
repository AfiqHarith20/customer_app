import 'package:get/get.dart';

import '../../../../utils/fire_store_utils.dart';
import '../../../models/season_pass_model.dart';

class SeasonPassController extends GetxController {
  //TODO: Implement SeasonPassController
  RxBool isLoading = true.obs;

  RxList<SeasonPassModel> seasonPassList = <SeasonPassModel>[].obs;

  @override
  void onInit() {
    getPurchasePass();
    super.onInit();
  }

  getPurchasePass() async {
    await FireStoreUtils.getSeasonPassData().then((value) {
      if (value != null) {
        seasonPassList.value = value;
      }
    });
    isLoading.value = false;
  }


}
