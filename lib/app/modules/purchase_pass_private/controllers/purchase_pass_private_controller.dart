import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/pending_detail_pass_model.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/app/models/query_lot_model.dart';
import 'package:customer_app/app/models/zone_road_model.dart';
import 'package:customer_app/app/modules/Season_pass/controllers/season_pass_controller.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/preferences.dart';
import 'package:customer_app/utils/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PurchasePassPrivateController extends GetxController {
  Rx<GlobalKey<FormState>> formKeyPurchasePrivate = GlobalKey<FormState>().obs;
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
  Rx<TextEditingController> referenceController = TextEditingController().obs;
  Rx<DateController> startAtDateController = DateController().obs;
  RxString countryCode = "+60".obs;
  RxBool isLoading = true.obs;
  RxString privateParkImage = "".obs;
  List<String> type = [
    "Pas Mingguan 1",
    "Pas Mingguan 2",
    "Pas Mingguan 3",
    "Pas Bulanan 1",
    "Pas Bulanan 6",
    "Pas Bulanan 12"
  ];
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  Rx<PrivatePassModel> selectedPrivatePass = PrivatePassModel().obs;
  Rx<PendingDetailPassModel> paymentType = PendingDetailPassModel().obs;
  Rx<PendingDetailPassModel> pendingDetailPassModel =
      PendingDetailPassModel().obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxList<PrivatePassModel> privatePassList = <PrivatePassModel>[].obs;
  RxList<File> imageFiles = <File>[].obs;
  final ImagePicker imagePicker = ImagePicker();
  final bool selectedSegment = Get.arguments?['selectedSegment'] ?? false;
  final SeasonPassController seasonPassController = Get.find();
  Rx<QueryLot> queryLotModel = QueryLot().obs;
  Server server = Server();
  var zones = <Zone>[].obs;
  var roads = <Road>[].obs;
  var selectedZone = Rxn<Zone>();
  var selectedRoad = Rxn<Road>();

  @override
  void onInit() {
    getArgument();
    getProfileData();
    fetchZones();
    super.onInit();
  }

  @override
  void onClose() {
    clearFormData();
    super.onClose();
  }

  void clearFormData() {
    fullNameController.value.clear();
    emailController.value.clear();
    identificationNoController.value.clear();
    phoneNumberController.value.clear();
    vehicleNoController.value.clear();
    lotNoController.value.clear();
    companyNameController.value.clear();
    companyRegistrationNoController.value.clear();
    addressController.value.clear();
    referenceController.value.clear();
    privateParkImage.value = "";

    // Clear fetched data
    customerModel.value = CustomerModel();
    selectedPrivatePass.value = PrivatePassModel();
    paymentType.value = PendingDetailPassModel();
    pendingDetailPassModel.value = PendingDetailPassModel();
    selectedZone.value = null;
    selectedRoad.value = null;
    // Fetch fresh data
    getProfileData();
    fetchZones();
  }

  Future<void> fetchZones() async {
    List<Zone> response = await getZone();
    if (response.isNotEmpty) {
      zones.value = response;
    }
  }

  Future<void> fetchRoads(int zoneId) async {
    List<Road> response = await getRoad(zoneId);
    if (response.isNotEmpty) {
      roads.value = response;
    }
  }

  void getArgument() async {
    await FireStoreUtils.getPrivatePassData().then((value) {
      if (value != null) {
        privatePassList.value = value;
      }
    });
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      PrivatePassModel temp = argumentData['privatePassModel'];
      selectedPrivatePass.value =
          privatePassList.where((p0) => p0.passId == temp.passId).first;
    }
    update();
  }

  Future<void> pickFile({required ImageSource source}) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image == null) return;

      // Generate a UUID for the image name
      String uuid = const Uuid().v4();
      String fileName = "$uuid.jpg";

      // Update the privateParkImage with the generated file name
      privateParkImage.value = fileName;

      // Copy the image to a new path with the UUID name
      File imageFile = File(image.path);
      String newPath = "${imageFile.parent.path}/$fileName";
      await imageFile.copy(newPath);

      privateParkImage.value = newPath;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }

  Future<void> uploadPrivatePark() async {
    ShowToastDialog.showLoader("please_wait".tr);

    if (privateParkImage.value.isNotEmpty &&
        !Constant().hasValidUrl(privateParkImage.value)) {
      String documentId = pendingDetailPassModel.value.id ?? '';
      privateParkImage.value =
          await Constant.uploadPrivateParkImageToFireStorage(
        File(privateParkImage.value),
        "privateParkImage/$documentId",
        File(privateParkImage.value).path.split('/').last,
      );
    }

    ShowToastDialog.closeLoader();
  }

  Future<void> getProfileData() async {
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

  Future<void> getQueryLot() async {
    isLoading.value = true;
    try {
      final companyName = companyNameController.value.text;
      final startDate = startAtDateController.value.value;
      final validity =
          getApiDuration(selectedPrivatePass.value.validity.toString());
      final response = await server.getRequest(
          endPoint:
              '${APIList.queryLot}companyName=$companyName&startDate=$startDate&validity=$validity');
      if (response != null) {
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          print("Start Date: ${jsonResponse['newStartDate']}");
          print("End Date: ${jsonResponse['newEndDate']}");

          // Update selectedPrivatePass with the new data from the API response
          selectedPrivatePass.value = PrivatePassModel(
            availability: jsonResponse['privatePassModel']['availability'],
            passId: jsonResponse['privatePassModel']['id'],
            passName: jsonResponse['privatePassModel']['passName'],
            price: jsonResponse['privatePassModel']['price'],
            status: jsonResponse['privatePassModel']['status'],
            userType: jsonResponse['privatePassModel']['userType'],
            validity: jsonResponse['privatePassModel']['validity'],
          );

          queryLotModel.value.newStartDate =
              DateTime.parse(jsonResponse['newStartDate']);
          queryLotModel.value.newEndDate =
              DateTime.parse(jsonResponse['newEndDate']);
          queryLotModel.value.privatePassModel?.availability =
              jsonResponse['availability'];
          queryLotModel.value.privatePassModel?.price = jsonResponse['price'];
          queryLotModel.value.privatePassModel?.passId = jsonResponse['id'];
          queryLotModel.value.privatePassModel?.passName =
              jsonResponse['passName'];
          queryLotModel.value.privatePassModel?.validity =
              jsonResponse['validity'];
          queryLotModel.value.privatePassModel?.status = jsonResponse['status'];
          queryLotModel.value.privatePassModel?.userType =
              jsonResponse['userType'];
          queryLotModel.value.privatePassModel = selectedPrivatePass.value;
        } else {
          print("API Error: ${response.reasonPhrase}");
          // Handle error cases based on response status code or reasonPhrase
        }
      } else {
        print("Null Response");
        // Handle null response case
      }
    } catch (e) {
      print("Error fetching query lot: $e");
      // Handle any exceptions that occur during the API call
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addPrivatePassData() async {
    try {
      if (queryLotModel.value.newStartDate != null &&
          queryLotModel.value.newEndDate != null) {
        pendingDetailPassModel.value.id = Constant.getUuid();
        pendingDetailPassModel.value.customerId =
            FireStoreUtils.getCurrentUid();
        pendingDetailPassModel.value.privatePassModel =
            selectedPrivatePass.value;
        pendingDetailPassModel.value.fullName = fullNameController.value.text;
        pendingDetailPassModel.value.reference = referenceController.value.text;
        pendingDetailPassModel.value.email = emailController.value.text;
        pendingDetailPassModel.value.mobileNumber =
            phoneNumberController.value.text;
        pendingDetailPassModel.value.vehicleNo = vehicleNoController.value.text;
        pendingDetailPassModel.value.lotNo = lotNoController.value.text;
        pendingDetailPassModel.value.companyName =
            companyNameController.value.text;
        pendingDetailPassModel.value.companyRegistrationNo =
            companyRegistrationNoController.value.text;
        pendingDetailPassModel.value.address = addressController.value.text;
        pendingDetailPassModel.value.zoneId =
            selectedZone.value?.znId.toString() ?? '';
        pendingDetailPassModel.value.zoneName = selectedZone.value?.znName;
        pendingDetailPassModel.value.roadId =
            selectedRoad.value?.jlnId.toString() ?? '';
        pendingDetailPassModel.value.roadName = selectedRoad.value?.jlnNama;
        pendingDetailPassModel.value.countryCode =
            countryCode.reactive.toString();
        // Set the dates and status
        pendingDetailPassModel.value.startDate =
            queryLotModel.value.newStartDate;
        pendingDetailPassModel.value.endDate = queryLotModel.value.newEndDate!;
        pendingDetailPassModel.value.createAt = DateTime.now();
        pendingDetailPassModel.value.status = "pending";
      } else {
        throw Exception("Query pass data is not available");
      }

      // Now call getRawData()
      Map<String, dynamic> rawData = await getRawData();

      // Print each key-value pair in rawData
      rawData.forEach((key, value) {
        print('Raw Data Key: $key, Value: $value');
      });

      final response = await http.post(
        Uri.parse(APIList.reserveLot.toString()),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(rawData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        ShowToastDialog.showToast(
            "Error occurred while making payment. Status Code: ${response.statusCode}");
        print('Raw Data: $rawData');
        print('Response Body: ${response.body}');
        print(
            "Failed to send data: ${response.statusCode} ${response.reasonPhrase}");
        return false;
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("Error occurred while making payment: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getRawData() async {
    String imageName = privateParkImage.value.split('/').last;
    String base64Image = await convertImageToBase64(privateParkImage.value);

    Map<String, dynamic> privatePassData = {
      "availability": selectedPrivatePass.value.availability,
      "id": selectedPrivatePass.value.passId,
      "passName": selectedPrivatePass.value.passName,
      "price": selectedPrivatePass.value.price,
      "status": selectedPrivatePass.value.status,
      "userType": selectedPrivatePass.value.userType,
      "validity": selectedPrivatePass.value.validity,
    };

    Map<String, dynamic> queryPrivatePassData = {
      "availability": queryLotModel.value.privatePassModel?.availability,
      "id": queryLotModel.value.privatePassModel?.passId,
      "passName": queryLotModel.value.privatePassModel?.passName,
      "price": queryLotModel.value.privatePassModel?.price,
      "status": queryLotModel.value.privatePassModel?.status,
      "userType": queryLotModel.value.privatePassModel?.userType,
      "validity": queryLotModel.value.privatePassModel?.validity,
    };

    // Use the privatePassModel from queryLotModel if it is available
    Map<String, dynamic> effectivePrivatePassModel =
        queryLotModel.value.privatePassModel != null
            ? queryPrivatePassData
            : privatePassData;

    Map<String, dynamic> rawData = {
      "id": Constant.getUuid(),
      "customerId": FireStoreUtils.getCurrentUid(),
      "privatePassModel": effectivePrivatePassModel,
      "fullName": fullNameController.value.text,
      "reference": referenceController.value.text,
      "email": emailController.value.text,
      "identificationNo": identificationNoController.value.text,
      "mobileNumber": phoneNumberController.value.text,
      "vehicleNo": vehicleNoController.value.text,
      "lotNo": lotNoController.value.text,
      "companyName": companyNameController.value.text,
      "companyRegistrationNo": companyRegistrationNoController.value.text,
      "address": addressController.value.text,
      "countryCode": countryCode.value,
      "startDate": pendingDetailPassModel.value.startDate?.toIso8601String(),
      "createAt": pendingDetailPassModel.value.createAt?.toIso8601String(),
      "endDate": pendingDetailPassModel.value.endDate?.toIso8601String(),
      "status": pendingDetailPassModel.value.status,
      "zoneId": selectedZone.value?.znId,
      "zoneName": selectedZone.value?.znName,
      "roadId": selectedRoad.value?.jlnId,
      "roadName": selectedRoad.value?.jlnNama,
      "paymentType": "",
      "imageBase64": base64Image,
      "imageFileName": imageName,
    };

    return rawData;
  }

  Future<String> convertImageToBase64(String imagePath) async {
    try {
      // Compress the image with consistent settings
      Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
        imagePath,
        minWidth: 200,
        minHeight: 200,
        quality: 40,
        format: CompressFormat.jpeg, // Ensure JPEG format for consistency
      );

      if (imageBytes == null) {
        throw Exception("Failed to compress image");
      }

      // Encode the image bytes to Base64
      String base64Image = base64Encode(imageBytes);

      // Ensure the Base64 string has a consistent length (for debugging purposes)
      print("Base64 Image Length: ${base64Image.length}");

      return base64Image;
    } catch (e) {
      print('Error converting image to Base64: $e');
      rethrow; // Rethrow the error after logging it
    }
  }

  int checkDuration(String time) {
    switch (time) {
      case "1 Week":
        return 6;
      case "2 Weeks":
        return 13;
      case "3 Weeks":
        return 20;
      case "1 Month":
        return 29;
      case "3 Months":
        return 89;
      case "6 Months":
        return 179;
      case "12 Months":
        return 364;
      default:
        return 0;
    }
  }

  int getApiDuration(String time) {
    switch (time) {
      case "1 Month":
        return 1;
      case "3 Months":
        return 3;
      case "6 Months":
        return 6;
      case "12 Months":
        return 12;
      default:
        return 0;
    }
  }

  Future<void> onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile = await (source == ImageSource.camera
          ? picker.pickImage(source: ImageSource.camera)
          : picker.pickImage(source: ImageSource.gallery));

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        imageFiles.add(imageFile);
        update();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<List<Zone>> getZone() async {
    final response = await http.get(Uri.parse(APIList.zone.toString()));
    if (response.statusCode == 200) {
      // Parse the response body
      Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> zoneData = responseData['data'];
      // Convert zoneData into a list of Zone objects
      List<Zone> zones = zoneData.map((zone) => Zone.fromJson(zone)).toList();
      return zones;
    } else {
      ShowToastDialog.showToast(
          "Error occurred while fetching zones. Status Code: ${response.statusCode}");
      return []; // Return an empty list in case of error
    }
  }

  Future<List<Road>> getRoad(int zoneId) async {
    final response = await http.get(Uri.parse("${APIList.road}$zoneId"));
    if (response.statusCode == 200) {
      // Parse the response body
      Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> roadData = responseData['data'];
      // Convert roadData into a list of Road objects
      List<Road> roads = roadData.map((road) => Road.fromJson(road)).toList();
      return roads;
    } else {
      ShowToastDialog.showToast(
          "Error occurred while fetching roads. Status Code: ${response.statusCode}");
      return []; // Return an empty list in case of error
    }
  }
}

class DateController extends ValueNotifier<DateTime?> {
  DateController([DateTime? value]) : super(value);
}
