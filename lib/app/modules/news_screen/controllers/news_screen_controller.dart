import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NewsScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> newsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInformationNews();
  }

  void fetchInformationNews() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('information').get();

      List<Map<String, dynamic>> fetchedItems = querySnapshot.docs.map((doc) {
        return {
          "des": doc.data()['desc'].toString(),
          "link": doc.data()['link'].toString(),
          "read": doc.data()['read'].toString(),
          "title": doc.data()['title'].toString(),
          "pubDate": doc.data()['date'].toString(),
          "categories": doc.data()['categories'].toString(),
        };
      }).toList();
      newsList.assignAll(fetchedItems);
    } catch (e) {
      print('Error fetching information: $e');
    }
  }

  @override
  void dispose() {
    //FireStoreUtils().getNearestParkingRequestController!.close();
    super.dispose();
  }
}
