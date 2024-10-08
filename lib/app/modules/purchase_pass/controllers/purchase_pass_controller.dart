import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/query_pass_model.dart';
import 'package:customer_app/app/models/season_pass_model.dart';
import 'package:customer_app/app/models/vehicle_model.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import '../../../../utils/fire_store_utils.dart';
import '../../../models/my_purchase_pass_model.dart';

class PurchasePassController extends GetxController {
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
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> vehicleList = <Map<String, dynamic>>[].obs;
  Rx<VehicleModel> customerVehicleModel = VehicleModel().obs;
  StreamSubscription<QuerySnapshot>? vehicleSubscription;
  final _error = ''.obs;
  get error => _error.value;
  Server server = Server();
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
  Rx<QueryPass> queryPassModel = QueryPass().obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxList<SeasonPassModel> seasonPassList = <SeasonPassModel>[].obs;

  Rx<CustomerModel> customerModel = CustomerModel().obs;

  void clearFormData() {
    vehicleNoController.value.clear();
    lotNoController.value.clear();
    companyNameController.value.clear();
    vehicleNoController.value.clear();
    companyRegistrationNoController.value.clear();
    addressController.value.clear();
    // Add similar lines for other controllers as needed
  }

  @override
  void onInit() {
    getArgument();
    getProfileData();
    clearFormData();
    fetchVehicle();
    super.onInit();
  }

  @override
  void onClose() {
    vehicleSubscription?.cancel();
    cleanup(); // Call cleanup to dispose controllers
    super.onClose();
  }

  void cleanup() {
    // Dispose all TextEditingControllers
    fullNameController.value;
    emailController.value;
    phoneNumberController.value;
    vehicleNoController.value;
    lotNoController.value;
    companyNameController.value;
    companyRegistrationNoController.value;
    addressController.value;
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

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
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

  Future<void> fetchVehicle() async {
    try {
      isLoading.value = true;
      print('Listening for vehicle data changes for user: ${getCurrentUid()}');

      FirebaseFirestore.instance
          .collection(CollectionName.custVehicle)
          .doc(getCurrentUid())
          .collection('vehicles')
          .where('active', isEqualTo: true)
          .snapshots()
          .listen((querySnapshot) {
        List<Map<String, dynamic>> vehicleInfo = querySnapshot.docs.map((doc) {
          return {
            "vehicleNo": doc.data()['vehicleNo'].toString(),
            "colorHex": doc.data()['colorHex'].toString(),
            "vehicleManufacturer": doc.data()['vehicleManufacturer'].toString(),
            "vehicleModel": doc.data()['vehicleModel'].toString(),
            "active": doc.data()['active'] == true,
            "default": doc.data()['default'] == true,
            "documentId": doc.id,
          };
        }).toList();

        print('Updated vehicle data: $vehicleInfo');

        if (vehicleInfo.isNotEmpty) {
          vehicleList.assignAll(vehicleInfo);
          customerVehicleModel.value = VehicleModel.fromJson(vehicleInfo.first);
        } else {
          print('No active vehicles found for user: ${getCurrentUid()}');
        }
      });
    } catch (e) {
      print('Error listening for information: $e');
      _error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getQueryPass() async {
    isLoading.value = true;
    try {
      final vehicleNo = vehicleNoController.value.text;
      final validity =
          checkDuration(selectedSessionPass.value.validity.toString());
      final response = await server.getRequest(
        endPoint: '${APIList.queryPass}vehicleNo=$vehicleNo&validity=$validity',
      );
      if (response != null) {
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          print("Start Date: ${jsonResponse['newStartDate']}");
          print("End Date: ${jsonResponse['newEndDate']}");
          queryPassModel.value.newStartDate =
              Timestamp.fromDate(DateTime.parse(jsonResponse['newStartDate']));
          queryPassModel.value.newEndDate =
              Timestamp.fromDate(DateTime.parse(jsonResponse['newEndDate']));
        } else {
          print("API Error: ${response.reasonPhrase}");
          // Handle error cases based on response status code or reasonPhrase
        }
      } else {
        print("Null Response");
        // Handle null response case
      }
    } catch (e) {
      print("Error fetching query pass: $e");
      // Handle any exceptions that occur during the API call
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> addSeasonPassData() async {
    try {
      // Ensure queryPassModel has been populated
      if (queryPassModel.value.newStartDate != null &&
          queryPassModel.value.newEndDate != null) {
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
        purchasePassModel.value.startDate = queryPassModel.value.newStartDate!;
        purchasePassModel.value.createAt = Timestamp.now();
        purchasePassModel.value.endDate = queryPassModel.value.newEndDate!;

        // Create and return a map with required data
        return {
          'customerId': purchasePassModel.value.customerId,
          'address': purchasePassModel.value.address,
          'companyName': purchasePassModel.value.companyName,
          'companyRegistrationNo':
              purchasePassModel.value.companyRegistrationNo,
          'endDate': purchasePassModel.value.endDate,
          'startDate': purchasePassModel.value.startDate,
          'fullName': purchasePassModel.value.fullName,
          'email': purchasePassModel.value.email,
          'mobileNumber': purchasePassModel.value.mobileNumber,
          'identificationNo': purchasePassModel.value.identificationNo,
          'vehicleNo': purchasePassModel.value.vehicleNo,
          'lotNo': purchasePassModel.value.lotNo,
        };
      } else {
        throw Exception("Query pass data is not available");
      }
    } catch (e) {
      print("Error adding season pass data: $e");
      // Handle any exceptions that occur during data population
      return {}; // Or return an empty map or null based on your error handling strategy
    }
  }

  int checkDuration(String time) {
    if (time == "1 Week") {
      return 6;
    } else if (time == "2 Weeks") {
      return 13;
    } else if (time == "3 Weeks") {
      return 20;
    } else if (time == "1 Month") {
      return 29;
    } else if (time == "3 Months") {
      return 89;
    } else if (time == "6 Months") {
      return 179;
    } else if (time == "12 Months") {
      return 364;
    }
    return 0;
  }
}
