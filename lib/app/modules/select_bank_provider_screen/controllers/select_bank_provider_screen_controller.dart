import 'dart:convert';
import 'dart:developer';
import 'package:customer_app/utils/preferences.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../constant/show_toast_dialogue.dart';
import '../../../../utils/api-list.dart';
import '../../../../utils/server.dart';
import '../../../models/commercepay/channel_model.dart';

class SelectBankProviderScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isPaymentCompleted = true.obs;
  RxString selectedBank = "".obs;
  List<ProviderChannelModel> providerList = <ProviderChannelModel>[].obs;

  int selectedIndex = -1;
  Server server = Server();

  @override
  void onInit() {
    commercepayProviderBank();
    super.onInit();
  }

  void commercepayProviderBank() async {
    try {
      // String accessToken = Preferences.getString("AccessToken");
      // print("Access Token: $accessToken"); // Print the access token
      final response = await server.getRequest(
          endPoint: APIList.provider.toString() +
              Preferences.getString("AccessToken"));

      if (response.statusCode == 200) {
        // Log the response body
        // print("Response body: ${response.body}");

        // Check if response body is empty
        if (response.body.isEmpty) {
          throw Exception('Empty response body');
        }

        // Parse response body as JSON
        List<dynamic> test = json.decode(response.body);

        // Filter data and handle empty strings
        test = test
            .where((element) =>
                element["id"] != "LOAD001" &&
                element["name"] != "" &&
                element["displayName"] != "")
            .toList();

        for (var element in test) {
          ProviderChannelModel bankItem = ProviderChannelModel(
              id: element["id"],
              name: element["name"],
              displayName: element["displayName"],
              imageUrl: element["imageUrl"],
              status: element["status"]);
          providerList.add(bankItem);
        }

        // print("result $providerList");
      } else {
        throw Exception(
            'Failed to load data from API. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    } catch (e, s) {
      // Handle errors
      // print("Error details: $e");
      // print("Stack trace: $s");
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    } finally {
      // Update isLoading value
      isLoading.value = false;
    }
  }
}
