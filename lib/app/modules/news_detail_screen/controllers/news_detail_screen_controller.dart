import 'package:get/get.dart';

class NewsDetailScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxString titleValue = ''.obs;
  RxString desValue = ''.obs;
  RxString dateValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewsDetail();
  }

  @override
  void dispose() {
    //FireStoreUtils().getNearestParkingRequestController!.close();
    super.dispose();
  }

  void fetchNewsDetail() {
    // Access arguments passed while navigating
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      titleValue.value = args['title'] ?? '';
      desValue.value = args['des'] ?? '';
      dateValue.value = args['date'] ?? '';
    }
    isLoading.value = false;
  }
}
