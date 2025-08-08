import 'package:customer_app/app/models/contact_us_model.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class ContactUsScreenController extends GetxController {
  Rx<ContactUsModel> contactUsModel = ContactUsModel().obs;
  RxBool isLoading = true.obs;



  @override
  void onInit() {
    getContactUs();
    super.onInit();
  }

  getContactUs() {
    FireStoreUtils.getContactUsInformation().then((value) {
      if (value != null) {
        contactUsModel.value = value;
        isLoading.value = false;
      }
    });
  }
}
