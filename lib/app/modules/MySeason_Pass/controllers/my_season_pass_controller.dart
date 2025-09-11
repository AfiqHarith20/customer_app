import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../../../../utils/fire_store_utils.dart';

class MySeasonPassController extends GetxController {
  RxBool selectedSegment = false.obs;
  var isUserLoggedIn = false.obs;
  RxBool isLoading = true.obs;
  RxList<MyPurchasePassModel> mySeasonPassList = <MyPurchasePassModel>[].obs;
  RxList<PendingPassModel> pendingPassList = <PendingPassModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Use a single, async method to handle all initialization logic
    initializeData();
  }

  void initializeData() async {
    // Set loading to true at the start of all async operations
    isLoading.value = true;

    // First, await the login status check to ensure it's complete
    bool isLoggedIn = await FireStoreUtils.isLogin();
    isUserLoggedIn.value = isLoggedIn;

    // Only fetch data if the user is logged in
    if (isLoggedIn) {
      await getMySeasonPass();
      await getPendingPass();
    }

    // Check if the page needs to reload after a payment
    bool paymentCompleted = Get.arguments?['paymentCompleted'] ?? false;
    if (paymentCompleted) {
      reload();
    }

    // Set loading to false once all initial data is loaded
    isLoading.value = false;
  }

  void reload() async {
    isLoading.value = true;
    if (selectedSegment.value) {
      await getPendingPass();
    } else {
      await getMySeasonPass();
    }
    isLoading.value = false;
  }

  // Simplified data fetching methods
  getMySeasonPass() async {
    await FireStoreUtils.getMySeasonPassData().then((value) {
      if (value != null) {
        mySeasonPassList.value = value;
        print('----------->${mySeasonPassList.length}');
      }
    });
  }

  getPendingPass() async {
    await FireStoreUtils.getPendingPassData().then((value) {
      if (value != null) {
        pendingPassList.value = value;
        print('----------->pending${pendingPassList.length}');
      }
    });
  }

  void handlePayNow(PendingPassModel pendingPassModel) {
    final args = {
      "passId": pendingPassModel.id,
      "passName": pendingPassModel.privatePassModel!.passName,
      "passPrice": pendingPassModel.privatePassModel!.price.toString(),
      "privatePassId": pendingPassModel.privatePassModel!.passId.toString(),
      "passValidity": pendingPassModel.privatePassModel!.validity,
      'customerId': pendingPassModel.customerId,
      'name': pendingPassModel.fullName,
      'username': pendingPassModel.email,
      'address': pendingPassModel.address,
      'identificationNumber': pendingPassModel.identificationNo,
      'mobileNumber': pendingPassModel.mobileNumber,
      'vehicleNo': pendingPassModel.vehicleNo,
      'lotNo': pendingPassModel.lotNo,
      'image': pendingPassModel.image,
      'companyName': pendingPassModel.companyName,
      'companyRegistrationNo': pendingPassModel.companyRegistrationNo,
      'countryCode': pendingPassModel.countryCode,
      'startDate': pendingPassModel.startDate?.toDate().toString(),
      'endDate': pendingPassModel.endDate!.toDate().toString(),
      'status': pendingPassModel.status,
      'zoneId': pendingPassModel.zoneId,
      'zoneName': pendingPassModel.zoneName,
      'roadId': pendingPassModel.roadId,
      'roadName': pendingPassModel.roadName,
    };
    Get.toNamed(Routes.PAY_PENDING_PASS, arguments: args);
  }

  void changeSegment(bool value) {
    selectedSegment.value = value;
  }
}
