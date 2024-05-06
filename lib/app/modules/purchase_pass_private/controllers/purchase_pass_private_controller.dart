import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';
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

  Rx<PendingPassModel> pendingPassModel = PendingPassModel().obs;
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
      // Retrieve the document ID from pendingPassModel.value
      String documentId = pendingPassModel.value.id ?? '';

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
      final response = await http.post(
        Uri.parse(APIList.reserveLot.toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(pendingPassModel.value.toJson()),
      );
      return response.body;
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("Error occurred while making payment: $e");
      return '';
    }
  }

  addPrivatePassData() async {
    pendingPassModel.value.id = Constant.getUuid();
    pendingPassModel.value.customerId = FireStoreUtils.getCurrentUid();
    pendingPassModel.value.privatePassModel = selectedPrivatePass.value;
    pendingPassModel.value.fullName = fullNameController.value.text;
    pendingPassModel.value.reference = referenceController.value.text;
    pendingPassModel.value.email = emailController.value.text;
    pendingPassModel.value.identificationNo =
        identificationNoController.value.text;
    pendingPassModel.value.mobileNumber = phoneNumberController.value.text;
    pendingPassModel.value.vehicleNo = vehicleNoController.value.text;
    pendingPassModel.value.lotNo = lotNoController.value.text;
    pendingPassModel.value.companyName = companyNameController.value.text;
    pendingPassModel.value.companyRegistrationNo =
        companyRegistrationNoController.value.text;
    pendingPassModel.value.address = addressController.value.text;
    pendingPassModel.value.countryCode = countryCode.reactive.toString();
    pendingPassModel.value.startDate = Timestamp.now();
    pendingPassModel.value.createAt = Timestamp.now();
    pendingPassModel.value.endDate = Timestamp.fromDate(
      DateTime.timestamp().add(
        Duration(
          days: checkDuration(
            selectedPrivatePass.value.validity.toString(),
          ),
        ),
      ),
    );

    print('Pending Pass Data:');
    print('ID: ${pendingPassModel.value.id}');
    print('Customer ID: ${pendingPassModel.value.customerId}');
    print('Private Pass Model: ${pendingPassModel.value.privatePassModel}');
    print('Full Name: ${pendingPassModel.value.fullName}');
    print('Reference: ${pendingPassModel.value.reference}');
    print('Email: ${pendingPassModel.value.email}');
    print('Identification No: ${pendingPassModel.value.identificationNo}');
    print('Mobile Number: ${pendingPassModel.value.mobileNumber}');
    print('Vehicle No: ${pendingPassModel.value.vehicleNo}');
    print('Lot No: ${pendingPassModel.value.lotNo}');
    print('Company Name: ${pendingPassModel.value.companyName}');
    print(
        'Company Registration No: ${pendingPassModel.value.companyRegistrationNo}');
    print('Address: ${pendingPassModel.value.address}');
    print('Country Code: ${pendingPassModel.value.countryCode}');
    print('Start Date: ${pendingPassModel.value.startDate}');
    print('Create At: ${pendingPassModel.value.createAt}');
    print('End Date: ${pendingPassModel.value.endDate}');

    String imageName = File(privateParkImage.value).path.split('/').last;
    pendingPassModel.value.imageFileName = imageName;

    String base64Image = await convertImageToBase64(privateParkImage.value);
    pendingPassModel.value.imageBase64 = base64Image;

    print('Base64 Image: $base64Image');
    print('Image Name: $imageName');

    // Upload the image and get the URL
    // String imagePath = await uploadPrivateParkImage();

    // Set the image path in the pendingPassModel
    // pendingPassModel.value.imageBase64 = imagePath;

    // Setting default status as "pending"
    pendingPassModel.value.status = "pending";

    // Now, send the data to Firestore
    await postReservePassData();
  }

  Future<String> convertImageToBase64(String imagePath) async {
    // Read the bytes from the image file
    List<int> imageBytes = await File(imagePath).readAsBytes();

    // Convert the bytes to base64
    String base64Image = base64Encode(imageBytes);

    // Check if the base64 string starts with "/9j/"
    if (base64Image.startsWith("/9j/")) {
      // Remove "/9j/" from the beginning of the base64 string
      base64Image = base64Image.substring(4);
    }

    return base64Image;
  }

  // Future<String> uploadPrivateParkImage() async {
  //   // Check if privateParkImage is not empty and is a valid URL
  //   if (privateParkImage.value.isNotEmpty &&
  //       Constant().hasValidUrl(privateParkImage.value) == false) {
  //     // Retrieve the document ID from pendingPassModel.value
  //     String documentId = pendingPassModel.value.id ?? '';

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
  //   await FireStoreUtils.setPendingPass(pendingPassModel.value, imageFile)
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
