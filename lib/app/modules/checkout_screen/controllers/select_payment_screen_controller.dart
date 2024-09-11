// ignore_for_file: depend_on_referenced_packages, unused_field

import 'dart:convert';
import 'dart:developer';

import 'package:customer_app/app/models/commercepay/auth_model.dart';
import 'package:customer_app/app/models/commercepay/online_payment_model.dart';
import 'package:customer_app/app/models/commercepay/transaction_fee_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/payment/stripe_failed_model.dart';
import 'package:customer_app/app/models/payment_method_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_paypal_native/flutter_paypal_native.dart';
// import 'package:flutter_paypal_native/models/custom/currency_code.dart';
// import 'package:flutter_paypal_native/models/custom/environment.dart';
// import 'package:flutter_paypal_native/models/custom/order_callback.dart';
// import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
// import 'package:flutter_paypal_native/models/custom/user_action.dart';
// import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/server.dart';

class SelectPaymentScreenController extends GetxController {
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  TaxModel? taxModel = TaxModel();
  Rx<OnlinePaymentModel> onlinePaymentModel = OnlinePaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  RxString selectedBankId = "".obs;
  RxBool isPaymentCompleted = true.obs;
  RxBool isLoading = true.obs;
  AuthResultModel authResultModel = AuthResultModel();
  TransactionFeeModel? transactionFeeModel = TransactionFeeModel();
  Server server = Server();
  late String _selectedBankId;
  String? passId;
  String? amount;
  RxDouble tax = RxDouble(0.0);
  Rx<String> passValidity = ''.obs;
  String? taxId;
  String? accessToken;

  @override
  Future<void> onInit() async {
    getArgument();
    fetchTax();
    fetchTransactionFee();
    await checkAuthTokenValidity();
    super.onInit();
  }

  // Future<TaxModel?> fetchTaxData() async {
  //   // Ensure that fetchTax() returns a Future<TaxModel?>
  //   return await fetchTax(id);
  // }

  @override
  void onClose() {
    cleanup();
    super.onClose();
  }

  void cleanup() {
    // Clear data or reset state
    purchasePassModel.value = MyPurchasePassModel();
    customerModel.value = CustomerModel();
    paymentModel.value = PaymentModel();
    onlinePaymentModel.value = OnlinePaymentModel();
    selectedPaymentMethod.value = "";
    selectedBankId.value = "";
    isPaymentCompleted.value = true;
    isLoading.value = true;
    // authResultModel = AuthResultModel();
    transactionFeeModel = TransactionFeeModel();
    tax = RxDouble(0.0);
    passValidity.value = '';
    taxId = null;
  }

  getArgument() async {
    final bankName = Get.arguments?['bankName'] ?? "Default Bank Name";
    dynamic argumentData = Get.arguments;
    passId = argumentData?['passId'];
    if (argumentData != null) {
      if (argumentData['purchasePassModel'] != null) {
        purchasePassModel.value = argumentData['purchasePassModel'];
      } else {
        ShowToastDialog.showToast("Error: Purchase pass data is missing");
      }

      getPaymentData();
    }
  }

  SelectPaymentScreenController({String? selectedBankId}) {
    _selectedBankId = selectedBankId ?? ""; // Initialize with provided value
  }

  // Update the selected bank ID
  void updateSelectedBankId(String bankId) {
    _selectedBankId = bankId;
  }

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
      return 181;
    } else if (time == "12 Months") {
      return 364;
    }
    return 0;
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
        // initPayPal();
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

  Future<void> fetchTax() async {
    taxModel = await FireStoreUtils.getTaxModel();
    if (taxModel != null) {
      print('Fetched tax: ${taxModel!.value}');
    }
    update(); // Notify the UI to rebuild with the fetched data
  }

  Future<void> fetchTransactionFee() async {
    transactionFeeModel = await FireStoreUtils.getTransactionFee();
    if (transactionFeeModel != null) {
      print('Fetched Transaction Fee: ${transactionFeeModel!.value}');
    }
    update(); // Notify the UI to rebuild with the fetched data
  }

  completeOrder() async {
    purchasePassModel.value.paymentType = selectedPaymentMethod.value;
    await FireStoreUtils.setPurchasePass(purchasePassModel.value).then((value) {
      Get.back();
      Get.toNamed(Routes.DASHBOARD_SCREEN);
      ShowToastDialog.showToast("Season pass purchase successfully");
    });
  }

  Future<void> checkAuthTokenValidity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedAccessToken = prefs.getString('AccessToken');
    final tokenExpiryString = prefs.getString('TokenExpiry');

    if (storedAccessToken != null && tokenExpiryString != null) {
      DateTime tokenExpiry = DateTime.parse(tokenExpiryString);

      // Check if the token is still valid and within 24 hours
      if (DateTime.now().isBefore(tokenExpiry) &&
          DateTime.now().difference(tokenExpiry).inHours < 24) {
        // Token is valid and within 24 hours, use it
        accessToken = storedAccessToken;
        authResultModel = AuthResultModel(accessToken: accessToken);
        print("Using stored access token: $accessToken");
        return;
      }
    }

    // Token is expired or older than 24 hours, fetch a new one
    accessToken = await commercepayMakePayment(
        amount: "0"); // Pass the amount or relevant value
    if (accessToken != null) {
      print("Fetched new access token: $accessToken");
    } else {
      print("Failed to fetch new access token");
    }
  }

  Future<String?> commercepayMakePayment({required String amount}) async {
    isLoading.value = true;
    try {
      final response = await server.getRequest(endPoint: APIList.auth);
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        authResultModel = AuthResultModel.fromJson(jsonResponse);
        String accessToken = authResultModel.accessToken.toString();

        DateTime tokenExpiry = DateTime.now()
            .add(Duration(seconds: authResultModel.expireInSeconds!));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("AccessToken", accessToken);
        print(accessToken);
        await prefs.setString("TokenExpiry", tokenExpiry.toIso8601String());

        return accessToken;
      } else {
        return null;
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
      return null;
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
}
