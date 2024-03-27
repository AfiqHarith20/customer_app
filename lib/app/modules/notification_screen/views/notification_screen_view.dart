import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/common_ui.dart';

class NotificationScreenView extends StatelessWidget {
  const NotificationScreenView({Key? key}) : super(key: key);

  void fetchInformation() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('notification').get();

      List<dynamic> fetchedItems = querySnapshot.docs.map((doc) {
        return {
          "des": doc.data()['desc'].toString(),
          "link": doc.data()['link'].toString(),
          "read": doc.data()['read'].toString(),
          "title": doc.data()['title'].toString(),
          "pubDate": doc.data()['date'].toString(),
          "categories": doc.data()['categories'].toString(),
        };
      }).toList();

      // setState(() {
      //   items = fetchedItems;
      // });
    } catch (e) {
      print('Error fetching information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: AppColors.lightGrey02,
        appBar: UiInterface().customAppBar(
          backgroundColor: AppColors.lightGrey02,
          context,
          "Notifications".tr,
          isBack: true,
        ));
  }
}
