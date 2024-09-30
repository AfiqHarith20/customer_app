import 'package:customer_app/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:customer_app/app/modules/webview_compound_screen/controllers/webview_compound_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebviewCompoundScreen extends StatefulWidget {
  const WebviewCompoundScreen({Key? key}) : super(key: key);

  @override
  State<WebviewCompoundScreen> createState() => _WebviewCompoundScreenState();
}

class _WebviewCompoundScreenState extends State<WebviewCompoundScreen> {
  double _progress = 0;
  final WebviewCompoundScreenController controller =
      Get.put(WebviewCompoundScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Get.offNamedUntil(
              Routes
                  .DASHBOARD_SCREEN, // Replace with your actual route for the search compound page
              (route) => route
                  .isFirst, // Removes all intermediate pages (checkout page, etc.)
              arguments: {
                'paymentCompleted':
                    true, // Pass a signal that the payment was completed
              },
            );
            // DashboardScreenController dashboardController = Get.find();
            // dashboardController.refreshData();
            // DashboardScreenController controller =
            //     Get.put(DashboardScreenController());
            // controller.selectedIndex(2);
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
        child: GetBuilder<WebviewCompoundScreenController>(
          init: controller,
          builder: (controller) {
            return Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    // Load empty page initially
                    url: Uri.parse('about:blank'),
                  ),
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                  onWebViewCreated: (InAppWebViewController controller) async {
                    // Fetch payment details and get HTML response
                    final response = await this.controller.fetchPayCompound();

                    // Handle redirection based on the type
                    final int redirectionType = response.redirectionType;
                    final String redirectUrl = response.redirectUrl;
                    final String clientScript = response.clientScript;

                    if (redirectionType == 1) {
                      // Redirect using URL
                      await controller.loadUrl(
                          urlRequest: URLRequest(url: Uri.parse(redirectUrl)));
                    } else if (redirectionType == 2) {
                      // Redirect using client script
                      // Load the HTML form content into WebView
                      await controller.loadData(
                        data: clientScript,
                        // Set base URL for relative paths (optional)
                        baseUrl: Uri.parse('https://mepsfpx.com.my/'),
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
                ),
                if (_progress < 1) LinearProgressIndicator(value: _progress),
              ],
            );
          },
        ),
      ),
    );
  }
}
