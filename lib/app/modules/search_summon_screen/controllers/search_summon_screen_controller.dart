

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../utils/fire_store_utils.dart';
import '../../../models/compound_model.dart';
import '../../../models/wallet_transaction_model.dart';

class SearchSummonScreenController extends GetxController {
  RxList compoundList = <CompoundModel>[].obs;

  @override
  void onInit() {
    getPaymentData();
    super.onInit();
  }

  getPaymentData() async {
    await getTraction();
  }

  getTraction() async {
    await FireStoreUtils.getWalletTransaction().then((value) {
      if (value != null) {
        compoundList.value = value;
      }
    });
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
