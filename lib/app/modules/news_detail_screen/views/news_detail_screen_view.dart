import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/modules/news_detail_screen/controllers/news_detail_screen_controller.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:intl/intl.dart';

class NewsDetailScreenView extends StatelessWidget {
  const NewsDetailScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<NewsDetailScreenController>(
      builder: (controller) {
        return Scaffold(
          appBar: UiInterface().customAppBar(
            context,
            "News Detail".tr,
            backgroundColor: AppColors.yellow04,
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.title,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontFamily: AppThemData.medium,
                          color: AppColors.darkGrey10,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            controller.date,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.des.toString(),
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontFamily: AppThemData.regular,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  String formatDate(dynamic date) {
    try {
      DateTime dateTime;
      if (date is Timestamp) {
        dateTime = date.toDate();
      } else if (date is String) {
        dateTime = DateTime.parse(date);
      } else {
        return ''; // Handle unexpected date type
      }
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return ''; // Return empty string if parsing fails
    }
  }
}
