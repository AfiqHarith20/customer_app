import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class LikeScreenController extends GetxController {
  RxList<ParkingModel> likedParkingList = <ParkingModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getLikedParkingList();
    super.onInit();
  }

  getLikedParkingList() async {
    await FireStoreUtils.getLikedParkingList().then((value) {
      if (value != null) {
        likedParkingList.value = value;
        isLoading.value = false;
      }
    });
  }

  removeLikedParking(ParkingModel parkingModel) async {
    parkingModel.likedUser!.remove(FireStoreUtils.getCurrentUid());
    await FireStoreUtils.saveParkingDetails(parkingModel).then((value) {
      likedParkingList.remove(parkingModel);
      likedParkingList.refresh();
    });
  }
}
