// ignore_for_file: deprecated_member_use

import 'package:customer_app/app/models/wallet_transaction_model.dart';
import 'package:customer_app/app/widget/text_field_prefix_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/themes/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../themes/button_theme.dart';
import '../controllers/wallet_screen_controller.dart';

class WalletScreenView extends StatelessWidget {
  const WalletScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WalletScreenController>(
        init: WalletScreenController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              controller.profileScreenController.isWalletScreen.value = false;
              return true;
            },
            child: Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: (controller.profileScreenController.isWalletScreen.value)
                  ? UiInterface().customAppBar(onBackTap: () {
                      controller.profileScreenController.isWalletScreen.value =
                          false;
                      Get.back();
                    },
                      isBack: true,
                      context,
                      "Wallet Transactions".tr,
                      backgroundColor: AppColors.lightGrey02)
                  : UiInterface().customAppBar(
                      isBack: false,
                      context,
                      "Wallet Transactions".tr,
                      backgroundColor: AppColors.lightGrey02),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Monitor your wallet activity effortlessly. View transactions, add funds, and stay in control of your parking payments".tr
                                .tr,
                            style: const TextStyle(
                              height: 1.2,
                              color: AppColors.lightGrey10,
                              fontFamily: AppThemData.regular,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Container(
                            width: Responsive.width(100, context),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                    image: AssetImage(
                                      "assets/images/credit_card_bg.png",
                                    ),
                                    fit: BoxFit.fitWidth)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Total Amount".tr,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.blue03,
                                        fontFamily: AppThemData.medium),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    Constant.amountShow(
                                        amount: controller
                                            .customerModel.value.walletAmount
                                            .toString()),
                                    style: TextStyle(
                                        fontSize: 32,
                                        color: AppColors.blue01,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "Minimum Deposit will be ".tr + "${Constant.amountShow(amount: Constant.minimumAmountToDeposit)}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.blue03,
                                        fontFamily: AppThemData.medium),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  ButtonThem.buildButton(
                                    fontWeight: FontWeight.w700,
                                    btnHeight: 48,
                                    txtSize: 16,
                                    context,
                                    title: "+ Add Cash".tr,
                                    txtColor: AppColors.darkGrey10,
                                    bgColor: AppColors.yellow04,
                                    onPress: () {
                                      paymentMethodDialog(context, controller);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Text(
                            'Transaction History'.tr,
                            style: const TextStyle(
                                color: AppColors.darkGrey10,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: controller.transactionList.isEmpty
                              ? Constant.showEmptyView(
                                  message: "Transaction not found".tr)
                              : ListView.builder(
                                  itemCount: controller.transactionList.length,
                                  itemBuilder: (context, index) {
                                    WalletTransactionModel walletTractionModel =
                                        controller.transactionList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .darkGrey01)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/ic_credit_card.svg",
                                                    color: (walletTractionModel
                                                            .isCredit!)
                                                        ? AppColors.green04
                                                        : AppColors.red04,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              walletTractionModel
                                                                  .note
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: AppColors
                                                                      .darkGrey07,
                                                                  fontFamily:
                                                                      AppThemData
                                                                          .medium,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                          Text(
                                                            Constant.amountShow(
                                                                amount: walletTractionModel
                                                                    .amount
                                                                    .toString()),
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .darkGrey07,
                                                                fontFamily:
                                                                    AppThemData
                                                                        .medium,
                                                                fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              Constant.timestampToDate(
                                                                  walletTractionModel
                                                                      .createdDate!),
                                                              style: const TextStyle(
                                                                  color: AppColors
                                                                      .darkGrey03,
                                                                  fontFamily:
                                                                      AppThemData
                                                                          .medium,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Success'.tr,
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .green04,
                                                                fontFamily:
                                                                    AppThemData
                                                                        .medium,
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  paymentMethodDialog(BuildContext context, WalletScreenController controller) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: StatefulBuilder(builder: (context1, setState) {
                return Obx(
                  () => Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: AppColors.grey01,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Container(
                                    width: 134,
                                    height: 5,
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: ShapeDecoration(
                                      color: AppColors.labelColorLightPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Add Money to Wallet'.tr,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: AppThemData.medium,
                                          color: AppColors.grey10,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors.grey10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFieldWidgetPrefix(
                            title: 'Enter Amount'.tr,
                            onPress: () {},
                            controller: controller.amountController.value,
                            hintText: 'Enter Amount'.tr,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true, signed: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            prefix: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                  Constant.currencyModel!.symbol.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.darkGrey06)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.strip !=
                                              null &&
                                          controller.paymentModel.value.strip!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller.paymentModel.value.strip!.name
                                          .toString(),
                                      "assets/images/commercepay.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.paypal !=
                                              null &&
                                          controller.paymentModel.value.paypal!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller.paymentModel.value.paypal!.name
                                          .toString(),
                                      "assets/images/paypal.png"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: ButtonThem.buildButton(
                        fontWeight: FontWeight.w700,
                        btnHeight: 56,
                        txtSize: 16,
                        btnWidthRatio: .60,
                        context,
                        title: "Topup".tr,
                        txtColor: AppColors.lightGrey01,
                        bgColor: AppColors.darkGrey10,
                        onPress: () {
                          if (controller
                              .amountController.value.text.isNotEmpty) {
                            Get.back();
                            if (double.parse(
                                    controller.amountController.value.text) >=
                                double.parse(Constant.minimumAmountToDeposit
                                    .toString())) {
                              if (controller.selectedPaymentMethod.value ==
                                  controller.paymentModel.value.strip!.name) {
                                controller.stripeMakePayment(
                                    amount:
                                        controller.amountController.value.text);
                              } else if (controller
                                      .selectedPaymentMethod.value ==
                                  controller.paymentModel.value.paypal!.name) {
                                controller.paypalPaymentSheet(
                                    controller.amountController.value.text);
                              } else {
                                ShowToastDialog.showToast(
                                    "Please complete booking".tr);
                              }
                            } else {
                              ShowToastDialog.showToast(
                                  "Please Enter minimum amount of ${Constant.amountShow(amount: Constant.minimumAmountToDeposit)}"
                                      .tr);
                            }
                          } else {
                            ShowToastDialog.showToast("Please enter amount".tr);
                          }
                        },
                      ),
                    ),
                  ),
                );
              }),
            ));
  }

  cardDecoration(
      WalletScreenController controller, String value, String image) {
    return Obx(
      () => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              controller.selectedPaymentMethod.value = value;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    image,
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemData.bold,
                          color: AppColors.grey10),
                    ),
                  ),
                  Radio(
                    value: value.toString(),
                    groupValue: controller.selectedPaymentMethod.value,
                    activeColor: AppColors.yellow04,
                    onChanged: (value) {
                      controller.selectedPaymentMethod.value = value.toString();
                    },
                  )
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, color: AppColors.lightGrey02),
        ],
      ),
    );
  }
}
