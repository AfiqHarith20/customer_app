import 'package:customer_app/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:customer_app/app/modules/webview/controllers/webview_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/common_ui.dart';
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
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Get.offAllNamed(
              Routes.DASHBOARD_SCREEN,
            );
            DashboardScreenController dashboardController = Get.find();
            dashboardController.refreshData();
            DashboardScreenController controller =
                Get.put(DashboardScreenController());
            controller.selectedIndex(1);
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        backgroundColor: AppColors.white,
        title: Text(
          "Online Payment".tr,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
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
                final response = await this.controller.fetchPayment();

                // Handle redirection based on the type
                final int redirectionType = response.redirectionType;
                final String redirectUrl = response.redirectUrl;
                final String clientScript = response.clientScript;

                if (redirectionType == 1) {
                  // Redirect using URL
                  await controller.loadUrl(
                      urlRequest: URLRequest(url: WebUri(redirectUrl)));
                } else if (redirectionType == 2) {
                  // Redirect using client script
                  // Load the HTML form content into WebView
                  await controller.loadData(
                    data: clientScript,
                    // Set base URL for relative paths (optional)
                    baseUrl: WebUri('https://mepsfpx.com.my/'),
                    // Set MIME type (optional)
                    mimeType: 'text/html',
                    // Set encoding (optional)
                    encoding: 'utf8',
                  );
                } else {
                  print('Invalid redirection type');
                  // Handle invalid redirection type here
                }
              },
              onLoadStop: (InAppWebViewController controller, url) async {
                final response = await this.controller.fetchPayment();

                // Handle redirection based on the type

                final String redirectUrl = response.redirectUrl;

                print('URL: $url');
                // You can also print other details of the URL if needed
                print('Host: ${Uri.parse(redirectUrl).host}');
                print('Path: ${Uri.parse(redirectUrl).path}');
                print(
                    'Query Parameters: ${Uri.parse(redirectUrl).queryParameters}');
                print('Fragment: ${Uri.parse(redirectUrl).fragment}');
              },
            );
          },
        ),
      ),
    );
  }
}
