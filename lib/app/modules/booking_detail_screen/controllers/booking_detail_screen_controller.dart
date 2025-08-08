import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/booking_model.dart';
import 'package:customer_app/app/models/coupon_model.dart';
import 'package:customer_app/app/models/owner_model.dart';
import 'package:customer_app/app/models/watchman_model.dart';
import 'package:customer_app/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/send_notification.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BookingDetailScreenController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  Rx<CouponModel> selectedCouponModel = CouponModel().obs;

  RxDouble couponAmount = 0.0.obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      isLoading.value = false;
    }
    update();
  }

  getCoupon() async {
    if (couponCodeController.value.text.isNotEmpty) {
      ShowToastDialog.showLoader("Please wait".tr);
      await FireStoreUtils.fireStore
          .collection(CollectionName.coupon)
          .where('code', isEqualTo: couponCodeController.value.text)
          .where('active', isEqualTo: true)
          .where('expireAt', isGreaterThanOrEqualTo: Timestamp.now())
          .get()
          .then((value) {
        ShowToastDialog.closeLoader();
        if (value.docs.isNotEmpty) {
          selectedCouponModel.value = CouponModel.fromJson(value.docs.first.data());
          couponCodeController.value.text = selectedCouponModel.value.code.toString();
          if (selectedCouponModel.value.isFix == true) {
            if (double.parse(selectedCouponModel.value.minAmount.toString()) <= double.parse(bookingModel.value.subTotal.toString())) {
              couponAmount.value = double.parse(selectedCouponModel.value.amount.toString());
              ShowToastDialog.showToast("Coupon Applied".tr);
            } else {
              ShowToastDialog.showToast(
                  "Minimum Amount ${Constant.amountShow(amount: selectedCouponModel.value.minAmount.toString())} Required".tr);
            }
          } else {
            if (double.parse(selectedCouponModel.value.minAmount.toString()) <= double.parse(bookingModel.value.subTotal.toString())) {
              couponAmount.value =
                  double.parse(bookingModel.value.subTotal.toString()) * double.parse(selectedCouponModel.value.amount.toString()) / 100;

              ShowToastDialog.showToast("Coupon Applied".tr);
            } else {
              ShowToastDialog.showToast("Minimum Amount ${selectedCouponModel.value.minAmount.toString()} Required".tr);
            }
          }
        } else {
          ShowToastDialog.showToast("Coupon code is Invalid".tr);
        }
      }).catchError((error) {
        log(error.toString());
      });
    } else {
      ShowToastDialog.showToast("Please Enter coupon code".tr);
    }
  }

  applyCoupon() async {
    if (bookingModel.value.coupon != null) {
      if (bookingModel.value.coupon!.id != null) {
        if (bookingModel.value.coupon!.isFix == true) {
          couponAmount.value = double.parse(bookingModel.value.coupon!.amount.toString());
        } else {
          couponAmount.value =
              double.parse(bookingModel.value.subTotal.toString()) * double.parse(bookingModel.value.coupon!.amount.toString()) / 100;
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
                    amount: (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(),
                    taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())) + double.parse(taxAmount.value);
  }

  completeOrder() async {
    ShowToastDialog.showLoader("Please Wait");
    bookingModel.value.paymentCompleted = true;
    bookingModel.value.paymentType = "season Pass";
    bookingModel.value.adminCommission = Constant.adminCommission;
    bookingModel.value.createdAt = Timestamp.now();


    OwnerModel? receiverUserModel = await FireStoreUtils.getOwnerProfile(bookingModel.value.parkingDetails!.ownerId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": bookingModel.value.id};

    if(receiverUserModel != null){
      await SendNotification.sendOneNotification(
          token: receiverUserModel.fcmToken.toString(),
          title: 'Booking Placed',
          body:
          '${bookingModel.value.parkingDetails!.parkingName.toString()} Booking placed on ${Constant.timestampToDate(bookingModel.value.bookingDate!)}.',
          payload: playLoad);
    }


    if (Constant.timestampToDate(bookingModel.value.bookingDate!) == Constant.timestampToDate(Timestamp.now())) {

      WatchManModel? watchManModel = await FireStoreUtils.getWatchManProfile(bookingModel.value.parkingId.toString());
      if (watchManModel != null) {
        await SendNotification.sendOneNotification(
            token: watchManModel.fcmToken.toString(),
            title: 'Booking Placed',
            body:
            '${bookingModel.value.parkingDetails!.parkingName.toString()} Booking placed on ${Constant.timestampToDate(bookingModel.value.bookingDate!)}.',
            payload: playLoad);
      }
    }
    await FireStoreUtils.setOrder(bookingModel.value).then((value) async {
      if (value == true) {
        await FireStoreUtils.getFirstOrderOrNOt(bookingModel.value).then((value) async {
          if (value == true) {
            await FireStoreUtils.updateReferralAmount(bookingModel.value);
          }
        });
        ShowToastDialog.showToast("Booked");
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
        DashboardScreenController controller = Get.put(DashboardScreenController());
        controller.selectedIndex(1);
        ShowToastDialog.closeLoader();
      }
    });
  }


}
