// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:developer';

import 'package:customer_app/app/models/commercepay/transaction_fee_model.dart';
import 'package:customer_app/app/models/compound_model.dart';
import 'package:customer_app/app/models/my_payment_compound_model.dart';
import 'package:customer_app/app/models/payment/stripe_failed_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:customer_app/utils/server.dart';
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
import 'package:flutter/material.dart';

import '../../../../constant/show_toast_dialogue.dart';
import '../../../models/commercepay/auth_model.dart';
import '../../../models/customer_model.dart';
import '../../../models/payment_method_model.dart';

class PayCompoundScreenController extends GetxController {
  Rx<CompoundModel> compoundModel = CompoundModel().obs;
  Rx<MyPaymentCompoundModel> myPaymentCompoundModel =
      MyPaymentCompoundModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  RxString selectedBankId = "".obs;
  RxBool isPaymentCompleted = true.obs;
  RxBool isLoading = true.obs;
  AuthResultModel authResultModel = AuthResultModel();
  Server server = Server();
  late String _selectedBankId;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> countryCode = TextEditingController().obs;
  TaxModel? taxModel = TaxModel();
  TransactionFeeModel? transactionFeeModel = TransactionFeeModel();

  @override
  Future<void> onInit() async {
    getArgument();
    fetchTax();
    fetchTransactionFee();
    getProfileData();
    super.onInit();
  }

  @override
  void onClose() {
    cleanup();
    super.onClose();
  }

  void cleanup() {
    // Clear data or reset state

    customerModel.value = CustomerModel();
    paymentModel.value = PaymentModel();
    myPaymentCompoundModel.value = MyPaymentCompoundModel();
    selectedPaymentMethod.value = "";
    selectedBankId.value = "";
    isPaymentCompleted.value = true;
    isLoading.value = true;
    authResultModel = AuthResultModel();
    transactionFeeModel = TransactionFeeModel();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null &&
        argumentData['myPaymentCompoundModel'] != null) {
      myPaymentCompoundModel.value = argumentData['myPaymentCompoundModel'];
      getPaymentData();
    } else {
      // Handle the case where purchasePassModel is null
      // For example, show an error message or navigate back
      ShowToastDialog.showToast("Error: Purchase pass data is missing");
    }
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        customerModel.value = value;
        fullNameController.value.text = customerModel.value.fullName!;
        emailController.value.text = customerModel.value.email!;
        countryCode.value.text = customerModel.value.countryCode!;
        phoneNumberController.value.text = customerModel.value.phoneNumber!;

        isLoading.value = true;
      }
    });
  }

  PayCompoundScreenController({String? selectedBankId}) {
    _selectedBankId = selectedBankId ?? ""; // Initialize with provided value
  }

  // Update the selected bank ID
  void updateSelectedBankId(String bankId) {
    _selectedBankId = bankId;
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
    myPaymentCompoundModel.value.paymentType = selectedPaymentMethod.value;
    await FireStoreUtils.setPaymentCompound(myPaymentCompoundModel.value)
        .then((value) {
      Get.back();
      Get.toNamed(Routes.DASHBOARD_SCREEN);
      ShowToastDialog.showToast("Season pass purchase successfully");
    });
  }

  Future<String?> commercepayCompoundPayment({required String amount}) async {
    isLoading.value = true;
    try {
      final response = await server.getRequest(endPoint: APIList.auth);
      if (response != null && response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        authResultModel = AuthResultModel.fromJson(jsonResponse);
        // Set the access token
        String accessToken = authResultModel.accessToken.toString();
        // Print the access token
        // print("Access Token: $accessToken");

        DateTime time = DateTime.now();
        time.add(Duration(seconds: authResultModel.expireInSeconds as int));
        Preferences.setString(
            "AccessToken", accessToken); // Store the access token

        Preferences.setString("TokenExpiry", time.toString());

        // Return the access token
        return accessToken;
      } else {
        // Return null if there's an error
        return null;
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
      // Return null if there's an error
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

  // final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  // void initPayPal() async {
  //   //set debugMode for error logging
  //   FlutterPaypalNative.isDebugMode =
  //       paymentModel.value.paypal!.isSandbox == true ? true : false;

  //   //initiate payPal plugin
  //   await _flutterPaypalNativePlugin.init(
  //     //your app id !!! No Underscore!!! see readme.md for help
  //     returnUrl: "com.terasoft.nazifaparking://paypalpay",
  //     //client id from developer dashboard
  //     clientID: paymentModel.value.paypal!.paypalClient.toString(),
  //     //sandbox, staging, live etc
  //     payPalEnvironment: paymentModel.value.paypal!.isSandbox == true
  //         ? FPayPalEnvironment.sandbox
  //         : FPayPalEnvironment.live,
  //     //what currency do you plan to use? default is US dollars
  //     currencyCode: FPayPalCurrencyCode.usd,
  //     //action paynow?
  //     action: FPayPalUserAction.payNow,
  //   );

  //   //call backs for payment
  //   _flutterPaypalNativePlugin.setPayPalOrderCallback(
  //     callback: FPayPalOrderCallback(
  //       onCancel: () {
  //         //user canceled the payment
  //         ShowToastDialog.showToast("Payment canceled");
  //       },
  //       onSuccess: (data) {
  //         //successfully paid
  //         //remove all items from queue
  //         _flutterPaypalNativePlugin.removeAllPurchaseItems();
  //         String visitor = data.cart?.shippingAddress?.firstName ?? 'Visitor';
  //         String address =
  //             data.cart?.shippingAddress?.line1 ?? 'Unknown Address';
  //         ShowToastDialog.showToast("Payment Successfully");
  //         completeOrder();
  //       },
  //       onError: (data) {
  //         //an error occured
  //         ShowToastDialog.showToast("error: ${data.reason}");
  //       },
  //       onShippingChange: (data) {
  //         //the user updated the shipping address
  //         ShowToastDialog.showToast(
  //             "shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
  //       },
  //     ),
  //   );
  // }

  // paypalPaymentSheet(String amount) {
  //   //add 1 item to cart. Max is 4!
  //   if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
  //     _flutterPaypalNativePlugin.addPurchaseUnit(
  //       FPayPalPurchaseUnit(
  //         amount: double.parse(amount),

  //         ///please use your own algorithm for referenceId. Maybe ProductID?
  //         referenceId: FPayPalStrHelper.getRandomString(16),
  //       ),
  //     );
  //   }

  //   _flutterPaypalNativePlugin.makeOrder(
  //     action: FPayPalUserAction.payNow,
  //   );
  // }
}
