import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../utils/fire_store_utils.dart';
import '../../../models/season_pass_model.dart';

class SeasonPassController extends GetxController {
  //TODO: Implement SeasonPassController
  RxBool isLoading = true.obs;
  // Define an observable to track the selected segment
  RxBool selectedSegment = false.obs;

  RxList<SeasonPassModel> seasonPassList = <SeasonPassModel>[].obs;
  RxList<PrivatePassModel> privatePassList = <PrivatePassModel>[].obs;

  RxBool isMyPassScreen = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    getPurchasePass();
    super.onInit();
  }

  reload() async {
    // Implement the logic to reload data or UI
    try {
      // Set isLoading to true to show loading indicator
      isLoading(true);

      // Call the methods to fetch data
      await getPurchasePass();
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      // Set isLoading to false after loading is completed
      isLoading(false);
    }
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

  getPurchasePass() async {
    await FireStoreUtils.getSeasonPassData().then((value) {
      if (value != null) {
        seasonPassList.value = value;
      }
    });

    await FireStoreUtils.getPrivatePassData().then((value) {
      if (value != null) {
        privatePassList.value = value;
      }
    });
    isLoading.value = false;
  }

  // Method to change the selected segment
  void changeSegment(bool value) {
    selectedSegment.value = value; // Convert int to bool
  }
}
