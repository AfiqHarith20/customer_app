import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/modules/news_screen/controllers/news_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewsScreenView extends StatefulWidget {
  const NewsScreenView({super.key});

  @override
  State<NewsScreenView> createState() => _NewsScreenViewState();
}

class _NewsScreenViewState extends State<NewsScreenView> {
  @override
  Widget build(BuildContext context) {
    return GetX<NewsScreenController>(
      builder: (controller) {
        return Scaffold(
            appBar: UiInterface().customAppBar(
              context,
              "More News".tr,
              backgroundColor: AppColors.yellow04,
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Obx(
                    () => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.newsList.length,
                        itemBuilder: (context, index) {
                          final itemData = controller.newsList[index];
                          final title = itemData['title'];
                          final des = itemData['des'];
                          final date = itemData['pubDate'];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.NEWS_DETAIL_SCREEN,
                                arguments: {
                                  'title': title,
                                  'des': des,
                                  'date': date,
                                },
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title ?? '',
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      des ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatDate(date),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ));
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
