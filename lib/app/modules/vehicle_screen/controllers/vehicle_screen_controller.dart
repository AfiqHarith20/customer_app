import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/vehicle_model.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VehicleScreenController extends GetxController {
  RxBool isLoading = false.obs;
  final _error = ''.obs;
  RxList<Map<String, dynamic>> vehicleList = <Map<String, dynamic>>[].obs;
  Rx<VehicleModel> customerVehicleModel = VehicleModel().obs;

  get error => _error.value;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void onInit() {
    super.onInit();
    fetchVehicle();
  }

  Future<void> fetchVehicle() async {
    try {
      isLoading.value = true;
      print('Fetching vehicle data for user: ${getCurrentUid()}');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(CollectionName.custVehicle)
              .doc(getCurrentUid())
              .collection('vehicles')
              .where('active', isEqualTo: true)
              .get();

      List<Map<String, dynamic>> vehicleInfo = querySnapshot.docs.map((doc) {
        print('Document data: ${doc.data()}');
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

      // Sort vehicleInfo to have default vehicles first
      vehicleInfo.sort((a, b) {
        var aDefault = a['default'] ?? false;
        var bDefault = b['default'] ?? false;
        if (aDefault && !bDefault) {
          return -1;
        } else if (!aDefault && bDefault) {
          return 1;
        } else {
          return 0;
        }
      });

      print('Fetched and sorted vehicle data: $vehicleInfo');

      vehicleList.assignAll(vehicleInfo);
      if (vehicleInfo.isNotEmpty) {
        customerVehicleModel.value = VehicleModel.fromJson(vehicleInfo.first);
      } else {
        customerVehicleModel.value =
            VehicleModel(); // Reset the model if no vehicles
        print('No active vehicles found for user: ${getCurrentUid()}');
      }
    } catch (e) {
      print('Error fetching information: $e');
      _error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void refreshVehicleData() {
    fetchVehicle();
  }
}
