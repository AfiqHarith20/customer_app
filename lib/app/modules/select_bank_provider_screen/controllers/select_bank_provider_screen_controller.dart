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
    try
    {
      await server
          .getRequest(endPoint: APIList.provider.toString() + Preferences.getString("AccessToken"))
          .then((response) {
        if (response != null && response.statusCode == 200) {

          List<dynamic> test = json.decode(response.body);
          test.forEach((element) {
            ProviderChannelModel bankItem = ProviderChannelModel(
                id: element["id"],
                name: element["name"],
                displayName: element["displayName"],
                imageUrl: element["imageUrl"],
                status: element["status"]);
            if(element["name"] != ""){
              providerList.add(bankItem);
            }

          });
          //print("result $providerList");
        } else {
          throw Exception('Failed to load data from API');
        }
      });
    }
    catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
    finally
    {
      isLoading.value = false;
    }
  }
}
