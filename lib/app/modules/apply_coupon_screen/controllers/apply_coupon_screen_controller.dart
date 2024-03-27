import 'package:customer_app/app/models/coupon_model.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class ApplyCouponScreenController extends GetxController {
  RxList<CouponModel> couponList = <CouponModel>[].obs;
  RxBool isLoading=true.obs;

  @override
  void onInit() {
    getCouponList();
    super.onInit();
  }

  getCouponList() async {
    await FireStoreUtils.getCoupon().then((value) {
      if (value != null) {
        couponList.value = value;
        isLoading.value=false;
      }
    });
  }
}
