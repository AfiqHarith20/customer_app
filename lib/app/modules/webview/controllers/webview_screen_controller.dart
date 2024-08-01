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

  @override
  void onInit() {
    super.onInit();
    // Retrieve arguments and make payment when the controller is initialized
    getArgumentAndMakePayment();
  }

  Future<void> getArgumentAndMakePayment() async {
    try {
      // Reset data to default state
      cleanup();

      // Reset isPaymentFetched to allow payment fetch
      isPaymentFetched = false;

      // Fetch the arguments
      dynamic argumentData = Get.arguments;
      if (argumentData != null && argumentData['onlinePaymentModel'] != null) {
        onlinePaymentModel.value = argumentData['onlinePaymentModel'];

        // Call fetchPayment after arguments are set
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
      'amount': onlinePaymentData.totalPrice?.toString() ?? '',
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
      if (isPaymentFetched) {
        // If payment is already fetched, return the existing response
        return WebViewResponse(
          redirectionType: -1,
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

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseBody = json.decode(response.body);

        if (responseBody != null) {
          final int redirectionType = responseBody['redirectionType'];
          final String redirectUrl = responseBody['redirectUrl'] ?? '';
          final String clientScript = responseBody['clientScript'] ?? '';

          isPaymentFetched = true;

          return WebViewResponse(
            redirectionType: redirectionType,
            redirectUrl: redirectUrl,
            clientScript: clientScript,
          );
        } else {
          print('Response body is null');
          return WebViewResponse(
            redirectionType: -1,
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
        return fetchPayment();
      } else {
        print('Error: ${response.statusCode}');
        ShowToastDialog.showToast(
            "Error occurred while making payment: ${response.statusCode}");
        return WebViewResponse(
          redirectionType: -1,
          redirectUrl: '',
          clientScript: '',
        );
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("Error occurred while making payment: $e");
      return WebViewResponse(
        redirectionType: -1,
        redirectUrl: '',
        clientScript: '',
      );
    }
  }

  @override
  void dispose() {
    // Perform cleanup before disposing
    cleanup();
    // Call dispose method of superclass
    super.dispose();
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

  Future<WebViewResponse> updateArgumentAndMakePayment() async {
    // Call getArgumentAndMakePayment and then update UI if needed
    await getArgumentAndMakePayment();
    return WebViewResponse(
      redirectionType: -1,
      redirectUrl: '',
      clientScript: '',
    );
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
