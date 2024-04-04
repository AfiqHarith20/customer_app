// ignore_for_file: library_private_types_in_public_api

import 'package:customer_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/button_theme.dart';
import '../../../../themes/common_ui.dart';
import '../../../widget/svg_image_widget.dart';
import '../../select_payment_screen/controllers/select_payment_screen_controller.dart';
import '../controllers/select_bank_provider_screen_controller.dart';

class SelectBankProviderScreenView extends StatefulWidget {
  const SelectBankProviderScreenView({Key? key}) : super(key: key);

  @override
  _SelectBankProviderScreenViewState createState() =>
      _SelectBankProviderScreenViewState();
}

class _SelectBankProviderScreenViewState
    extends State<SelectBankProviderScreenView> {
  @override
  Widget build(BuildContext context) {
    return GetX<SelectBankProviderScreenController>(
        init: SelectBankProviderScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface().customAppBar(context, "Select Bank".tr,
                backgroundColor: AppColors.white),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.providerList.length,
                            itemBuilder: (context, index) {
                              final itemData = controller.providerList[index];
                              return paymentDecoration(
                                context: context, // Pass BuildContext here
                                controller: controller,
                                id: itemData.id.toString(),
                                value: itemData.displayName.toString(),
                                image: itemData.imageUrl.toString(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            //   child: ButtonThem.buildButton(
            //     txtSize: 16,
            //     context,
            //     title: "Proceed".tr,
            //     txtColor: AppColors.lightGrey01,
            //     bgColor: !controller.isPaymentCompleted.value
            //         ? AppColors.darkGrey06
            //         : AppColors.darkGrey10,
            //     onPress: () async {},
            //   ),
            // ),
          );
        });
  }
}

Widget paymentDecoration({
  required BuildContext context, // Add BuildContext parameter
  required SelectBankProviderScreenController controller,
  required String id,
  required String value,
  required String image,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: InkWell(
      onTap: () {
        // print('Selected bank ID: $id');
        // print('Selected bank name: $value');
        // print('Selected bank image: $image');
        controller.selectedBank.value = id.toString();
        // Navigate back to the previous screen with bank data
        Navigator.pop(context, {
          'bankId': id.toString(),
          'bankName': value,
        });
      },
      child: Row(
        children: [
          SizedBox(
            height: 62,
            width: 124,
            child: Image.network(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: AppThemData.semiBold,
                      fontSize: 16,
                      color: AppColors.darkGrey08,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return SvgImageWidget(
              imagePath: controller.selectedBank.value == id.toString()
                  ? "assets/icons/ic_check_active.svg"
                  : "assets/icons/ic_check_inactive.svg",
              height: 22,
              width: 22,
              color: controller.selectedBank.value == id.toString()
                  ? AppColors.yellow04
                  : AppColors.darkGrey04,
            );
          }),
        ],
      ),
    ),
  );
}
