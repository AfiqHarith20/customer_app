import 'package:customer_app/app/modules/news_screen/controllers/news_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                              // print(
                              //     'Title: $title, Description: $des, Date: $date');
                              final titleValue = title ?? '';
                              final desValue = des ?? '';
                              final dateValue = date ?? '';

                              Get.toNamed(
                                Routes.NEWS_DETAIL_SCREEN,
                                arguments: {
                                  'title': titleValue,
                                  'des': desValue,
                                  'date': dateValue,
                                },
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      des ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
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
                                          date ?? '',
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.blueGrey),
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
}
