import 'dart:async';

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
    // Use a realtime listener so broadcasted notifications appear immediately
    _startNotificationListener();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _notificationSubscription;
  bool _hasInitializedPrimary = false;
  DateTime? _lastManualFetch;
  // Per-parent realtime subscriptions (for parents that have recent messages)
  final List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      _parentSubscriptions = [];
  final Map<String, List<Map<String, dynamic>>> _parentMessages = {};
  void _startNotificationListener() {
    try {
      // Listen to all messages across the project so the notifications tabs
      // display global messages (not per-user). This uses a collectionGroup
      // query and orders by createAt descending.
      _notificationSubscription?.cancel();
      _notificationSubscription = FirebaseFirestore.instance
          .collectionGroup(CollectionName.messages)
          .orderBy('createAt', descending: true)
          .snapshots()
          .listen((snap) {
        print(
            'Notification snapshot received: ${snap.docs.length} docs (global)');
        if (snap.docs.isNotEmpty) {
          print('Notification raw doc[0] data: ${snap.docs.first.data()}');
        }
        final items = snap.docs.map(_mapDocToNotification).toList();
        // Ensure sorted by createAt desc just in case
        items.sort((a, b) {
          final ta = a['createAt'] as Timestamp;
          final tb = b['createAt'] as Timestamp;
          return tb.compareTo(ta);
        });
        print(
            'Parsed ${items.length} notification items. First parsed item: ${items.isNotEmpty ? items.first : {}}');
        notifyList.assignAll(items);
        getNotificationCount();
        getActivityCount();
      }, onError: (err) {
        print('Notification snapshot error: $err');
        try {
          final msg = err?.toString() ?? '';
          // Detect Firestore index requirement error and attempt fallback
          if (msg.contains('COLLECTION_GROUP') ||
              msg.contains('requires an index') ||
              msg.contains('requires a COLLECTION_GROUP')) {
            print(
                'Firestore requires a collectionGroup index for messages/createAt. Attempting parent-scan fallback.');
            // Recommend deploying the provided `firestore.indexes.json` to create the index
            print(
                'To avoid this, create the index in Firebase Console or run: firebase deploy --only firestore:indexes (see firestore.indexes.json)');
            // Trigger the fallback scan (non-blocking)
            _attemptFallbackForNotifications();
          }
        } catch (e) {
          print('Error handling collectionGroup onError: $e');
        }
      });
    } catch (e) {
      print('Failed to start notification listener: $e');
    }
  }

  // Fallback read: try alternate collection layouts and attach a realtime listener
  Future<void> _attemptFallbackForNotifications() async {
    final uid = getCurrentUid();
    try {
      // QUICK SCAN: if messages are stored under arbitrary notification docs
      // (e.g. /notifications/{randomId}/messages/{msgId}), iterate parents
      // and gather their messages. This avoids composite-index requirements
      // that occur when querying across collections with filters+orderBy.
      print('Fallback: scanning notifications parents for messages');
      final parents = await FirebaseFirestore.instance
          .collection(CollectionName.notifications)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> aggregated = [];
      for (final p in parents.docs) {
        try {
          final msgs = await p.reference
              .collection(CollectionName.messages)
              .orderBy('createAt', descending: true)
              .get();
          if (msgs.docs.isNotEmpty) {
            aggregated.addAll(msgs.docs);
          }
        } catch (e) {
          // ignore per-parent read errors and continue
          print('Fallback: error reading messages for parent ${p.id}: $e');
        }
      }
      if (aggregated.isNotEmpty) {
        // Build parent-level message cache and determine recent parents
        final now = DateTime.now();
        final recentThreshold = now.subtract(const Duration(days: 30));
        final List<String> recentParentIds = [];

        for (final p in parents.docs) {
          try {
            final msgs = await p.reference
                .collection(CollectionName.messages)
                .orderBy('createAt', descending: true)
                .get();
            if (msgs.docs.isNotEmpty) {
              final mapped = msgs.docs.map(_mapDocToNotification).toList();
              _parentMessages[p.id] = mapped;
              // check latest message timestamp for recency
              final raw = msgs.docs.first.data()['createAt'];
              DateTime latest;
              if (raw is Timestamp) {
                latest = raw.toDate();
              } else if (raw is int) {
                latest = DateTime.fromMillisecondsSinceEpoch(raw);
              } else if (raw is String) {
                latest = DateTime.tryParse(raw) ?? DateTime.now();
              } else {
                latest = DateTime.now();
              }
              if (latest.isAfter(recentThreshold)) {
                recentParentIds.add(p.id);
              }
            }
          } catch (e) {
            // ignore per-parent read errors
          }
        }

        // Merge parent messages into a single sorted list
        final merged = _parentMessages.values.expand((l) => l).toList();
        merged.sort((a, b) {
          final ta = a['createAt'] as Timestamp;
          final tb = b['createAt'] as Timestamp;
          return tb.compareTo(ta);
        });
        notifyList.assignAll(merged);
        getNotificationCount();
        getActivityCount();

        // Attach per-parent realtime listeners only for recent parents
        // to keep realtime updates but avoid a noisy global listener.
        // Clear any previous parent subscriptions first.
        for (final sub in _parentSubscriptions) {
          sub.cancel();
        }
        _parentSubscriptions.clear();

        for (final parentId in recentParentIds) {
          final parentRef = FirebaseFirestore.instance
              .collection(CollectionName.notifications)
              .doc(parentId);
          final sub = parentRef
              .collection(CollectionName.messages)
              .orderBy('createAt', descending: true)
              .snapshots()
              .listen((snap) {
            // update this parent's cache and recompute merged list
            _parentMessages[parentId] =
                snap.docs.map(_mapDocToNotification).toList();
            final mergedNow = _parentMessages.values.expand((l) => l).toList();
            mergedNow.sort((a, b) {
              final ta = a['createAt'] as Timestamp;
              final tb = b['createAt'] as Timestamp;
              return tb.compareTo(ta);
            });
            notifyList.assignAll(mergedNow);
            getNotificationCount();
            getActivityCount();
          }, onError: (e) {
            print('Parent listener error for $parentId: $e');
          });
          _parentSubscriptions.add(sub);
        }

        print(
            'Fallback: attached per-parent listeners for ${_parentSubscriptions.length} recent parents');
        return;
      }

      // 1) Check root collection 'notifications' with userId field
      print('Fallback: checking root collection notifications for userId');
      final q1 = await FirebaseFirestore.instance
          .collection(CollectionName.notifications)
          .where('userId', isEqualTo: uid)
          .orderBy('createAt', descending: true)
          .get();
      if (q1.docs.isNotEmpty) {
        final fetched = q1.docs.map(_mapDocToNotification).toList();
        notifyList.assignAll(fetched);
        getNotificationCount();
        getActivityCount();
        // listen for realtime updates on this path
        _notificationSubscription?.cancel();
        _notificationSubscription = FirebaseFirestore.instance
            .collection(CollectionName.notifications)
            .where('userId', isEqualTo: uid)
            .orderBy('createAt', descending: true)
            .snapshots()
            .listen((snap) {
          notifyList.assignAll(snap.docs.map(_mapDocToNotification).toList());
          getNotificationCount();
          getActivityCount();
        });
        print('Fallback: using root notifications collection');
        return;
      }

      // 2) Check root collection 'messages' with userId field
      print('Fallback: checking root collection messages for userId');
      final q2 = await FirebaseFirestore.instance
          .collection('messages')
          .where('userId', isEqualTo: uid)
          .orderBy('createAt', descending: true)
          .get();
      if (q2.docs.isNotEmpty) {
        final fetched = q2.docs.map(_mapDocToNotification).toList();
        notifyList.assignAll(fetched);
        getNotificationCount();
        getActivityCount();
        _notificationSubscription?.cancel();
        _notificationSubscription = FirebaseFirestore.instance
            .collection('messages')
            .where('userId', isEqualTo: uid)
            .orderBy('createAt', descending: true)
            .snapshots()
            .listen((snap) {
          notifyList.assignAll(snap.docs.map(_mapDocToNotification).toList());
          getNotificationCount();
          getActivityCount();
        });
        print('Fallback: using root messages collection');
        return;
      }

      // 3) As last resort, use collectionGroup to search any 'messages' subcollections
      print('Fallback: checking collectionGroup messages for userId');
      final q3 = await FirebaseFirestore.instance
          .collectionGroup(CollectionName.messages)
          .where('userId', isEqualTo: uid)
          .orderBy('createAt', descending: true)
          .get();
      if (q3.docs.isNotEmpty) {
        final fetched = q3.docs.map((d) {
          return _mapDocToNotification(
              d as QueryDocumentSnapshot<Map<String, dynamic>>);
        }).toList();
        notifyList.assignAll(fetched);
        getNotificationCount();
        getActivityCount();
        _notificationSubscription?.cancel();
        _notificationSubscription = FirebaseFirestore.instance
            .collectionGroup(CollectionName.messages)
            .where('userId', isEqualTo: uid)
            .orderBy('createAt', descending: true)
            .snapshots()
            .listen((snap) {
          notifyList.assignAll(snap.docs
              .map((d) => _mapDocToNotification(
                  d as QueryDocumentSnapshot<Map<String, dynamic>>))
              .toList());
          getNotificationCount();
          getActivityCount();
        }, onError: (err) {
          print('Fallback collectionGroup listener error: $err');
          try {
            final msg = err?.toString() ?? '';
            if (msg.contains('COLLECTION_GROUP') ||
                msg.contains('requires an index') ||
                msg.contains('requires a COLLECTION_GROUP')) {
              print(
                  'Fallback: collectionGroup requires index. Please deploy firestore.indexes.json or create the index in Firebase Console.');
              // attempt parent-scan fallback (non-blocking)
              _attemptFallbackForNotifications();
            }
          } catch (e) {
            print('Error handling fallback collectionGroup error: $e');
          }
        });
        print('Fallback: using collectionGroup messages');
        return;
      }

      print('Fallback: no notifications found in alternate locations');
    } catch (e) {
      print('Fallback error: $e');
    }
  }

  fetchInformation() async {
    try {
      isLoading.value = true;
      // Legacy one-time fetch (kept for compatibility)
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(CollectionName.notifications)
              .doc(getCurrentUid())
              .collection(CollectionName.messages)
              .orderBy('createAt', descending: true)
              .get();

      List<Map<String, dynamic>> fetchedNotifications =
          querySnapshot.docs.map((doc) => _mapDocToNotification(doc)).toList();

      notifyList.assignAll(fetchedNotifications);
      getNotificationCount();
      getActivityCount();
      _lastManualFetch = DateTime.now();
    } catch (e) {
      print('Error fetching information: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh notifications but avoid repeated rapid calls.
  Future<void> refreshNotifications({bool force = false}) async {
    if (!force && _lastManualFetch != null) {
      final diff = DateTime.now().difference(_lastManualFetch!);
      if (diff.inSeconds < 2) return; // debounce short window
    }
    await fetchInformation();

    // If primary one-time fetch returned nothing, attempt fallback strategies
    // to locate notifications stored under alternative collection layouts.
    try {
      print('refreshNotifications: notifyList.count=${notifyList.length}');
      if (notifyList.isEmpty) {
        print(
            'refreshNotifications: primary fetch returned 0, running fallback');
        await _attemptFallbackForNotifications();
        print(
            'refreshNotifications: after fallback notifyList.count=${notifyList.length}');
      }
    } catch (e) {
      print('refreshNotifications error: $e');
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

      // Add notifications from Firestore to the notifyList (mapped)
      notifyList.addAll(snapshot.docs.map((doc) => _mapDocToNotification(doc)));

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

  Map<String, dynamic> _mapDocToNotification(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    // Handle createAt as Timestamp or String
    dynamic createAt = data['createAt'];
    if (createAt is Timestamp) {
      // keep as-is
    } else if (createAt is int) {
      // epoch millis -> convert to Timestamp
      createAt = Timestamp.fromMillisecondsSinceEpoch(createAt);
    } else if (createAt is String) {
      // try parse ISO string
      try {
        final dt = DateTime.parse(createAt);
        createAt = Timestamp.fromDate(dt);
      } catch (e) {
        // fallback to now
        createAt = Timestamp.now();
      }
    } else {
      createAt = Timestamp.now();
    }

    // Normalize isRead boolean
    bool isRead = false;
    final rawIsRead = data['isRead'];
    if (rawIsRead is bool) {
      isRead = rawIsRead;
    } else if (rawIsRead is String) {
      isRead = rawIsRead.toLowerCase() == 'true';
    } else if (rawIsRead is num) {
      isRead = rawIsRead != 0;
    }

    // Support multiple possible field names for compatibility with different
    // notification document shapes (some use 'desc' or 'body' instead of
    // 'message', or 'title' may be under 'headline', etc.).
    String title = '';
    if (data.containsKey('title') && data['title'] != null) {
      title = data['title'].toString();
    } else if (data.containsKey('headline') && data['headline'] != null) {
      title = data['headline'].toString();
    } else if (data.containsKey('subject') && data['subject'] != null) {
      title = data['subject'].toString();
    }

    String message = '';
    if (data.containsKey('message') && data['message'] != null) {
      // message might be a Map or String
      if (data['message'] is Map) {
        final m = Map<String, dynamic>.from(data['message']);
        message = m['text']?.toString() ?? m['body']?.toString() ?? '';
      } else {
        message = data['message'].toString();
      }
    } else if (data.containsKey('desc') && data['desc'] != null) {
      message = data['desc'].toString();
    } else if (data.containsKey('body') && data['body'] != null) {
      message = data['body'].toString();
    } else if (data.containsKey('description') && data['description'] != null) {
      message = data['description'].toString();
    } else {
      // helper to safely read nested maps
      Map<String, dynamic>? asMap(dynamic v) {
        if (v is Map) return Map<String, dynamic>.from(v);
        return null;
      }

      // check several nested common payload locations
      final candidates = <Map<String, dynamic>?>[
        asMap(data['data']),
        asMap(data['payload']),
        asMap(data['notification']),
        asMap(data['data']?['payload']),
        asMap(data['payload']?['data']),
        asMap(data['payload']?['notification']),
        asMap(data['data']?['notification']),
        asMap(data['aps']),
        asMap(data['aps']?['alert']),
        asMap(data['alert']),
      ];

      for (final cand in candidates) {
        if (cand == null) continue;
        if (cand.containsKey('message') && cand['message'] != null) {
          message = cand['message']?.toString() ?? '';
        }
        if (message.isEmpty &&
            cand.containsKey('body') &&
            cand['body'] != null) {
          message = cand['body']?.toString() ?? '';
        }
        if (message.isEmpty &&
            cand.containsKey('desc') &&
            cand['desc'] != null) {
          message = cand['desc']?.toString() ?? '';
        }
        if (message.isEmpty &&
            cand.containsKey('text') &&
            cand['text'] != null) {
          message = cand['text']?.toString() ?? '';
        }
        if (message.isNotEmpty) break;
      }

      // If aps.alert was a string, use it
      if (message.isEmpty && data['aps'] is Map) {
        final aps = asMap(data['aps']);
        final alert = aps?['alert'];
        if (alert is String) message = alert;
      }
    }

    // If title is missing, try to extract from nested places similar to message
    if ((title == null || title.isEmpty)) {
      Map<String, dynamic>? asMap(dynamic v) {
        if (v is Map) return Map<String, dynamic>.from(v);
        return null;
      }

      final titleCandidates = <Map<String, dynamic>?>[
        asMap(data['notification']),
        asMap(data['data']),
        asMap(data['payload']),
        asMap(data['aps']?['alert']),
        asMap(data['alert']),
        asMap(data['payload']?['notification']),
      ];
      for (final cand in titleCandidates) {
        if (cand == null) continue;
        if (cand.containsKey('title') && cand['title'] != null) {
          title = cand['title']?.toString() ?? '';
          break;
        }
        if (cand.containsKey('headline') && cand['headline'] != null) {
          title = cand['headline']?.toString() ?? '';
          break;
        }
      }
    }

    // If both title and message are empty, log doc for debugging
    if ((title == null || title.isEmpty) &&
        (message == null || message.isEmpty)) {
      try {
        print(
            'Notification mapping: empty title & message for doc ${doc.id}. raw data: $data');
      } catch (e) {
        // ignore
      }
    }

    String category = '';
    if (data.containsKey('category') && data['category'] != null) {
      category = data['category'].toString();
    } else if (data.containsKey('type') && data['type'] != null) {
      category = data['type'].toString();
    }

    String reference = '';
    if (data.containsKey('reference') && data['reference'] != null) {
      reference = data['reference'].toString();
    } else if (data.containsKey('ref') && data['ref'] != null) {
      reference = data['ref'].toString();
    }

    return {
      'title': title,
      'createAt': createAt,
      'category': category,
      'reference': reference,
      'message': message,
      'isRead': isRead,
      'documentId': doc.id,
      'documentPath': doc.reference.path,
    };
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    for (final sub in _parentSubscriptions) {
      sub.cancel();
    }
    _parentSubscriptions.clear();
    _parentMessages.clear();
    super.onClose();
  }

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
        final item = notifyList[index];
        final String? docPath = item['documentPath'] as String?;
        if (docPath != null && docPath.isNotEmpty) {
          try {
            await FirebaseFirestore.instance.doc(docPath).delete();
          } catch (e) {
            // fallback: try old location
            final String documentId = item['documentId'] ?? '';
            if (documentId.isNotEmpty) {
              try {
                await FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(getCurrentUid())
                    .collection('messages')
                    .doc(documentId)
                    .delete();
              } catch (e2) {
                print('Delete fallback failed for $documentId: $e2');
              }
            }
          }
        } else {
          // no path available, attempt delete by conventional path
          final String documentId = item['documentId'] ?? '';
          if (documentId.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection('notifications')
                .doc(getCurrentUid())
                .collection('messages')
                .doc(documentId)
                .delete();
          }
        }
        notifyList.removeAt(index);
      }
      // Clear selected indexes after deletion
      selectedIndexes.clear();
      getNotificationCount();
      getActivityCount();
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
      final item = notifyList[index];
      final String? docPath = item['documentPath'] as String?;
      if (docPath != null && docPath.isNotEmpty) {
        await FirebaseFirestore.instance.doc(docPath).update({'isRead': true});
      } else {
        final String documentId = item['documentId'] ?? '';
        await FirebaseFirestore.instance
            .collection(CollectionName.notifications)
            .doc(getCurrentUid())
            .collection('messages')
            .doc(documentId)
            .update({'isRead': true});
      }

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
