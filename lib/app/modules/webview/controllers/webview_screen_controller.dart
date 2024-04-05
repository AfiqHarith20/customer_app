import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/commercepay/online_payment_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/payment_method_model.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/api-list.dart';

import 'package:get/get.dart';

import '../../../../utils/server.dart';

class WebviewScreenController extends GetxController {
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<OnlinePaymentModel> onlinePaymentModel = OnlinePaymentModel().obs;
  Server server = Server();
  RxBool isLoading = true.obs;

  // void getArgumentAndMakePayment() async {
  //   try {
  //     // Fetch the arguments
  //     dynamic argumentData = Get.arguments;
  //     if (argumentData != null && argumentData['onlinePaymentModel'] != null) {
  //       onlinePaymentModel.value = argumentData['onlinePaymentModel'];
  //       // Extract necessary data from onlinePaymentModel
  //       String customerId = onlinePaymentModel.value.customerId ?? '';
  //       String accessToken = onlinePaymentModel.value.accessToken ?? '';
  //       String providerChannelId =
  //           onlinePaymentModel.value.providerChannelId ?? '';
  //       String passId = onlinePaymentModel.value.passId ?? '';
  //       String fullName = onlinePaymentModel.value.fullName ?? '';
  //       String email = onlinePaymentModel.value.email ?? '';
  //       String address = onlinePaymentModel.value.address ?? '';
  //       String identificationNo =
  //           onlinePaymentModel.value.identificationNo ?? '';
  //       String mobileNumber = onlinePaymentModel.value.mobileNumber ?? '';
  //       String vehicleNo = onlinePaymentModel.value.vehicleNo ?? '';
  //       String lotNo = onlinePaymentModel.value.lotNo ?? '';
  //       String companyRegistrationNo =
  //           onlinePaymentModel.value.companyRegistrationNo ?? '';
  //       String companyName = onlinePaymentModel.value.companyName ?? '';
  //       double totalPrice = onlinePaymentModel.value.amount ?? 0;
  //       String userName = onlinePaymentModel.value.userName ?? '';
  //       String identificationType =
  //           onlinePaymentModel.value.identificationType ?? '';
  //       Timestamp? endDate = onlinePaymentModel.value.endDate;
  //       Timestamp? startDate = onlinePaymentModel.value.startDate;

  //       // Call the onlinePayment method with the extracted data
  //       onlinePayment(
  //         customerId: customerId,
  //         accessToken: accessToken,
  //         selectedBankId: providerChannelId,
  //         selectedPassId: passId,
  //         fullName: fullName,
  //         email: email,
  //         address: address,
  //         identificationNo: identificationNo,
  //         mobileNumber: mobileNumber,
  //         vehicleNo: vehicleNo,
  //         lotNo: lotNo,
  //         companyRegistrationNo: companyRegistrationNo,
  //         companyName: companyName,
  //         totalPrice: totalPrice,
  //         userName: userName,
  //         identificationType: identificationType,
  //         endDate: endDate ??
  //             Timestamp.now(), // Provide a default value if endDate is null
  //         startDate: startDate ??
  //             Timestamp.now(), // Provide a default value if startDate is null
  //       );
  //     }
  //   } catch (e, s) {
  //     log("$e \n$s");
  //     ShowToastDialog.showToast("exception:$e \n$s");
  //   }
  // }

  // void onlinePayment({
  //   required String customerId,
  //   required String accessToken,
  //   required String selectedBankId,
  //   required String selectedPassId,
  //   required String fullName,
  //   required String email,
  //   required String address,
  //   required String identificationNo,
  //   required String mobileNumber,
  //   required String vehicleNo,
  //   required String lotNo,
  //   required String companyRegistrationNo,
  //   required String companyName,
  //   required double totalPrice,
  //   required String userName,
  //   required String identificationType,
  //   required Timestamp endDate,
  //   required Timestamp startDate,
  //   String channelId = '2', // Default value for channelId
  // }) async {
  //   try {
  //     // Construct the JSON body using data from various sources
  //     final body = {
  //       'accessToken': accessToken,
  //       'customerId': customerId,
  //       'channelId': channelId,
  //       'providerChannelId': selectedBankId,
  //       'amount': totalPrice,
  //       'address': address,
  //       'companyName': companyName,
  //       'companyRegistrationNo': companyRegistrationNo,
  //       'endDate': endDate,
  //       'startDate': startDate,
  //       'name': fullName,
  //       'email': email,
  //       'mobileNumber': mobileNumber,
  //       'username': userName,
  //       'identificationNo': identificationNo,
  //       'identificationType': identificationType,
  //       'lotNo': lotNo,
  //       'vehicleNo': vehicleNo,
  //       'passId': selectedPassId,
  //     };

  //     // Send the POST request with the constructed body
  //     final response = await server.postRequest(
  //       endPoint: APIList.payment,
  //       body: body,
  //     );

  //     if (response != null && response.statusCode == 200) {
  //       // Handle response data as needed
  //       print("Response: ${response.body}");
  //     } else {
  //       throw Exception('Failed to load data from API');
  //     }
  //   } catch (e, s) {
  //     log("$e \n$s");
  //     ShowToastDialog.showToast("exception:$e \n$s");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Map<String, String> getRequestBody() {
    final onlinePaymentData = onlinePaymentModel.value;
    final Map<String, String> body = {
      'accessToken': onlinePaymentData.accessToken ?? '',
      'customerId': onlinePaymentData.customerId ?? '',
      'channelId': '2', // Default value for channelId
      'providerChannelId': onlinePaymentData.selectedBankId ?? '',
      'amount': onlinePaymentData.totalPrice?.toString() ?? '',
      'address': onlinePaymentData.address ?? '',
      'companyName': onlinePaymentData.companyName ?? '',
      'companyRegistrationNo': onlinePaymentData.companyRegistrationNo ?? '',
      'endDate':
          onlinePaymentData.endDate?.millisecondsSinceEpoch.toString() ?? '',
      'startDate':
          onlinePaymentData.startDate?.millisecondsSinceEpoch.toString() ?? '',
      'name': onlinePaymentData.fullName ?? '',
      'email': onlinePaymentData.email ?? '',
      'mobileNumber': onlinePaymentData.mobileNumber ?? '',
      'username': onlinePaymentData.userName ?? '',
      'identificationNumber': onlinePaymentData.identificationNo ?? '',
      'identificationType': onlinePaymentData.identificationType ?? '',
      'lotNo': onlinePaymentData.lotNo ?? '',
      'vehicleNo': onlinePaymentData.vehicleNo ?? '',
      'passId': onlinePaymentData.passId ?? '',
    };
    // Print the request body
    print('Request Body: $body');
    return body;
  }
}
