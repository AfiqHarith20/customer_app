// ignore_for_file: unused_local_variable, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/commercepay/online_payment_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/payment_method_model.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/api-list.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/server.dart';

class WebviewScreenController extends GetxController {
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<OnlinePaymentModel> onlinePaymentModel = OnlinePaymentModel().obs;
  Server server = Server();
  RxBool isLoading = true.obs;
  RxBool isFormVisible = false.obs;
  String paymentResponse = '';

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
        String identificationType =
            onlinePaymentModel.value.identificationType ?? '';
        DateTime? endDate = onlinePaymentModel.value.endDate;
        DateTime? startDate = onlinePaymentModel.value.startDate;
        await fetchPayment();
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
    };
    body.forEach((key, value) {
      // print('$key: $value');
    });

    // Convert the map to a JSON object
    final String jsonString = json.encode(body);
    // print(jsonString);

    return jsonString;
  }

  Future<String> fetchPayment() async {
    try {
      print('Fetching payment...');
      final response = await http.post(
        Uri.parse(APIList.payment.toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: getRequestBody(),
      );

      // Process the response here
      print('Payment Status Code: ${response.statusCode}');
      print('Payment Body: ${response.body}');
      print('Payment Headers: ${response.headers}');

      // Return the response body as a String
      return response.body;
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("Error occurred while making payment: $e");
      // Return an empty string or handle the error as needed
      return '';
    }
  }
}
