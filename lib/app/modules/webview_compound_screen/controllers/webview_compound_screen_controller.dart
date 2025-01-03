// ignore_for_file: unused_local_variable, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';

import 'package:customer_app/app/models/commercepay/online_payment_model.dart';
import 'package:customer_app/app/models/compound_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/my_payment_compound_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/payment_method_model.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/api-list.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../../utils/server.dart';

class WebviewCompoundScreenController extends GetxController {
  Rx<CompoundModel> compoundModel = CompoundModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  RxBool isFormVisible = false.obs;
  RxBool isLoading = true.obs;
  bool isPaymentFetched = false;
  Rx<MyPaymentCompoundModel> myPaymentCompoundModel =
      MyPaymentCompoundModel().obs;

  Rx<OnlinePaymentModel> onlinePaymentModel = OnlinePaymentModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  String paymentResponse = '';
  RxString paymentType = RxString('');
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  Server server = Server();

  @override
  void dispose() {
    // Perform cleanup before disposing
    cleanup();
    // Call dispose method of superclass
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
    cleanup();
  }

  @override
  void onInit() {
    super.onInit();
    // Retrieve arguments and make payment when the controller is initialized
    // fetchPayCompound();
    getArgumentandPayCompound();
  }

  Future<void> getArgumentandPayCompound() async {
    try {
      cleanup();
      // Reset isPaymentFetched to allow payment fetch
      isPaymentFetched = false;

      dynamic argumentData = Get.arguments;
      if (argumentData != null &&
          argumentData['myPaymentCompoundModel'] != null) {
        myPaymentCompoundModel.value = argumentData['myPaymentCompoundModel'];
        String customerId = myPaymentCompoundModel.value.customerId ?? '';
        String accessToken = myPaymentCompoundModel.value.accessToken ?? '';
        String providerChannelId =
            myPaymentCompoundModel.value.selectedBankId ?? '';
        String name = myPaymentCompoundModel.value.name ?? '';
        String email = myPaymentCompoundModel.value.email ?? '';
        String address = myPaymentCompoundModel.value.address ?? '';
        String identificationNo =
            myPaymentCompoundModel.value.identificationNo ?? '';
        String mobileNumber = myPaymentCompoundModel.value.mobileNumber ?? '';
        String vehicleNum = myPaymentCompoundModel.value.vehicleNum ?? '';
        String compoundNo = myPaymentCompoundModel.value.compoundNo ?? '';
        String kodHasil = myPaymentCompoundModel.value.kodHasil ?? '';
        String channelId = myPaymentCompoundModel.value.channelId ?? '';
        String amount =
            double.tryParse(myPaymentCompoundModel.value.amount ?? '')
                    ?.toStringAsFixed(2) ??
                '';
        String userName = myPaymentCompoundModel.value.userName ?? '';
        String identificationType =
            myPaymentCompoundModel.value.identificationType ?? '';
        paymentType.value = 'compound';
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  String getCompoundBody() {
    final myPaymentCompoundData = myPaymentCompoundModel.value;
    final body = {
      'accessToken': myPaymentCompoundData.accessToken ?? '',
      'customerId': myPaymentCompoundData.customerId ?? '',
      'channelId': myPaymentCompoundData.channelId ?? '',
      'providerChannelId': myPaymentCompoundData.selectedBankId ?? '',
      'amount': myPaymentCompoundData.amount?.toString() ??
          '', // Convert amount to string explicitly
      'address': myPaymentCompoundData.address ?? '',
      'name': myPaymentCompoundData.name ?? '',
      'email': myPaymentCompoundData.email ?? '',
      'mobileNumber': myPaymentCompoundData.mobileNumber ?? '',
      'username': myPaymentCompoundData.userName ?? '',
      'identificationNumber': myPaymentCompoundData.identificationNo ?? '',
      'identificationType': myPaymentCompoundData.identificationType ?? '',
      'vehicleNo': myPaymentCompoundData.vehicleNum ?? '',
      'compoundNo': myPaymentCompoundData.compoundNo ?? '',
      'kodHasil': myPaymentCompoundData.kodHasil ?? '',
    };
    body.forEach((key, value) {
      print('$key: $value');
    });

    // Convert the map to a JSON object
    final String jsonString = json.encode(body);
    // print(jsonString);

    return jsonString;
  }

  Future<WebViewResponse> fetchPayCompound() async {
    try {
      print('Fetching payment...');
      final response = await http.post(
        Uri.parse(APIList.payCompound.toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: getCompoundBody(),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the response body
        final Map<String, dynamic>? responseBody = json.decode(response.body);

        // Check if the response body is not null
        if (responseBody != null) {
          // Extract redirection type, URL, and client script
          final int redirectionType = responseBody['redirectionType'];
          final String redirectUrl = responseBody['redirectUrl'] ?? '';
          final String clientScript = responseBody['clientScript'] ?? '';

          // Handle redirection based on the type
          if (redirectionType == 1) {
            // Redirect using URL
            print('Redirecting using URL: $redirectUrl');
            // Handle redirection using URL here
          } else if (redirectionType == 2) {
            // Redirect using client script
            print('Redirecting using client script: $clientScript');
            // Handle redirection using client script here
          } else {
            print('Invalid redirection type');
            // Handle invalid redirection type here
          }

          // Return WebViewResponse object
          return WebViewResponse(
            redirectionType: redirectionType,
            redirectUrl: redirectUrl,
            clientScript: clientScript,
          );
        } else {
          // If response body is null, return an empty WebViewResponse
          return WebViewResponse(
            redirectionType: 0,
            redirectUrl: '',
            clientScript: '',
          );
        }
      } else if (response.statusCode == 500) {
        print('Server Error: ${response.statusCode}');
        ShowToastDialog.showToast("Retrying...");
        // Retry fetching payment after updating arguments
        await updateArgumentAndMakePayment();
        // Retry fetchPayment after updating arguments
        return fetchPayCompound();
      } else {
        // If response status code is not 200, handle the error
        print('Error: ${response.statusCode}');
        // Return an empty WebViewResponse
        return WebViewResponse(
          redirectionType: 0,
          redirectUrl: '',
          clientScript: '',
        );
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("Error occurred while making payment: $e");
      // If an error occurs, return an empty WebViewResponse
      return WebViewResponse(
        redirectionType: 0,
        redirectUrl: '',
        clientScript: '',
      );
    }
  }

  Future<WebViewResponse> updateArgumentAndMakePayment() async {
    // Call getArgumentAndMakePayment and then update UI if needed
    await getArgumentandPayCompound();
    return WebViewResponse(
      redirectionType: -1,
      redirectUrl: '',
      clientScript: '',
    );
  }

  void cleanup() {
    // Reset or clear any data here
    purchasePassModel.value = MyPurchasePassModel();
    myPaymentCompoundModel.value = MyPaymentCompoundModel();
    compoundModel.value = CompoundModel();
    customerModel.value = CustomerModel();
    paymentModel.value = PaymentModel();
    onlinePaymentModel.value = OnlinePaymentModel();
    isLoading.value = true;
    isFormVisible.value = false;
    paymentResponse = '';
    paymentType.value = '';
  }
}

class WebViewResponse {
  WebViewResponse({
    required this.redirectionType,
    required this.redirectUrl,
    required this.clientScript,
  });

  final String clientScript;
  final String redirectUrl;
  final int redirectionType;
}
