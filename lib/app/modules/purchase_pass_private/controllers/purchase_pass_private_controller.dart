import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';
import 'package:customer_app/app/models/pending_detail_pass_model.dart';
import 'package:customer_app/app/models/pending_pass_model.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/app/modules/Season_pass/controllers/season_pass_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  Rx<PrivatePassModel> selectedPrivatePass = PrivatePassModel().obs;
  Rx<PendingDetailPassModel> paymentType = PendingDetailPassModel().obs;

  Rx<PendingDetailPassModel> pendingDetailPassModel =
      PendingDetailPassModel().obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxList<PrivatePassModel> privatePassList = <PrivatePassModel>[].obs;
  RxList<File> imageFiles = <File>[].obs;
  final ImagePicker imagePicker = ImagePicker();
  final bool selectedSegment = Get.arguments['selectedSegment'];
  final SeasonPassController seasonPassController = Get.find();

  void clearFormData() {
    vehicleNoController.value.clear();
    lotNoController.value.clear();
    companyNameController.value.clear();
    companyRegistrationNoController.value.clear();
    addressController.value.clear();
    referenceController.value.clear();
    privateParkImage.value = "";
    // Add similar lines for other controllers as needed
  }

  // Dispose method for cleanup (optional in this case)
  @override
  void onClose() {
    clearFormData(); // Clear form data when the controller is closed
    super.onClose();
  }

  void removeImage(int index) {
    imageFiles.removeAt(index);
  }

  Rx<CustomerModel> customerModel = CustomerModel().obs;
  XFile? imageFile;

  bool isImageSelected() {
    return imageFiles.isNotEmpty;
  }

  @override
  void onInit() {
    getArgument();
    getProfileData();
    super.onInit();
  }

  void navigateBackToSeasonPassView() {
    // Put your navigation logic here
    Get.back();
    // After navigating back, update the selected segment in SeasonPassController
    seasonPassController.changeSegment(
        false); // Set the selected segment to false (Season Pass)
  }

  getArgument() async {
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

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      privateParkImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }

  uploadPrivatePark() async {
    ShowToastDialog.showLoader("please_wait".tr);

    // Check if privateParkImage is not empty and is a valid URL
    if (privateParkImage.value.isNotEmpty &&
        Constant().hasValidUrl(privateParkImage.value) == false) {
      // Retrieve the document ID from pendingDetailPassModel.value
      String documentId = pendingDetailPassModel.value.id ?? '';

      // Upload the image to Firebase Storage using the folder path gs://nazifa-parking-29f2b.appspot.com/{documentId}
      privateParkImage.value =
          await Constant.uploadPrivateParkImageToFireStorage(
        File(privateParkImage.value),
        "privateParkImage/$documentId",
        File(privateParkImage.value).path.split('/').last,
      );
    }

    // Close loader after image upload
    ShowToastDialog.closeLoader();
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

  Future<String> postReservePassData() async {
    try {
      print('Add Reserve Pass...');

      Map<String, dynamic> rawData = await getRawData();

      // Print each item of raw data
      // rawData.forEach((key, value) {
      //   print('$key: $value');
      // });

      final response = await http.post(
        Uri.parse(APIList.reserveLot.toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(rawData),
      );

      if (response.statusCode == 200) {
        // Success
        print('Reserve Pass added successfully.');
        print(response.body);
        return response.body;
      } else {
        // Error
        print('Error occurred while adding Reserve Pass.');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        ShowToastDialog.showToast(
            "Error occurred while making payment. Status Code: ${response.statusCode}");
        return '';
      }
    } catch (e, s) {
      // Exception
      log("$e \n$s");
      ShowToastDialog.showToast("Error occurred while making payment: $e");
      return '';
    }
  }

  addPrivatePassData() async {
    try {
      pendingDetailPassModel.value.id = Constant.getUuid();
      pendingDetailPassModel.value.customerId = FireStoreUtils.getCurrentUid();
      pendingDetailPassModel.value.privatePassModel = selectedPrivatePass.value;
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
      pendingDetailPassModel.value.countryCode =
          countryCode.reactive.toString();
      // Convert DateTime values to String
      pendingDetailPassModel.value.startDate = DateTime.now();
      pendingDetailPassModel.value.createAt = DateTime.now();
      pendingDetailPassModel.value.endDate = DateTime.now().add(
        Duration(
            days: checkDuration(selectedPrivatePass.value.validity.toString())),
      );
      pendingDetailPassModel.value.status = "pending";

      await postReservePassData();
      return true;
    } catch (e) {
      // Handle any exceptions
      print('Error adding private pass data: $e');
      return false;
    }
  }

  getRawData() async {
    // Retrieve the filename from the privateParkImage path
    String imageName = privateParkImage.value.split('/').last;

    // Convert the image to base64
    String base64Image = await convertImageToBase64(privateParkImage.value);

    // Create a Map for privatePassModel
    Map<String, dynamic> privatePassData = {
      "availability": selectedPrivatePass.value.availability,
      "id": selectedPrivatePass.value.passId,
      "passName": selectedPrivatePass.value.passName,
      "price": selectedPrivatePass.value.price,
      "status": selectedPrivatePass.value.status,
      "userType": selectedPrivatePass.value.userType,
      "validity": selectedPrivatePass.value.validity,
    };

    // Create the raw data JSON structure
    Map<String, dynamic> rawData = {
      "id": Constant.getUuid(),
      "customerId": FireStoreUtils.getCurrentUid(),
      "privatePassModel": privatePassData,
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
      "startDate": pendingDetailPassModel.value.startDate?.toString(),
      "createAt": pendingDetailPassModel.value.createAt?.toString(),
      "endDate": pendingDetailPassModel.value.endDate?.toString(),
      "status": pendingDetailPassModel.value.status,
      "paymentType": "",
      "imageBase64": base64Image,
      "imageFileName": imageName,
    };

    return rawData;
  }

  Future<String> convertImageToBase64(String imagePath) async {
    // Read the bytes from the image file
    List<int> imageBytes = await File(imagePath).readAsBytes();

    // Convert the bytes to base64
    String base64Image = base64Encode(imageBytes);

    // Check if the base64 string starts with "/9j/"

    return base64Image;
  }

  // Future<String> uploadPrivateParkImage() async {
  //   // Check if privateParkImage is not empty and is a valid URL
  //   if (privateParkImage.value.isNotEmpty &&
  //       Constant().hasValidUrl(privateParkImage.value) == false) {
  //     // Retrieve the document ID from pendingDetailPassModel.value
  //     String documentId = pendingDetailPassModel.value.id ?? '';

  //     // Upload the image to Firebase Storage using the folder path gs://nazifa-parking-29f2b.appspot.com/{documentId}
  //     String imagePath = await Constant.uploadPrivateParkImageToFireStorage(
  //       File(privateParkImage.value),
  //       "parkinglot/$documentId",
  //       File(privateParkImage.value).path.split('/').last,
  //     );

  //     return imagePath;
  //   }

  //   return ''; // Return empty string if no image uploaded
  // }

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
  }

  // pendingOrder() async {
  //   await FireStoreUtils.setPendingPass(pendingDetailPassModel.value, imageFile)
  //       .then((value) {
  //     Get.back();
  //     Get.toNamed(Routes.DASHBOARD_SCREEN);
  //   });
  // }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFileGallery =
        await picker.pickImage(source: ImageSource.gallery);
    final pickedFileCamera = await picker.pickImage(source: ImageSource.camera);

    if (pickedFileGallery != null) {
      final image = File(pickedFileGallery.path);
      final compressedImage = await compressImage(image);
      imageFile = compressedImage;
      update();
    } else if (pickedFileCamera != null) {
      final image = File(pickedFileCamera.path);
      final compressedImage = await compressImage(image);
      imageFile = compressedImage;
      update();
    }
  }

  Future<XFile?> compressImage(File image) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      image.absolute.path,
      quality: 50, // Adjust quality as needed
    );
    return result;
  }

  Future<void> onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile;

      if (source == ImageSource.camera) {
        pickedFile = await picker.pickImage(source: ImageSource.camera);
      } else {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        imageFiles.add(imageFile); // Add the selected image to the list
        update(); // Update the UI
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
