import 'dart:convert';
import 'dart:io';

import 'package:customer_app/app/modules/webview/controllers/webview_screen_controller.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/utils/api-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({Key? key}) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  double _progress = 0;
  final WebviewScreenController controller =
      Get.find<WebviewScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiInterface().customAppBar(
        context,
        "Online Payment".tr,
        backgroundColor: AppColors.white,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height, // Constrain height
        width: MediaQuery.of(context).size.width, // Constrain width
        child: GetBuilder<WebviewScreenController>(
          init: controller,
          builder: (controller) {
            return InAppWebView(
              initialUrlRequest: URLRequest(
                // Load empty page initially
                url: WebUri('about:blank'),
              ),
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onWebViewCreated: (InAppWebViewController controller) async {
                // Fetch payment details and get HTML response
                String htmlResponse = await this.controller.fetchPayment();

                // Load the HTML form content into WebView
                await controller.loadData(
                  data: htmlResponse,
                  // Set base URL for relative paths (optional)
                  baseUrl: WebUri('https://uat.mepsfpx.com.my/'),
                  // Set MIME type (optional)
                  mimeType: 'text/html',
                  // Set encoding (optional)
                  encoding: 'utf8',
                );
              },
            );
          },
        ),
      ),
    );
  }
}
