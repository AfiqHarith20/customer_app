import 'dart:convert';

import 'package:customer_app/app/models/commercepay/auth_model.dart';
import 'package:customer_app/app/models/my_payment_compound_model.dart';

import 'package:customer_app/constant/dialogue_box.dart';

import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/fire_store_utils.dart';
import '../../../models/compound_model.dart';
import '../../../models/wallet_transaction_model.dart';

class SearchSummonScreenController extends GetxController {
  RxList<CompoundModel> compoundList = <CompoundModel>[].obs;
  RxList<CompoundModel> compoundImage = <CompoundModel>[].obs;
  Rx<MyPaymentCompoundModel> myPaymentCompoundModel =
      MyPaymentCompoundModel().obs;

  Server server = Server();
  final AuthModel authModel = AuthModel();
  final _isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool get isLoading => _isLoading.value;
  final _isMakingPayment = false.obs;

  bool get isMakingPayment => _isMakingPayment.value;

  void setMakingPayment(bool value) {
    _isMakingPayment.value = value;
  }

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

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload(); // Reloads the user to ensure the latest data
    user = _auth.currentUser; // Refresh user object

    if (user != null) {
      return user
          .emailVerified; // Returns true if email is verified, false otherwise
    } else {
      return false; // User is null, indicating not logged in
    }
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

  void handleCompoundNumber(String? compoundNumber) {
    if (compoundNumber != null && compoundNumber.isNotEmpty) {
      // Perform any necessary logic with the compound number here
      print('Compound number from QR code scan: $compoundNumber');
      // Example: Trigger the searchCompounds method with the compound number
      searchCompounds(requestMethod: 'compound', searchText: compoundNumber);
    }
  }

  Future<Map<String, dynamic>> searchCompound({
    required String id,
    required String pass,
    required String requestMethod,
    required String compoundNum,
    required String carNum,
  }) async {
    // Construct the request URL
    setLoading(true);
    String url = APIList.searchCompound!;

    // Construct the request body
    Map<String, String> requestBody = {
      'id': id,
      'pass': pass,
      'request_method': requestMethod,
      'compound_num': compoundNum,
      'car_num': carNum,
    };

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
        setLoading(false);
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check for invalid or empty compound data
        bool isInvalidData = responseData['vehicle_num'] == "" &&
            responseData['compound_num'] == "" &&
            responseData['status'] == "" &&
            responseData['amount'] == "" &&
            responseData['datetime'] == "" &&
            responseData['offence'] == "" &&
            responseData['kod_hasil'] == "" &&
            responseData['msg'] != null &&
            responseData['allCompoundImage'] == "";

        if (isInvalidData) {
          // Show dialog if compound data is invalid or empty
          Get.dialog(
            DialogBoxNotify(
              imageAsset:
                  "assets/images/ic_parking.png", // Adjust the image asset as needed
              onPressConfirm: () {
                Get.back(); // Close the dialog
              },
              onPressConfirmBtnName: "Ok".tr, // Use the appropriate button name
              onPressConfirmColor:
                  AppColors.yellow04, // Set color for confirm button
              content:
                  'No matching compounds were found for the search criteria.'
                      .tr,
              subTitle: 'Compound Not Found'.tr,
            ),
          );

          // Return an empty map or throw an exception to stop further processing
          return {}; // or throw Exception('No data found');
        }

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
    setLoading(true); // Set isLoading to true before making the API call
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
    } finally {
      setLoading(
          false); // Set isLoading to false after the search operation completes
    }
  }
}
