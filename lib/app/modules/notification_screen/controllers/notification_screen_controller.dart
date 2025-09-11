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
  RxInt notificationCount = RxInt(0);
  RxInt activityCount = RxInt(0);

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
          "isRead":
              doc.data()['isRead'].toString() == 'true', // Convert to bool
          "documentId": doc.id,
        };
      }).toList();
      // Sort notifications by createAt in descending order
      fetchedNotifications.sort((a, b) {
        return b['createAt'].compareTo(a['createAt']);
      });

      notifyList.assignAll(fetchedNotifications);

      // Update counts after fetching notifications
      getNotificationCount();
      getActivityCount();
    } catch (e) {
      print('Error fetching information: $e');
    } finally {
      isLoading.value = false;
    }
  }

  loadNotifications() async {
    try {
      isLoading(true); // Set loading state to true

      // Replace this with your actual Firestore collection reference
      var snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .doc(getCurrentUid())
          .collection('messages')
          .orderBy('createAt', descending: true)
          .get();

      // Clear existing notifications before adding new ones
      notifyList.clear();

      // Add notifications from Firestore to the notifyList
      notifyList.addAll(snapshot.docs.map((doc) => doc.data()));

      isLoading(false); // Set loading state to false
    } catch (e) {
      print('Error loading notifications: $e');
      isLoading(false); // Set loading state to false on error
    }
  }

  // Getter to count unread notifications
  int get unreadCount => notifyList
      .where((notification) => notification['isRead'] == false)
      .length;

  void getNotificationCount() {
    if (notifyList.isNotEmpty) {
      // Count notifications in the notifyList where category is not 'Petak Khas'
      notificationCount.value = notifyList
          .where((notification) =>
              notification['category'] != 'Petak Khas' &&
              notification['isRead'] == false)
          .length;
    } else {
      notificationCount.value = 0;
    }
  }

  void getActivityCount() {
    if (notifyList.isNotEmpty) {
      // Count notifications in the notifyList where category is 'Petak Khas'
      activityCount.value = notifyList
          .where((notification) =>
              notification['category'] == 'Petak Khas' &&
              notification['isRead'] == false)
          .length;
    } else {
      activityCount.value = 0;
    }
  }

  void toggleEditMode() {
    isInEditMode.value = !isInEditMode.value;
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
            notifyList[index]['documentId']; // Get the document ID
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

  void markAllSelectedAsRead() async {
    for (var index in selectedIndexes) {
      markAsRead(index);
    }
    toggleEditMode();
  }

  void markAsRead(int index) async {
    try {
      String documentId =
          notifyList[index]['documentId']; // Get the document ID
      await FirebaseFirestore.instance
          .collection(CollectionName.notifications)
          .doc(getCurrentUid())
          .collection('messages')
          .doc(documentId)
          .update({'isRead': true});

      // Update the local state
      notifyList[index]['isRead'] = true;
      notifyList.refresh(); // Call refresh to update the UI
      getNotificationCount();
      getActivityCount();
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}
