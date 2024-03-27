import 'dart:developer';
import 'package:customer_app/app/models/location_lat_lng.dart';
import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/carousel_model.dart';
import '../../../models/customer_model.dart';

class HomeController extends GetxController {
  //RxBool isLoading = false.obs;
  //Rx<TextEditingController> addressController = TextEditingController().obs;
  //RxList<ParkingModel> parkingList = <ParkingModel>[].obs;
  //Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  var box = GetStorage();
  RxBool isLoading = false.obs;
  RxList<CarouselModel> carouselData = <CarouselModel>[].obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;

  @override
  void onInit() {
    getProfileData();
    fetchCarousel();
    if(box.read('carouselData') != null)
      carouselData.assignAll(box.read('carouselData'));
    super.onInit();
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        customerModel.value = value;
      }
    });
  }

  void fetchCarousel() async {
    try{
      isLoading = true.obs;
      update();

      List<CarouselModel>? data = await FireStoreUtils.getCarousel();
      if(data != null){
        carouselData.assignAll(data);
        box.write('carouselData', data);
      }
    }finally{
      isLoading = false.obs;
      update();
      print('data fetch done');
    }
  }

  // getCurrentLocation() async {
  //   Constant.currentLocation = await Utils.getCurrentLocation();
  //   locationLatLng.value = LocationLatLng(latitude: Constant.currentLocation!.latitude, longitude: Constant.currentLocation!.longitude);
  //   List<Placemark> placeMarks = await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude);
  //   Constant.country = placeMarks.first.country;
  //   getTax();
  //   getNearbyParking();
  // }

  // getTax() async {
  //   await FireStoreUtils().getTaxList().then((value) {
  //     if (value != null) {
  //       Constant.taxList = value;
  //     }
  //   });
  // }

  // getNearbyParking() {
  //   FireStoreUtils()
  //       .getParkingNearest(
  //           latitude: locationLatLng.value.latitude,
  //           longLatitude: locationLatLng.value.longitude)
  //       .listen((event) {
  //     parkingList.value = event;

  //     parkingList.refresh();
  //     isLoading.value = true;
  //   });
  // }

  // addLikedParking(ParkingModel parkingModel) async {
  //   log("add-->>");
  //   parkingModel.likedUser!.add(FireStoreUtils.getCurrentUid());

  //   await FireStoreUtils.saveParkingDetails(parkingModel).then((value) {});
  // }

  // removeLikedParking(ParkingModel parkingModel) async {
  //   log("Remove-->>");
  //   parkingModel.likedUser!.remove(FireStoreUtils.getCurrentUid());

  //   await FireStoreUtils.saveParkingDetails(parkingModel).then((value) {});
  // }

  @override
  void dispose() {
    //FireStoreUtils().getNearestParkingRequestController!.close();
    super.dispose();
  }
}
