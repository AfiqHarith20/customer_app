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
  _SelectBankProviderScreenView createState() => _SelectBankProviderScreenView();
}

class _SelectBankProviderScreenView extends State<SelectBankProviderScreenView> {
  //const SelectBankProviderScreenView({Key? key}) : super(key: key);

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
              child: ListView.builder(
                  itemCount: controller.providerList.length,
                  itemBuilder: (context, index) {
                    final itemData = controller.providerList[index];
                    return paymentDecoration(
                          controller: controller,
                          id: itemData.id.toString(),
                          value: itemData.displayName
                              .toString(),
                          image: itemData.imageUrl.toString());
                  })
              ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: ButtonThem.buildButton(
                txtSize: 16,
                context,
                title: "Proceed".tr,
                txtColor: AppColors.lightGrey01,
                bgColor: !controller.isPaymentCompleted.value
                    ? AppColors.darkGrey06
                    : AppColors.darkGrey10,
                onPress: () async {
                },
              ),
            ),
          );
        });
  }
}

paymentDecoration(
    {required SelectBankProviderScreenController controller,
      required String id,
      required String value,
      required String image}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: InkWell(
      onTap: () {
          controller.selectedBank.value = id.toString();
      },
      child: Row(
        children: [
          Container(
            height: 62,
            width: 124,
            child:
            Image.network(
                image,
                fit: BoxFit.contain
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
                        color: AppColors.darkGrey08),
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