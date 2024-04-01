import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../utils/fire_store_utils.dart';
import '../../../models/season_pass_model.dart';

class SeasonPassController extends GetxController {
  //TODO: Implement SeasonPassController
  RxBool isLoading = true.obs;
  // Define an observable to track the selected segment
  RxBool selectedSegment = false.obs;

  // Method to change the selected segment
  void changeSegment(bool value) {
  selectedSegment.value = value; // Convert int to bool
}

  RxList<SeasonPassModel> seasonPassList = <SeasonPassModel>[].obs;
  RxList<PrivatePassModel> privatePassList = <PrivatePassModel>[].obs;

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

    await FireStoreUtils.getPrivatePassData().then((value) {
      if (value != null) {
        
        privatePassList.value = value;
      }
    });
    isLoading.value = false;
  }


}
