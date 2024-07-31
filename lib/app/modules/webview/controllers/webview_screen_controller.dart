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

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/server.dart';

class WebviewScreenController extends GetxController {
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  Rx<MyPaymentCompoundModel> myPaymentCompoundModel =
      MyPaymentCompoundModel().obs;
  Rx<CompoundModel> compoundModel = CompoundModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<OnlinePaymentModel> onlinePaymentModel = OnlinePaymentModel().obs;
  Server server = Server();
  RxBool isLoading = true.obs;
  RxBool isFormVisible = false.obs;
  String paymentResponse = '';
  RxString paymentType = RxString('');
  bool isPaymentFetched = false;

  // Singleton instance variable
  static final WebviewScreenController _instance =
      WebviewScreenController._privateConstructor();

  // Private constructor
  WebviewScreenController._privateConstructor();

  // Factory constructor to return the singleton instance
  factory WebviewScreenController() {
    return _instance;
  }

  @override
  void onInit() {
    super.onInit();
    // Retrieve arguments and make payment when the controller is initialized
    getArgumentAndMakePayment();
  }

  void getArgumentAndMakePayment() async {
    try {
      // Fetch the arguments
      dynamic argumentData = Get.arguments;
      if (argumentData != null && argumentData['onlinePaymentModel'] != null) {
        onlinePaymentModel.value = argumentData['onlinePaymentModel'];
        // Extract necessary data from onlinePaymentModel
        String customerId = onlinePaymentModel.value.customerId ?? '';
        String accessToken = onlinePaymentModel.value.accessToken ?? '';
        String providerChannelId =
            onlinePaymentModel.value.selectedBankId ?? '';
        String passId = onlinePaymentModel.value.selectedPassId ?? '';
        String fullName = onlinePaymentModel.value.fullName ?? '';
        String email = onlinePaymentModel.value.email ?? '';
        String address = onlinePaymentModel.value.address ?? '';
        String identificationNo =
            onlinePaymentModel.value.identificationNo ?? '';
        String mobileNumber = onlinePaymentModel.value.mobileNumber ?? '';
        String vehicleNo = onlinePaymentModel.value.vehicleNo ?? '';
        String lotNo = onlinePaymentModel.value.lotNo ?? '';
        String companyRegistrationNo =
            onlinePaymentModel.value.companyRegistrationNo ?? '';
        String companyName = onlinePaymentModel.value.companyName ?? '';
        String totalPrice = onlinePaymentModel.value.totalPrice.toString();
        String userName = onlinePaymentModel.value.userName ?? '';
        int identificationType =
            onlinePaymentModel.value.identificationType ?? 0;
        DateTime? endDate = onlinePaymentModel.value.endDate;
        DateTime? startDate = onlinePaymentModel.value.startDate;
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  String getRequestBody() {
    final onlinePaymentData = onlinePaymentModel.value;
    final body = {
      'accessToken': onlinePaymentData.accessToken ?? '',
      'customerId': onlinePaymentData.customerId ?? '',
      'channelId': onlinePaymentData.channelId ?? '',
      'providerChannelId': onlinePaymentData.selectedBankId ?? '',
      'amount': onlinePaymentData.totalPrice?.toString() ??
          '', // Convert amount to string explicitly
      'address': onlinePaymentData.address ?? '',
      'companyName': onlinePaymentData.companyName ?? '',
      'companyRegistrationNo': onlinePaymentData.companyRegistrationNo ?? '',
      'endDate': onlinePaymentData.endDate?.toString() ?? '',
      'startDate': onlinePaymentData.startDate?.toString() ?? '',
      'name': onlinePaymentData.fullName ?? '',
      'email': onlinePaymentData.email ?? '',
      'mobileNumber': onlinePaymentData.mobileNumber ?? '',
      'username': onlinePaymentData.userName ?? '',
      'identificationNumber': onlinePaymentData.identificationNo ?? '',
      'identificationType': onlinePaymentData.identificationType ?? '',
      'lotNo': onlinePaymentData.lotNo ?? '',
      'vehicleNo': onlinePaymentData.vehicleNo ?? '',
      'passId': onlinePaymentData.selectedPassId ?? '',
      'roadId': onlinePaymentData.roadId ?? '',
      'roadName': onlinePaymentData.roadName ?? '',
      'zoneId': onlinePaymentData.zoneId ?? '',
      'zoneName': onlinePaymentData.zoneName ?? '',
    };
    body.forEach((key, value) {
      print('$key: $value');
    });

    // Convert the map to a JSON object
    final String jsonString = json.encode(body);
    print(jsonString);

    return jsonString;
  }

  Future<WebViewResponse> fetchPayment() async {
    try {
      // Check if payment is already fetched
      if (isPaymentFetched) {
        // If payment is already fetched, return an empty response
        return WebViewResponse(
          redirectionType: 0,
          redirectUrl: '',
          clientScript: '',
        );
      }

      print('Fetching payment...');
      final response = await http.post(
        Uri.parse(APIList.payment.toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: getRequestBody(),
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
      } else {
        // If response status code is not 200, handle the error
        print('Error: ${response.statusCode}');
        print("Redirect: ${response.isRedirect}");
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

  @override
  void onClose() {
    super.onClose();
    cleanup();
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
    isPaymentFetched = false;
  }
}

class WebViewResponse {
  final int redirectionType;
  final String redirectUrl;
  final String clientScript;

  WebViewResponse({
    required this.redirectionType,
    required this.redirectUrl,
    required this.clientScript,
  });
}
