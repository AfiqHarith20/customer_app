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
  late InAppWebViewController _webViewController;
  double progress = 0;
  final WebviewScreenController controller =
      Get.find<WebviewScreenController>();

  @override
  Widget build(BuildContext context) {
    // Generate a unique form ID
    String uniqueFormId = UniqueKey().toString();

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
              initialData: InAppWebViewInitialData(
                // Provide a simple HTML page with the response body embedded
                data: '''
          <html>
            <head><title>Payment Response</title></head>
            <body>
              <form id='$uniqueFormId' action='https://uat.mepsfpx.com.my/FPXMain/seller2DReceiver.jsp' method='POST'>
                ${this.controller.paymentResponse}
              </form>
              <script>
                document.getElementById('$uniqueFormId').submit();
              </script>
            </body>
          </html>
          ''',
                mimeType: 'text/html',
              ),
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
