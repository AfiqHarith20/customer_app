import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingDetailScreenController extends GetxController {
  Rx<ParkingModel> parkingModel = ParkingModel().obs;
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  GoogleMapController? mapController;
  BitmapDescriptor? currentLocationMarker;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    addMarkerSetup();
    dynamic argument = Get.arguments;
    if (argument != null) {
      parkingModel.value = argument['parkingModel'];
      await FireStoreUtils.getParkingDetail(parkingModel.value.id.toString()).then((value) {
        if (value != null) {
          parkingModel.value.images = value.images;
          addMarker(latitude: value.location!.latitude, longitude: value.location!.longitude, id: "", descriptor: currentLocationMarker!);
        }
      });
    }
  }

  addMarkerSetup() async {
    final Uint8List parking = await Constant().getBytesFromAsset("assets/icons/ic_map_pin.png", 100);
    currentLocationMarker = BitmapDescriptor.fromBytes(parking);
  }

  addMarker({
    required double? latitude,
    required double? longitude,
    required String id,
    required BitmapDescriptor descriptor,
  }) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
      onTap: () {},
    );
    markers[markerId] = marker;
    update();
  }

  double calculateTotalDistance() {
    double totalDistance = Geolocator.distanceBetween(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude,
        parkingModel.value.location!.latitude!, parkingModel.value.location!.longitude!);

    return totalDistance / 1000;
  }
}
