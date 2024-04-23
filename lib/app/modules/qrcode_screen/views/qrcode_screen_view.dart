import 'dart:developer';
import 'dart:io';
import 'package:customer_app/app/models/compound_model.dart';
import 'package:customer_app/app/modules/qrcode_screen/controllers/qrcode_screen_controller.dart';
import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/common_ui.dart';
import '../../../routes/app_pages.dart';

class QRCodeScanScreenView extends StatefulWidget {
  final QRCodeScanController controller;

  const QRCodeScanScreenView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScreenViewState();
}

class _QRCodeScreenViewState extends State<QRCodeScanScreenView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: UiInterface().customAppBar(
        backgroundColor: AppColors.white,
        context,
        "Scanner".tr,
        isBack: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: AppColors.yellow04,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      String? compoundNumber = scanData.code;

      if (compoundNumber != null && compoundNumber.isNotEmpty) {
        print(compoundNumber);

        Navigator.pop(context, {
          'compoundNumber': compoundNumber,
        });
        // Navigator.pushNamed(context, '/search-summon-screen',
        //     arguments: compoundNumber);

        // Get.toNamed(
        //   Routes.SEARCH_SUMMON_SCREEN,
        //   arguments: {
        //     'controller': QRCodeScanController,
        //   },
        // );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
