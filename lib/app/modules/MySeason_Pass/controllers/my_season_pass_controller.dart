import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';
import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:customer_app/app/modules/Season_pass/controllers/season_pass_controller.dart';
import 'package:get/get.dart';

import '../../../../utils/fire_store_utils.dart';

class MySeasonPassController extends GetxController {
  //TODO: Implement MySeasonPassController
  RxBool selectedSegment = false.obs;
  var isUserLoggedIn = false.obs;
  RxBool isLoading = true.obs;
  RxList<MyPurchasePassModel> mySeasonPassList = <MyPurchasePassModel>[].obs;
  RxList<PendingPassModel> pendingPassList = <PendingPassModel>[].obs;
  SeasonPassController seasonPassController = Get.put(SeasonPassController());
  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  @override
  void onInit() {
    checkLoginStatus();
    getMySeasonPass();
    getPendingPass();
    super.onInit();
  }

  reload() async {
    // Implement the logic to reload data or UI
    try {
      // Set isLoading to true to show loading indicator
      isLoading(true);

      // Call the methods to fetch data
      await getMySeasonPass();
      await getPendingPass();
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      // Set isLoading to false after loading is completed
      isLoading(false);
    }
  }

  loadMySeasonPassList() async {
    isLoading.value =
        true; // Set loading indicator to true before fetching data
    await FireStoreUtils.getMySeasonPassData().then((value) {
      if (value != null) {
        mySeasonPassList.value = value;
        print('----------->${mySeasonPassList.length}');
      }
    });
    isLoading.value =
        false; // Set loading indicator to false after fetching data
  }

  getMySeasonPass() async {
    await FireStoreUtils.getMySeasonPassData().then((value) {
      if (value != null) {
        mySeasonPassList.value = value;
        print('----------->${mySeasonPassList.length}');
      }
    });
    isLoading.value = false;
  }

  getPendingPass() async {
    await FireStoreUtils.getPendingPassData().then((value) {
      if (value != null) {
        pendingPassList.value = value;
        print('----------->pending${pendingPassList.length}');
        // printPendingPassDetails();
      }
    });
  }

  // void printPendingPassDetails() {
  //   for (var pass in pendingPassList) {
  //     print('Pass ID: ${pass.id}');
  //     print('Pass Name: ${pass.privatePassModel?.passName}');
  //     print('Pass Price: ${pass.privatePassModel?.price}');
  //     print('Validity: ${pass.privatePassModel?.validity}');
  //     print('Lot No: ${pass.lotNo}');
  //     print('Created At: ${pass.createAt}');
  //     print('Status: ${pass.status}');
  //     print('End Date: ${pass.endDate}');
  //     print('End Date: ${pass.fullName}');
  //     print('zone: ${pass.zoneName}');
  //     print('road: ${pass.roadName}');
  //     // Add any other details you want to print
  //   }
  // }

  void changeSegment(bool value) {
    selectedSegment.value = value; // Convert int to bool
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void checkLoginStatus() {
    // Assuming FireStoreUtils.isLogin() checks login state
    FireStoreUtils.isLogin().then((isLoggedIn) {
      isUserLoggedIn.value = isLoggedIn;
      isLoading.value = false;
    });
  }
}
