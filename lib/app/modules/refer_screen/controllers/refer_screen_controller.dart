import 'package:customer_app/app/models/referral_model.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class ReferScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getReferralCode();
    super.onInit();
  }

  Rx<ReferralModel> referralModel = ReferralModel().obs;
  RxBool isLoading = true.obs;

  getReferralCode() async {
    await FireStoreUtils.getReferral().then((value) {
      if (value != null) {
        referralModel.value = value;
        isLoading.value = false;
      }
    });
  }
}
