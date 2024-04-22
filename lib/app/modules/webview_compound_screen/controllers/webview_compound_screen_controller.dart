// ignore_for_file: unused_local_variable, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/server.dart';

class WebviewCompoundScreenController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    // Retrieve arguments and make payment when the controller is initialized
    getArgumentandPayCompound();
  }

  void getArgumentandPayCompound() async {
    try {
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
        String amount = myPaymentCompoundModel.value.amount.toString();
        String userName = myPaymentCompoundModel.value.userName ?? '';
        String identificationType =
            myPaymentCompoundModel.value.identificationType ?? '';
        paymentType.value = 'compound';
        await fetchPayCompound();
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
      // print('$key: $value');
    });

    // Convert the map to a JSON object
    final String jsonString = json.encode(body);
    // print(jsonString);

    return jsonString;
  }

  Future<String> fetchPayCompound() async {
    try {
      print('Fetching payment...');
      final response = await http.post(
        Uri.parse(APIList.payCompound.toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: getCompoundBody(),
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
