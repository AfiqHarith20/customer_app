import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NewsScreenController extends GetxController {
  static const int pageSize = 5; // Number of items per page
  final PagingController<int, Map<String, dynamic>> pagingController =
      PagingController(firstPageKey: 0);
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> newsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchInformationNews(pageKey);
    });
  }

  Future<void> fetchInformationNews(int pageKey) async {
    try {
      // Get the starting point for the query
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('information')
          .where("active", isEqualTo: true)
          .orderBy('date', descending: true)
          .limit(pageSize);

      // If it's not the first page, start from the last document of the previous page
      if (pageKey != 0) {
        final lastDocument = pagingController.itemList?.last['document'];
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      // Convert the fetched documents to a list of maps
      List<Map<String, dynamic>> fetchedItems = querySnapshot.docs.map((doc) {
        return {
          "des": doc.data()['desc'].toString(),
          "link": doc.data()['link'].toString(),
          "read": doc.data()['read'].toString(),
          "title": doc.data()['title'].toString(),
          "pubDate": doc.data()['date'], // Store as dynamic
          "categories": doc.data()['categories'].toString(),
          "document": doc, // Keep the document for pagination
        };
      }).toList();

      // Check if it's the last page
      final isLastPage = fetchedItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(fetchedItems);
      } else {
        final nextPageKey = pageKey + fetchedItems.length;
        pagingController.appendPage(fetchedItems, nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
      print('Error fetching information: $e');
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
