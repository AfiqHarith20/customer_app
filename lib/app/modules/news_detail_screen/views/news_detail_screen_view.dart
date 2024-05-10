import 'package:customer_app/app/modules/news_detail_screen/controllers/news_detail_screen_controller.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

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
                        controller.titleValue.value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.dateValue.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.desValue.value,
                        style: const TextStyle(
                          fontSize: 16,
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
}
