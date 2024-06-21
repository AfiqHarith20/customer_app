import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/utils/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreenController extends GetxController {
  RxBool isLoading = true.obs;
  Server server = Server();
  RxList<Map<String, dynamic>> transactionHistoryList =
      <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> originalTransactionHistoryList =
      <Map<String, dynamic>>[];

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void onInit() {
    super.onInit();
    getTransactionHistory();
  }

  Future<void> getTransactionHistory() async {
    isLoading.value = true;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(CollectionName.transacHistory)
              .doc(getCurrentUid())
              .collection('history')
              .get();

      List<Map<String, dynamic>> fetchedItems = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();

        // Check the type of createAt and convert accordingly
        DateTime dateTime;
        if (data['createAt'] is Timestamp) {
          dateTime = (data['createAt'] as Timestamp).toDate();
        } else if (data['createAt'] is String) {
          try {
            dateTime = DateFormat("d/M/yyyy h:mm:ss a").parse(data['createAt']);
          } catch (e) {
            dateTime =
                DateTime.now(); // Fallback to current time if parsing fails
          }
        } else {
          dateTime =
              DateTime.now(); // Fallback to current time if type is unknown
        }

        return {
          "amount": data['amount']?.toString() ?? '',
          "channelId": data['channelId']?.toString() ?? '',
          "createAt": dateTime, // Store as DateTime
          "credit": data['credit'],
          "passType": data['passType'] ?? '',
          "id": data['id']?.toString() ?? '',
          "paymentType": data['paymentType']?.toString() ?? '',
          "providerChannelId": data['providerChannelId']?.toString() ?? '',
          "providerTransactionNumber":
              data['providerTransactionNumber']?.toString() ?? '',
          "referenceCode": data['referenceCode']?.toString() ?? '',
          "providerPaymentMethod":
              data['providerPaymentMethod']?.toString() ?? '',
          "status": data['status'] ?? 0,
          "transactionType": data['transactionType']?.toString() ?? '',
          "transactionNumber": data['transactionNumber']?.toString() ?? '',
        };
      }).toList();

      // Sort items by createAt in descending order
      fetchedItems.sort((a, b) {
        return b['createAt'].compareTo(a['createAt']);
      });

      transactionHistoryList.assignAll(fetchedItems);
      originalTransactionHistoryList = fetchedItems;
      print('Fetched items: $fetchedItems');
    } catch (e) {
      print('Error fetching information: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterTransactions(DateTime startDate, DateTime endDate) {
    List<Map<String, dynamic>> filteredTransactions =
        originalTransactionHistoryList.where((transaction) {
      DateTime createAt = transaction['createAt'];
      return createAt.isAfter(startDate) && createAt.isBefore(endDate);
    }).toList();

    transactionHistoryList.assignAll(filteredTransactions);
    print('Filtered transactions: $filteredTransactions');
  }
}
