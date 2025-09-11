import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/cart_model.dart';
import 'package:customer_app/app/models/my_payment_compound_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';
import 'package:customer_app/app/models/payment_method_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList<CartModel> cartItemList = <CartModel>[].obs;
  RxBool isLoading = false.obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  Rx<MyPurchasePassPrivateModel> purchaseReservedLotModel =
      MyPurchasePassPrivateModel().obs;
  Rx<MyPaymentCompoundModel> myPaymentCompoundModel =
      MyPaymentCompoundModel().obs;

  var selectedCartItems = <CartModel>[].obs;
  Server server = Server();
  Rx<TaxModel> taxModel = TaxModel().obs;
  var cartItemCount = 0.obs; // This will react to changes in cartItemList

  @override
  void onInit() {
    super.onInit();
    // Fetch cart data when the controller initializes
    getCartData();
  }

  @override
  void onReady() {
    super.onReady();
    // Listen to changes in cartItemList and update cartItemCount accordingly
    ever(cartItemList, (_) {
      cartItemCount.value = cartItemList.length;
    });
  }

  // Method to clear selected cart items
  void clearSelectedCartItems() {
    selectedCartItems.clear();
  }

  // Method to select all cart items
  void selectAllCartItems() {
    selectedCartItems.clear();
    selectedCartItems.addAll(cartItemList);
  }

  // Existing methods like addToSelectedCartItems, removeFromSelectedCartItems
  void addToSelectedCartItems(CartModel item) {
    selectedCartItems.add(item);
  }

  void removeFromSelectedCartItems(CartModel item) {
    selectedCartItems.remove(item);
  }

  // Refresh cart items and make the list reactive
  Future<void> refreshCartItems() async {
    isLoading.value = true;
    try {
      List<CartModel> items = await FireStoreUtils.getCartItems();
      cartItemList.assignAll(items); // Assign all fetched items to cartItemList

      // Update dates for items with status 0
      await updateSeasonCartDates();
      // await updateReservedCartDates();
    } catch (e) {
      print("Error refreshing cart items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCartData() async {
    isLoading.value = true;
    try {
      List<CartModel> items = await FireStoreUtils.getCartItems();
      cartItemList.assignAll(items);

      // Update dates for items with status 0
      await updateSeasonCartDates();
      // await updateReservedCartDates();
    } catch (e) {
      log("Error fetching cart data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch cart data from Firebase or any other API
  // Future<void> getCartData() async {
  //   isLoading.value = true;
  //   try {
  //     List<CartModel> items = await FireStoreUtils.getCartItems();
  //     cartItemList.assignAll(items); // Assign all fetched items to cartItemList
  //   } catch (e) {
  //     log("Error fetching cart data: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Update cart item count whenever cartItemList changes

  Future<void> deleteCartItem(CartModel cartItem) async {
    isLoading.value = true;
    try {
      bool success = await FireStoreUtils.deleteCart(cartItem);
      if (success) {
        cartItemList.remove(cartItem); // Remove the item from the reactive list
        // cartItemCount will be updated automatically due to 'ever' listener
        ShowToastDialog.showToast(
            "Item removed from cart".tr); // Optional: Show success toast
      } else {
        Get.snackbar(
          'Error'.tr,
          'Failed to remove item from cart'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red04,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Error deleting cart item: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSelectedCartItems() async {
    isLoading.value = true;
    try {
      // Create a list to hold the results of delete operations
      List<bool> results = [];

      // Loop through the selected cart items
      for (CartModel cartItem in selectedCartItems) {
        // Attempt to delete the item from Firestore
        bool success = await FireStoreUtils.deleteCart(cartItem);
        results.add(success); // Store the result of each delete operation

        if (success) {
          // If successful, remove the item from the reactive list
          cartItemList.remove(cartItem);
        }
      }

      // Check if all deletions were successful
      if (results.every((result) => result)) {
        ShowToastDialog.showToast("All selected items removed from cart".tr);
      } else {
        Get.snackbar(
          'Error'.tr,
          'Some items failed to remove from cart'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red04,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Error deleting selected cart items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSeasonCartDates() async {
    DateTime now = DateTime.now(); // Get the current date and time

    for (var cartItem in cartItemList) {
      if (cartItem.status == 0) {
        // Check if the item is still in the cart (not yet checked out)
        var purchasePass = cartItem.purchasePassModel;

        // Calculate duration based on the season pass validity
        int durationInDays =
            checkDuration(purchasePass!.seasonPassModel!.validity.toString());

        // Set the end date to the calculated duration with time set to 23:59
        DateTime endDate =
            DateTime(now.year, now.month, now.day + durationInDays);

        // Update startDate and endDate
        purchasePass.startDate = Timestamp.fromDate(now);
        purchasePass.endDate = Timestamp.fromDate(endDate);

        // Save the updated cart item back to Firestore
        await FireStoreUtils.updateCart(cartItem);
      }
    }
  }

  // Future<void> updateReservedCartDates() async {
  //   DateTime now = DateTime.now(); // Get the current date and time

  //   for (var cartItem in cartItemList) {
  //     if (cartItem.status == 0) {
  //       // Check if the item is still in the cart (not yet checked out)
  //       var purchaseReserved = cartItem.purchaseReservedLotModel;

  //       // Calculate duration based on the season pass validity
  //       int durationInDays = checkDuration(
  //           purchaseReserved!.privatePassModel!.validity.toString());

  //       // Set the end date to the calculated duration with time set to 23:59
  //       DateTime endDate =
  //           DateTime(now.year, now.month, now.day + durationInDays, 23, 59);

  //       // Update startDate and endDate
  //       purchaseReserved.startDate = now;
  //       purchaseReserved.endDate = endDate;

  //       // Save the updated cart item back to Firestore
  //       await FireStoreUtils.updateCart(cartItem);
  //     }
  //   }
  // }

  checkDuration(String time) {
    if (time == "1 Week") {
      return 6;
    } else if (time == "2 Weeks") {
      return 13;
    } else if (time == "3 Weeks") {
      return 20;
    } else if (time == "1 Month") {
      return 29;
    } else if (time == "3 Months") {
      return 89;
    } else if (time == "6 Months") {
      return 179;
    } else if (time == "12 Months") {
      return 364;
    }
    return 0;
  }
}
