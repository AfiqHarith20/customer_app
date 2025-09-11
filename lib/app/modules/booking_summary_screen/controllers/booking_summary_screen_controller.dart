import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/booking_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/review_model.dart';
import 'package:customer_app/app/models/wallet_transaction_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class BookingSummaryScreenController extends GetxController {
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<ReviewModel> reviewModel = ReviewModel().obs;
  RxDouble rating = 0.0.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      await getData();
    }



    update();
  }

  getData() async {
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
  }

  RxDouble couponAmount = 0.0.obs;

  applyCoupon() async {
    if (bookingModel.value.coupon != null) {
      if (bookingModel.value.coupon!.id != null) {
        if (bookingModel.value.coupon!.isFix == true) {
          couponAmount.value = double.parse(bookingModel.value.coupon!.amount.toString());
        } else {
          couponAmount.value = double.parse(bookingModel.value.subTotal.toString()) *
              double.parse(bookingModel.value.coupon!.amount.toString()) /
              100;
        }
      }
    }
  }

  double calculateAmount() {
    applyCoupon();
    RxString taxAmount = "0.0".obs;
    if (bookingModel.value.taxList != null) {
      for (var element in bookingModel.value.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) +
                Constant().calculateTax(
                    amount:
                        (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString()))
                            .toString(),
                    taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())) +
        double.parse(taxAmount.value);
  }

  canceledOrderWallet() async {
    WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: calculateAmount().toString(),
        createdDate: Timestamp.now(),
        paymentType: "Wallet",
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: FireStoreUtils.getCurrentUid(),
        type: "customer",
        isCredit: true,
        note: "Refund Fees");

    await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateUserWallet(amount: calculateAmount().toString());
      }
    });

    WalletTransactionModel transactionParkingModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: "-${calculateAmount().toString()}",
        createdDate: Timestamp.now(),
        paymentType: "Wallet",
        transactionId: bookingModel.value.id,
        isCredit: false,
        parkingId: bookingModel.value.parkingDetails!.id.toString(),
        userId: bookingModel.value.parkingDetails!.ownerId.toString(),
        note: "Parking fees revers");

    await FireStoreUtils.setWalletTransaction(transactionParkingModel).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateOtherUserWallet(
            amount: "-${calculateAmount().toString()}", id: bookingModel.value.parkingDetails!.ownerId.toString());
      }
    });

    WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
        id: Constant.getUuid(),
        amount:
            "${Constant.calculateAdminCommission(amount: (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(), adminCommission: bookingModel.value.adminCommission)}",
        createdDate: Timestamp.now(),
        paymentType: "Wallet",
        transactionId: bookingModel.value.id,
        isCredit: true,
        parkingId: bookingModel.value.parkingDetails!.id.toString(),
        userId: bookingModel.value.parkingDetails!.ownerId.toString(),
        note: "Admin commission fees revers");

    await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateOtherUserWallet(
            amount:
                "${Constant.calculateAdminCommission(amount: (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(), adminCommission: bookingModel.value.adminCommission)}",
            id: bookingModel.value.parkingDetails!.ownerId.toString());
      }
    });
  }
}
