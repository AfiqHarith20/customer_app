import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/news_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewsDetailScreenController extends GetxController {
  RxBool isLoading = false.obs;
  late String title;
  late String des;
  late String date;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    title = args['title'] ?? '';
    des = args['des'] ?? '';
    final dynamic pubDate =
        args['date']; // This might be a Timestamp or a String
    date = _formatDate(pubDate);
  }

  String _formatDate(dynamic date) {
    try {
      DateTime dateTime;
      if (date is DateTime) {
        dateTime = date;
      } else if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is Timestamp) {
        dateTime = date.toDate();
      } else {
        return ''; // Handle unexpected date type
      }
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return ''; // Return empty string if parsing fails
    }
  }

  @override
  void dispose() {
    //FireStoreUtils().getNearestParkingRequestController!.close();
    super.dispose();
  }
}
