import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/notification_model.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class NotificationScreenController extends GetxController {
  RxList<Map<String, dynamic>> notifyList = <Map<String, dynamic>>[].obs;
  Rx<NotificationModel> notificationModel = NotificationModel().obs;
  RxBool isLoading = false.obs;
  RxBool isInEditMode = false.obs;
  RxList<int> selectedIndexes = <int>[].obs;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void onInit() {
    super.onInit();
    fetchInformation();
  }

  fetchInformation() async {
    try {
      isLoading.value = true;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(CollectionName.notifications)
              .doc(getCurrentUid())
              .collection('messages')
              .get();

      List<Map<String, dynamic>> fetchedNotifications =
          querySnapshot.docs.map((doc) {
        return {
          "title": doc.data()['title'].toString(),
          "createAt": doc.data()['createAt'],
          "category": doc.data()['category'].toString(),
          "reference": doc.data()['reference'].toString(),
          "message": doc.data()['message'].toString(),
          "isRead": doc.data()['isRead'].toString(),
        };
      }).toList();
      // Sort notifications by createAt in descending order
      fetchedNotifications.sort((a, b) {
        return b['createAt'].compareTo(a['createAt']);
      });

      notifyList.assignAll(fetchedNotifications);
    } catch (e) {
      print('Error fetching information: $e');
    }
    isLoading.value = false;
  }

  void toggleEditMode() {
    isInEditMode.toggle();
    // Clear selected indexes when exiting edit mode
    if (!isInEditMode.value) {
      selectedIndexes.clear();
    }
  }

  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  bool isSelected(int index) {
    return selectedIndexes.contains(index);
  }

  bool isAllSelected() {
    return selectedIndexes.length == notifyList.length;
  }

  void toggleSelectAll(bool value) {
    if (value) {
      selectedIndexes.clear();
      selectedIndexes
          .addAll(List.generate(notifyList.length, (index) => index));
    } else {
      selectedIndexes.clear();
    }
  }

  void deleteSelectedNotifications() async {
    try {
      selectedIndexes.sort((a, b) => b.compareTo(a));
      for (var index in selectedIndexes) {
        String documentId =
            notifyList[index]['reference']; // Get the document ID
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(getCurrentUid())
            .collection('messages')
            .doc(documentId)
            .delete(); // Delete the document from Firestore
        notifyList.removeAt(index);
      }
      // Clear selected indexes after deletion
      selectedIndexes.clear();
    } catch (e) {
      print('Error deleting notifications: $e');
    }
  }

  markSelectedAsRead() async {
    try {
      for (var index in selectedIndexes) {
        String documentId =
            notifyList[index]['reference']; // Get the document ID
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(getCurrentUid())
            .collection('messages')
            .doc(documentId)
            .update({'isRead': true}); // Update the 'isRead' field to true
        notifyList[index]['isRead'] = true; // Update locally as well
      }
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }

  @override
  void dispose() {
    //FireStoreUtils().getNearestParkingRequestController!.close();
    super.dispose();
  }
}
