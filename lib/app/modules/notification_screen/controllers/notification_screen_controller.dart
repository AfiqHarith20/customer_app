import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/notification_model.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class NotificationScreenController extends GetxController {
  // Reactive lists and booleans
  RxList<Map<String, dynamic>> notifyList = <Map<String, dynamic>>[].obs;
  Rx<NotificationModel> notificationModel = NotificationModel().obs;
  RxBool isLoading = false.obs;
  RxBool isInEditMode = false.obs;
  RxList<int> selectedIndexes = <int>[].obs;

  // Use reactive getters for the counts
  // This is more efficient as it automatically updates when notifyList changes
  RxInt get unreadCount => notifyList
      .where((notification) => notification['isRead'] == false)
      .length
      .obs;

  RxInt get notificationCount => notifyList
      .where((notification) =>
          notification['category'] != 'Petak Khas' &&
          notification['isRead'] == false)
      .length
      .obs;

  RxInt get activityCount => notifyList
      .where((notification) =>
          notification['category'] == 'Petak Khas' &&
          notification['isRead'] == false)
      .length
      .obs;

  // Stream subscription to manage the Firestore stream
  StreamSubscription? _notificationSubscription;

  @override
  void onInit() {
    super.onInit();
    // Start listening to real-time changes
    listenToNotifications();
  }

  /// Sets up a real-time listener for user notifications.
  /// This is the most efficient way to fetch data and keep the UI updated.
  void listenToNotifications() {
    final userUid = FireStoreUtils.getCurrentUid();
    if (userUid.isEmpty) {
      print('User is not logged in. Cannot listen to notifications.');
      return;
    }

    // Cancel any previous subscriptions to avoid duplicate listeners
    _notificationSubscription?.cancel();
    _notificationSubscription = FirebaseFirestore.instance
        .collection(CollectionName.notifications)
        .doc(userUid)
        .collection('messages')
        .orderBy('createAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      try {
        List<Map<String, dynamic>> fetchedNotifications =
            snapshot.docs.map((doc) {
          return {
            "title": doc.data()['title'].toString(),
            "createAt": doc.data()['createAt'],
            "category": doc.data()['category'].toString(),
            "reference": doc.data()['reference'].toString(),
            "message": doc.data()['message'].toString(),
            "isRead": doc.data()['isRead'] as bool? ?? false,
            "documentId": doc.id,
          };
        }).toList();

        // Update the reactive list, which will trigger UI rebuilds
        notifyList.assignAll(fetchedNotifications);
      } catch (e) {
        print('Error updating notifications from stream: $e');
      }
    });
  }

  /// Toggles the edit mode and clears selected items.
  void toggleEditMode() {
    isInEditMode.value = !isInEditMode.value;
    if (!isInEditMode.value) {
      selectedIndexes.clear();
    }
  }

  /// Toggles the selection state of a notification at a given index.
  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  /// Checks if a notification at a given index is selected.
  bool isSelected(int index) {
    return selectedIndexes.contains(index);
  }

  /// Checks if all notifications are selected.
  bool isAllSelected() {
    return selectedIndexes.length == notifyList.length;
  }

  /// Selects or deselects all notifications.
  void toggleSelectAll(bool value) {
    if (value) {
      selectedIndexes.clear();
      selectedIndexes
          .addAll(List.generate(notifyList.length, (index) => index));
    } else {
      selectedIndexes.clear();
    }
  }

  /// Deletes all selected notifications from Firestore and the local list.
  void deleteSelectedNotifications() async {
    try {
      selectedIndexes.sort((a, b) => b.compareTo(a));
      for (var index in selectedIndexes) {
        String documentId = notifyList[index]['documentId'];
        await FirebaseFirestore.instance
            .collection(CollectionName.notifications)
            .doc(FireStoreUtils.getCurrentUid())
            .collection('messages')
            .doc(documentId)
            .delete();
      }
      selectedIndexes.clear();
      // The stream will automatically update the notifyList
    } catch (e) {
      print('Error deleting notifications: $e');
    }
  }

  /// Marks all selected notifications as read in Firestore and the local list.
  void markAllSelectedAsRead() async {
    for (var index in selectedIndexes) {
      markAsRead(index);
    }
    toggleEditMode();
  }

  /// Marks a single notification as read in Firestore and the local list.
  void markAsRead(int index) async {
    try {
      String documentId = notifyList[index]['documentId'];
      await FirebaseFirestore.instance
          .collection(CollectionName.notifications)
          .doc(FireStoreUtils.getCurrentUid())
          .collection('messages')
          .doc(documentId)
          .update({'isRead': true});

      // The stream will automatically update the notifyList
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  void onClose() {
    // Cancel the stream subscription when the controller is closed
    _notificationSubscription?.cancel();
    super.onClose();
  }
}
