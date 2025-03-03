import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselDetailsScreenView extends StatelessWidget {
  const CarouselDetailsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch arguments passed from the carousel item tap
    final String? image = Get.arguments['image'];
    final String? title = Get.arguments['title'];
    final String? desc = Get.arguments['desc'];

    // Check if both title and description are empty
    final bool hasContent = (title != null && title.isNotEmpty) ||
        (desc != null && desc.isNotEmpty);

    return Scaffold(
      appBar: UiInterface().customAppBar(
        context,
        "Carousel Details".tr,
        backgroundColor: AppColors.yellow04,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Animation for Image
            Hero(
              tag: image ?? '',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Stack(
                  children: [
                    // Image Display
                    Image.network(
                      image ?? '',
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 350,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 100,
                          ),
                        );
                      },
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Conditionally show the Card only if there is content
            if (hasContent)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Display
                      if (title != null && title.isNotEmpty)
                        Text(
                          title,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontFamily: AppThemData.bold,
                            color: AppColors.darkGrey10,
                            height: 1.4,
                          ),
                        ),
                      const SizedBox(height: 10),
                      // Description Display
                      if (desc != null && desc.isNotEmpty)
                        Text(
                          desc,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontFamily: AppThemData.regular,
                            color: AppColors.darkGrey08,
                            height: 1.5,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
