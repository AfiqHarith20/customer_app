// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/booking_model.dart';
import 'package:customer_app/app/models/commercepay/auth_model.dart';
import 'package:customer_app/app/models/commercepay/online_payment_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/owner_model.dart';
import 'package:customer_app/app/models/payment/stripe_failed_model.dart';
import 'package:customer_app/app/models/payment_method_model.dart';
import 'package:customer_app/app/models/wallet_transaction_model.dart';
import 'package:customer_app/app/models/watchman_model.dart';
import 'package:customer_app/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/send_notification.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/server.dart';

class SelectPaymentScreenController extends GetxController {
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<OnlinePaymentModel> onlinePaymentModel = OnlinePaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  RxBool isPaymentCompleted = true.obs;
  RxBool isLoading = true.obs;
  AuthResultModel authResultModel = AuthResultModel();
  Server server = Server();
  late TabController tabController;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    final bankName = Get.arguments?['bankName'] ?? "Default Bank Name";
    dynamic argumentData = Get.arguments;
    if (argumentData != null && argumentData['purchasePassModel'] != null) {
      purchasePassModel.value = argumentData['purchasePassModel'];
      getPaymentData();
    } else {
      // Handle the case where purchasePassModel is null
      // For example, show an error message or navigate back
      ShowToastDialog.showToast("Error: Purchase pass data is missing");
    }
  }

  getPaymentData() async {
    isLoading.value = true;
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
        Stripe.publishableKey =
            paymentModel.value.strip!.clientpublishableKey.toString();
        log(paymentModel.value.strip!.clientpublishableKey.toString());
        Stripe.merchantIdentifier = 'NAZIFA Customer';
        Stripe.instance.applySettings();
        initPayPal();
      }
    });

    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        customerModel.value = value;
      }
    });
    isLoading.value = false;

    update();
  }

  // double calculateAmount() {
  //   RxString taxAmount = "0.0".obs;
  //   if (bookingModel.value.taxList != null) {
  //     for (var element in bookingModel.value.taxList!) {
  //       taxAmount.value = (double.parse(taxAmount.value) +
  //               Constant().calculateTax(
  //                   amount: (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(),
  //                   taxModel: element))
  //           .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
  //     }
  //   }
  //   return (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())) + double.parse(taxAmount.value);
  // }
  //
  completeOrder() async {
    purchasePassModel.value.paymentType = selectedPaymentMethod.value;
    await FireStoreUtils.setPurchasePass(purchasePassModel.value).then((value) {
      Get.back();
      Get.toNamed(Routes.DASHBOARD_SCREEN);
      ShowToastDialog.showToast("Season pass purchase successfully");
    });
  }

  void onlinePayment({
    required String customerId,
    required String selectedBankName,
    required String providerChannelId,
    required String selectedPassId,
    required String fullName,
    required String email,
    required String address,
    required String identificationNo,
    required String mobileNumber,
    required String vehicleNo,
    required String lotNo,
    required String companyRegistrationNo,
    required String companyName,
    required double totalPrice,
    required String userName,
    required String identificationType,
    String channelId = '2', // Default value for channelId
  }) async {
    try {
      // Construct the JSON body using data from various sources
      final body = {
        'accessToken': selectedBankName,
        'customerId': customerId,
        'channelId': channelId,
        'providerChannelId': providerChannelId,
        'amount': totalPrice,
        'address': address,
        'companyName': companyName,
        'companyRegistrationNo': companyRegistrationNo,
        'endDate': 'end_date', // Placeholder value for endDate
        'startDate': 'start_date', // Placeholder value for startDate
        'name': fullName,
        'email': email,
        'mobileNumber': mobileNumber,
        'username': userName,
        'identificationNo': identificationNo,
        'identificationType': identificationType,
        'lotNo': lotNo,
        'vehicleNo': vehicleNo,
        'passId': selectedPassId,
      };

      // Send the POST request with the constructed body
      final response = await server.postRequest(
        endPoint: APIList.payment,
        body: body,
      );

      if (response != null && response.statusCode == 200) {
        // Handle response data as needed
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    } finally {
      isLoading.value = false;
    }
  }

  void commercepayMakePayment({required String amount}) async {
    log(double.parse(amount).toStringAsFixed(0));
    isLoading.value = true;
    try {
      await server.postRequest(endPoint: APIList.auth).then((response) {
        if (response != null && response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          authResultModel = AuthResultModel.fromJson(jsonResponse);
          // Set the access token
          Preferences.setString(
              "AccessToken", authResultModel.accessToken.toString());
          // Print the access token
          print("Access Token: ${authResultModel.accessToken}");

          DateTime time = DateTime.now();
          time.add(Duration(seconds: authResultModel.expireInSeconds as int));
          Preferences.setString("TokenExpiry", time.toString());
        } else {}
      });
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stripeMakePayment({required String amount}) async {
    log(double.parse(amount).toStringAsFixed(0));
    try {
      Map<String, dynamic>? paymentIntentData =
          await createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        ShowToastDialog.showToast(
            "Something went wrong, please contact admin.");
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData['client_secret'],
                allowsDelayedPaymentMethods: false,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'MY',
                  testEnv: true,
                  currencyCode: "MYR",
                ),
                style: ThemeMode.system,
                appearance: const PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    primary: AppColors.yellow04,
                  ),
                ),
                merchantDisplayName: 'NAZIFA Customer'));
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowToastDialog.showToast("Payment successfully");
        completeOrder();
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": customerModel.value.fullName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      log(paymentModel.value.strip!.stripeSecret.toString());
      var stripeSecret = paymentModel.value.strip!.stripeSecret;
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  void initPayPal() async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode =
        paymentModel.value.paypal!.isSandbox == true ? true : false;

    //initiate payPal plugin
    await _flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: "com.terasoft.nazifaparking://paypalpay",
      //client id from developer dashboard
      clientID: paymentModel.value.paypal!.paypalClient.toString(),
      //sandbox, staging, live etc
      payPalEnvironment: paymentModel.value.paypal!.isSandbox == true
          ? FPayPalEnvironment.sandbox
          : FPayPalEnvironment.live,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          //user canceled the payment
          ShowToastDialog.showToast("Payment canceled");
        },
        onSuccess: (data) {
          //successfully paid
          //remove all items from queue
          _flutterPaypalNativePlugin.removeAllPurchaseItems();
          String visitor = data.cart?.shippingAddress?.firstName ?? 'Visitor';
          String address =
              data.cart?.shippingAddress?.line1 ?? 'Unknown Address';
          ShowToastDialog.showToast("Payment Successfully");
          completeOrder();
        },
        onError: (data) {
          //an error occured
          ShowToastDialog.showToast("error: ${data.reason}");
        },
        onShippingChange: (data) {
          //the user updated the shipping address
          ShowToastDialog.showToast(
              "shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
        },
      ),
    );
  }

  paypalPaymentSheet(String amount) {
    //add 1 item to cart. Max is 4!
    if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      _flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          amount: double.parse(amount),

          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: FPayPalStrHelper.getRandomString(16),
        ),
      );
    }

    _flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
  }
}
