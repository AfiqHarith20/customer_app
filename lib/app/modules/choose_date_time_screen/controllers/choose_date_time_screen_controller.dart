import 'dart:convert';
import 'dart:developer';

import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChooseDateTimeScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingNumber = false.obs;
  RxString currentMonth = DateFormat.yMMMM().format(DateTime.now()).obs;
  Rx<DateTime> selectedDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;
  Rx<TextEditingController> selectedDateController = TextEditingController().obs;
  Rx<TextEditingController> plateNumberController = TextEditingController().obs;
  ImagePicker picker = ImagePicker();

  Rx<ParkingModel> parkingModel = ParkingModel().obs;

  RxDouble selectedDuration = 2.0.obs;
  Rx<DateTime> startTime = DateTime.now().obs;
  Rx<DateTime> endTime = DateTime.now().obs;

  Rx<TextEditingController> startTimeController = TextEditingController().obs;
  Rx<TextEditingController> endTimeController = TextEditingController().obs;

  @override
  void onInit() {
    selectedDateController.value.text = DateFormat("dd MMMM yyyy").format(selectedDateTime.value);
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      parkingModel.value = argumentData['parkingModel'];
      getParkingDetails();
    }

    isLoading.value = false;
    update();
  }

  RxList<MyPurchasePassModel> mySeasonPassList = <MyPurchasePassModel>[].obs;
  Rx<MyPurchasePassModel> selectedSeasonPass = MyPurchasePassModel().obs;
  getParkingDetails() async {
    await FireStoreUtils.getParkingDetail(parkingModel.value.id.toString()).then((value) {
      if (value != null) {
        parkingModel.value = value;
      }
    });

    await FireStoreUtils.getMySeasonPassData().then((value) {
      if (value != null) {
        mySeasonPassList.value = value;
        print('----------->${mySeasonPassList.length}');
      }
    });
  }

  calculateParkingAmount() {
    return double.parse(parkingModel.value.perHrRate.toString()) * double.parse(selectedDuration.value.toString());
  }

  String calculateDuration(String? startTime, String? endTime) {
    if (startTime != null && startTime.isNotEmpty && endTime != null && endTime.isNotEmpty) {
      return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(endTime.split(":").first), int.parse(endTime.split(":").last))
          .difference(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(startTime.split(":").first), int.parse(startTime.split(":").last)))
          .inHours
          .toString();
    } else {
      return "";
    }
  }

  getLicensePlate() async {
    // pick an image
    final pickedFile = await getImage();

    if (pickedFile == null) {
      return null;
    }
    isLoadingNumber.value = true;
    // make request to 3rd party api for better alpr
    // -------------------------------------------------------------
    Map<String, String> headers = {"Authorization": "Token ${Constant.plateRecognizerApiToken}"};
    var alprRequest = http.MultipartRequest("POST", Uri.parse('https://api.platerecognizer.com/v1/plate-reader/'));
    var alprPic = await http.MultipartFile.fromPath("upload", pickedFile.path);
    alprRequest.files.add(alprPic);
    alprRequest.headers.addAll(headers);
    alprRequest.fields["regions"] = "in";
    var alprRes = await alprRequest.send();
    var alprResponseData = await alprRes.stream.toBytes();
    var alprResponseString = String.fromCharCodes(alprResponseData);
    var alprResults = jsonDecode(alprResponseString)["results"];

    log("::::::::::::>>>>>>:::::${alprResults}::::::::::");
    if (alprResults != null && alprResults.length > 0) {
      imageCache.clear();
      plateNumberController.value.text = alprResults[0]["plate"].toUpperCase();
      isLoadingNumber.value = false;
    } else {
      imageCache.clear();
      isLoadingNumber.value = false;
    }
  }

  Future getImage() async {
    ImageSource imageSource = ImageSource.camera;
    final pickedFile = await picker.pickImage(source: imageSource);
    return pickedFile;
  }
}
