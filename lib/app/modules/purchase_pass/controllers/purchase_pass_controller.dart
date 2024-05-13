import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/season_pass_model.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import '../../../../utils/fire_store_utils.dart';
import '../../../models/my_purchase_pass_model.dart';

class PurchasePassController extends GetxController {
  //TODO: Implement PurchasePassController
  Rx<GlobalKey<FormState>> formKeyPurchase = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> identificationNoController =
      TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> vehicleNoController = TextEditingController().obs;
  Rx<TextEditingController> lotNoController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> companyRegistrationNoController =
      TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  RxString countryCode = "+60".obs;
  List<String> type = [
    "Pas Mingguan 1",
    "Pas Mingguan 2",
    "Pas Mingguan 3",
    "Pas Bulanan 1",
    "Pas Bulanan 6",
    "Pas Bulanan 12"
  ];
  Rx<SeasonPassModel> selectedSessionPass = SeasonPassModel().obs;

  Rx<MyPurchasePassModel> purchasePassModel = MyPurchasePassModel().obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxList<SeasonPassModel> seasonPassList = <SeasonPassModel>[].obs;

  Rx<CustomerModel> customerModel = CustomerModel().obs;

  void clearFormData() {
    vehicleNoController.value.clear();
    lotNoController.value.clear();
    companyNameController.value.clear();
    companyRegistrationNoController.value.clear();
    addressController.value.clear();
    // Add similar lines for other controllers as needed
  }

  @override
  void onInit() {
    getArgument();
    getProfileData();
    clearFormData();
    super.onInit();
  }

  getArgument() async {
    await FireStoreUtils.getSeasonPassData().then((value) {
      if (value != null) {
        seasonPassList.value = value;
      }
    });
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      SeasonPassModel temp = argumentData['seasonPassModel'];
      selectedSessionPass.value =
          seasonPassList.where((p0) => p0.passid == temp.passid).first;
    }
    update();
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        customerModel.value = value;
        fullNameController.value.text = customerModel.value.fullName!;
        emailController.value.text = customerModel.value.email!;
        phoneNumberController.value.text = customerModel.value.phoneNumber!;
      }
    });
  }

  Future<Map<String, dynamic>> addSeasonPassData() async {
    // Populate purchasePassModel
    purchasePassModel.value.id = Constant.getUuid();
    purchasePassModel.value.customerId = FireStoreUtils.getCurrentUid();
    purchasePassModel.value.seasonPassModel = selectedSessionPass.value;
    purchasePassModel.value.fullName = fullNameController.value.text;
    purchasePassModel.value.email = emailController.value.text;
    purchasePassModel.value.identificationNo =
        identificationNoController.value.text;
    purchasePassModel.value.mobileNumber = phoneNumberController.value.text;
    purchasePassModel.value.vehicleNo = vehicleNoController.value.text;
    purchasePassModel.value.lotNo = lotNoController.value.text;
    purchasePassModel.value.companyName = companyNameController.value.text;
    purchasePassModel.value.companyRegistrationNo =
        companyRegistrationNoController.value.text;
    purchasePassModel.value.address = addressController.value.text;
    purchasePassModel.value.countryCode = countryCode.reactive.toString();
    purchasePassModel.value.startDate = Timestamp.now();
    purchasePassModel.value.createAt = Timestamp.now();
    purchasePassModel.value.endDate = Timestamp.fromDate(
      DateTime.timestamp().add(
        Duration(
          days: checkDuration(
            selectedSessionPass.value.validity.toString(),
          ),
        ),
      ),
    );

    // Create and return a map with required data
    return {
      'customerId': purchasePassModel.value.customerId,
      'address': purchasePassModel.value.address,
      'companyName': purchasePassModel.value.companyName,
      'companyRegistrationNo': purchasePassModel.value.companyRegistrationNo,
      'endDate': purchasePassModel.value.endDate,
      'startDate': purchasePassModel.value.startDate,
      'fullName': purchasePassModel.value.fullName,
      'email': purchasePassModel.value.email,
      'mobileNumber': purchasePassModel.value.mobileNumber,
      'identificationNo': purchasePassModel.value.identificationNo,
      'vehicleNo': purchasePassModel.value.vehicleNo,
      'lotNo': purchasePassModel.value.lotNo,
    };
  }

  checkDuration(String time) {
    if (time == "1 Week") {
      return 7;
    } else if (time == "2 Weeks") {
      return 14;
    } else if (time == "3 Weeks") {
      return 21;
    } else if (time == "1 Month") {
      return 30;
    } else if (time == "3 Months") {
      return 90;
    } else if (time == "6 Months") {
      return 182;
    } else if (time == "12 Months") {
      return 365;
    }
    return 0;
  }
}
