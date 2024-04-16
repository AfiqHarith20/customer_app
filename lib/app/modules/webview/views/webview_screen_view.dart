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
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(APIList.payment.toString()),
                  method: 'POST',
                  headers: {
                    // Set the content type to application/json
                    'Content-Type': 'application/json',
                  },
                  body: utf8.encode(jsonEncode(
                    // Encode the request body as JSON
                    controller.getRequestBody(),
                  )),
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
                // Add onLoadStop callback to handle response
                onLoadStop:
                    (InAppWebViewController controller, Uri? url) async {
                  try {
                    // Evaluate JavaScript to get the response data
                    final responseData = await controller.evaluateJavascript(
                        source: "document.documentElement.textContent");
                    // Parse the response data
                    final parsedData = jsonDecode(responseData);
                    // Print the parsed data
                    print("Response Data: $parsedData");
                  } catch (e) {
                    // If an error occurs, print the error
                    print("Error occurred while loading: $e");
                  }
                },
              ),
              if (controller.isLoading.value)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
