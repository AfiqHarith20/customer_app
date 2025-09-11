import 'package:customer_app/app/models/booking_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

import '../../../models/review_model.dart';

class RateUsScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxDouble rating = 0.0.obs;

  Rx<ReviewModel> reviewModel = ReviewModel().obs;
  Rx<ParkingModel> parkingModel = ParkingModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getArgument();
  }

  Rx<BookingModel> bookingModel = BookingModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
    }
    await FireStoreUtils.getParkingDetail(bookingModel.value.parkingId.toString()).then((value) {
      if (value != null) {
        parkingModel.value = value;
      }
    });
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        customerModel.value = value;
      }
    });
    await FireStoreUtils.getReview(bookingModel.value.id.toString()).then((value) {
      if (value != null) {
        reviewModel.value = value;
        rating.value = double.parse(reviewModel.value.rating.toString());
      }
    });
    isLoading.value = false;
    update();
  }
}
