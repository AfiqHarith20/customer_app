import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/common_ui.dart';

class NotificationScreenView extends StatefulWidget {
  const NotificationScreenView({Key? key}) : super(key: key);

  @override
  State<NotificationScreenView> createState() => _NotificationScreenViewState();
}

class _NotificationScreenViewState extends State<NotificationScreenView> {
  List<Map<String, dynamic>> notifyList = []; // Adjusted the type

  @override
  void initState() {
    super.initState();
    fetchInformation(); // Fetch notifications on initialization
  }

  void fetchInformation() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('notification').get();

      List<Map<String, dynamic>> fetchNotify = querySnapshot.docs.map((doc) {
        return {
          "des": doc.data()['desc'].toString(),
          "title": doc.data()['title'].toString(),
          "pubDate": doc.data()['date'].toString(),
          "category": doc.data()['category'].toString(),
        };
      }).toList();

      setState(() {
        notifyList = fetchNotify;
      });
    } catch (e) {
      print('Error fetching information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: UiInterface().customAppBar(
        backgroundColor: AppColors.lightGrey02,
        context,
        "Notifications".tr,
        isBack: true,
      ),
      body: ListView.separated(
        itemCount: notifyList.length,
        separatorBuilder: (BuildContext context, int index) => Divider(), // Add divider between list items
        itemBuilder: (context, index) {
          var notification = notifyList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  notification['pubDate'],
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification['category'],
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  notification['des'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}