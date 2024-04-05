import 'dart:convert';

import 'package:customer_app/app/modules/webview/controllers/webview_screen_controller.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;
  final WebviewScreenController controller =
      Get.find<WebviewScreenController>();

  @override
  void initState() {
    super.initState();
    // controller.getArgumentAndMakePayment(); // Call the method here
  }

  @override
  Widget build(BuildContext context) {
    return GetX<WebviewScreenController>(
      init: WebviewScreenController(),
      builder: (controller) {
        return Scaffold(
          appBar: UiInterface().customAppBar(
            context,
            "Online Payment".tr,
            backgroundColor: AppColors.white,
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : Stack(
                  children: [
                    InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri(APIList.payment.toString()),
                        method: 'POST',
                        body: utf8.encode(
                            Uri(queryParameters: controller.getRequestBody())
                                .query),
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        inAppWebViewController = controller;
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          _progress = progress / 100;
                        });
                      },
                    )
                  ],
                ),
        );
      },
    );
  }
}
