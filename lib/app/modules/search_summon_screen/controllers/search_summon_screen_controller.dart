import 'dart:convert';

import 'package:customer_app/app/models/commercepay/auth_model.dart';
import 'package:customer_app/app/models/my_payment_compound_model.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/server.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/fire_store_utils.dart';
import '../../../models/compound_model.dart';
import '../../../models/wallet_transaction_model.dart';

class SearchSummonScreenController extends GetxController {
  RxList<CompoundModel> compoundList = <CompoundModel>[].obs;
  Rx<MyPaymentCompoundModel> myPaymentCompoundModel =
      MyPaymentCompoundModel().obs;
  Server server = Server();
  final AuthModel authModel = AuthModel();
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  void setLoading(bool value) {
    _isLoading.value = value;
  }

  void clearCompoundList() {
    compoundList.clear();
  }

  @override
  void onInit() {
    getPaymentData();
    super.onInit();
  }

  getPaymentData() async {
    setLoading(true); // Set isLoading to true
    await getTraction();
    setLoading(false); // Set isLoading to false after API call
  }

  getTraction() async {
    await FireStoreUtils.getWalletTransaction().then((value) {
      if (value != null) {
        compoundList.value = value.cast<CompoundModel>();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Method to update compoundList
  void updateCompoundList(List<CompoundModel> compounds) {
    compoundList.assignAll(compounds);
  }

  Future<Map<String, dynamic>> searchCompound({
    required String id,
    required String pass,
    required String requestMethod,
    required String compoundNum,
    required String carNum,
  }) async {
    // Construct the request URL
    String url = APIList.searchCompound!;

    // Construct the request body
    Map<String, String> requestBody = {
      'id': id,
      'pass': pass,
      'request_method': requestMethod,
      'compound_num': compoundNum,
      'car_num': carNum,
    };
    // print('Request body: $requestBody');

    // Set up the headers
    Map<String, String> headers = {
      'Authorization':
          'Basic M=Lu5k%r8uw!6yBq^T924bdjE_piB3DU2^d9eB39^7u9^GdAKe_IG5KbK&V2vt5=KpxkB',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      setLoading(true);
      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        setLoading(true);
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        // setLoading(false);
        return responseData;
      } else {
        // Request failed with a non-200 status code
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Request failed due to an error
      setLoading(false);
      throw Exception('Failed to load data: $e');
    }
  }

  // Add a new method to search for compounds based on the request method and search text
  Future<void> searchCompounds({
    required String requestMethod,
    required String searchText,
  }) async {
    try {
      Map<String, dynamic> searchResult = await searchCompound(
        id: 'vendor_mptemerloh',
        pass:
            'M=Lu5k%r8uw!6yBq^T924bdjE_piB3DU2^d9eB39^7u9^GdAKe_IG5KbK&V2vt5=KpxkB',
        requestMethod: requestMethod,
        compoundNum: requestMethod == 'compound' ? searchText : '',
        carNum: requestMethod == 'car' ? searchText : '',
      );

      // Handle the search result here
      print(searchResult);

      // Update the compoundList with the search result
      List<Map<String, dynamic>> compoundDataList =
          List<Map<String, dynamic>>.from(searchResult['data']);
      List<CompoundModel> compounds =
          compoundDataList.map((data) => CompoundModel.fromJson(data)).toList();
      compoundList.value = compounds;
    } catch (e) {
      // Handle any errors that occur during the search
      print('Error searching: $e');
    }
  }
}
