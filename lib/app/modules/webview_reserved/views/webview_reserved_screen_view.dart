import 'package:customer_app/app/modules/webview_reserved/controllers/webview_Reserved_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebviewReservedScreen extends StatefulWidget {
  const WebviewReservedScreen({super.key});

  @override
  State<WebviewReservedScreen> createState() => _WebviewReservedScreenState();
}

class _WebviewReservedScreenState extends State<WebviewReservedScreen> {
  double _progress = 0;
  final WebviewReservedScreenController controller =
      Get.put(WebviewReservedScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          onPressed: () async {
            // Perform cleanup before navigating away
            // controller.cleanup();
            //  Get.delete<OnlinePaymentModel>();
            // Navigate to the dashboard screen
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

            // Fetch and update the dashboard controller
            // DashboardScreenController dashboardController = Get.find();
            // dashboardController.refreshData();
            // DashboardScreenController newDashboardController =
            //     Get.put(DashboardScreenController());
            // newDashboardController.selectedIndex(1);
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
        child: GetBuilder<WebviewReservedScreenController>(
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
                      (InAppWebViewController webViewController, int progress) {
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                  onWebViewCreated:
                      (InAppWebViewController webViewController) async {
                    // Fetch payment details and get HTML response
                    final response = await controller.fetchPayment();

                    // Handle redirection based on the type
                    final int redirectionType = response.redirectionType;
                    final String redirectUrl = response.redirectUrl;
                    final String clientScript = response.clientScript;

                    if (redirectionType == 1) {
                      // Redirect using URL
                      await webViewController.loadUrl(
                          urlRequest: URLRequest(url: Uri.parse(redirectUrl)));
                    } else if (redirectionType == 2) {
                      // Redirect using client script
                      // Load the HTML form content into WebView
                      await webViewController.loadData(
                        data: clientScript,
                        baseUrl: Uri.parse(
                            'https://mepsfpx.com.my/'), // Set base URL for relative paths (optional)
                        mimeType: 'text/html', // Set MIME type (optional)
                        encoding: 'utf8', // Set encoding (optional)
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
