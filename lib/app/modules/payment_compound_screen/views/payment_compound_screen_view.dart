// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/app/models/commercepay/online_payment_model.dart';
import 'package:customer_app/app/models/wallet_transaction_model.dart';
import 'package:customer_app/app/widget/svg_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/server.dart';

import '../../../routes/app_pages.dart';
import '../controllers/payment_compound_screen_controller.dart';

class PaymentCompoundScreenView extends StatefulWidget {
  final String compoundNo;
  final String receiptNo;
  final String vehicleNo;
  final String amount;
  final String vendor;
  final Timestamp paidTime;
  final String kodHasil;
  final String name;
  final String identificationNo;
  final String address;
  final String phoneNumber;
  late String selectedBankName;
  PaymentCompoundScreenView({
    Key? key,
    required this.compoundNo,
    required this.receiptNo,
    required this.vehicleNo,
    required this.amount,
    required this.vendor,
    required this.paidTime,
    required this.kodHasil,
    required this.name,
    required this.identificationNo,
    required this.address,
    required this.phoneNumber,
    required this.selectedBankName,
  }) : super(key: key);

  @override
  State<PaymentCompoundScreenView> createState() =>
      _PaymentCompoundScreenViewState();
}

class _PaymentCompoundScreenViewState extends State<PaymentCompoundScreenView> {
  late PaymentCompoundScreenController controller;
  late OnlinePaymentModel onlinePaymentModel = OnlinePaymentModel();

  @override
  void initState() {
    super.initState();
    onlinePaymentModel = OnlinePaymentModel();
    controller = Get.put(PaymentCompoundScreenController());
    controller.onInit(); // Call onInit manually
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PaymentCompoundScreenController>(
      init: PaymentCompoundScreenController(),
      builder: (controller) {
        return Scaffold(
          appBar: UiInterface().customAppBar(
            context,
            "Pay Compound".tr,
            backgroundColor: AppColors.white,
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Compound Detail".tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: AppThemData.semiBold,
                              color: AppColors.darkGrey08,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildDetailRow(
                              "Compound Number".tr, widget.compoundNo),
                          _buildDetailRow(
                              "Receipt Number".tr, widget.receiptNo),
                          _buildDetailRow(
                              "Vehicle Number".tr, widget.vehicleNo),
                          _buildDetailRow("Name".tr, widget.name),
                          _buildDetailRow("Identification Number".tr,
                              widget.identificationNo),
                          _buildDetailRow("Address".tr, widget.address),
                          _buildDetailRow(
                              "Phone Number".tr, widget.phoneNumber),
                          _buildDetailRow(
                              "Paid Time".tr, widget.paidTime as String),
                          _buildDetailRow("Vendor".tr, widget.vendor),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Payment Methods".tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: AppThemData.semiBold,
                              color: AppColors.darkGrey08,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.wallet !=
                                    null &&
                                controller.paymentModel.value.wallet!.enable ==
                                    true,
                            child: paymentDecoration(
                              controller: controller,
                              value: controller.paymentModel.value.wallet!.name
                                  .toString(),
                              image: "assets/images/wallet.png",
                            ),
                          ),
                          Visibility(
                            visible:
                                controller.paymentModel.value.commercePay !=
                                        null &&
                                    controller.paymentModel.value.commercePay!
                                            .enable ==
                                        true,
                            child: paymentOnlineDecoration(
                              controller: controller,
                              value: controller
                                  .paymentModel.value.commercePay!.name
                                  .toString(),
                              image: "assets/images/online_banking.png",
                              selectedBankName: widget.selectedBankName,
                              updateSelectedBankName: (bankName) {
                                // Define the callback function
                                setState(() {
                                  widget.selectedBankName =
                                      bankName!; // Update the selectedBankName state
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.strip !=
                                    null &&
                                controller.paymentModel.value.strip!.enable ==
                                    true,
                            child: paymentDecoration(
                              controller: controller,
                              value: controller.paymentModel.value.strip!.name
                                  .toString(),
                              image: "assets/images/stripe.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.paypal !=
                                    null &&
                                controller.paymentModel.value.paypal!.enable ==
                                    true,
                            child: paymentDecoration(
                              controller: controller,
                              value: controller.paymentModel.value.paypal!.name
                                  .toString(),
                              image: "assets/images/paypal.png",
                            ),
                          ),
                          _buildPaymentInformation(widget.amount),
                          const Divider(
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: ButtonThem.buildButton(
              txtSize: 16,
              context,
              title: "Pay Now".tr,
              txtColor: AppColors.lightGrey01,
              bgColor: !controller.isPaymentCompleted.value
                  ? AppColors.darkGrey06
                  : AppColors.darkGrey10,
              onPress: () async {
                if (!controller.isPaymentCompleted.value) {
                  return;
                }

                // Check the selected payment method
                if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.commercePay!.name) {
                  // onlinePaymentModel = OnlinePaymentModel(
                  // accessToken: widget.accessToken,
                  // customerId: widget.customerId,
                  // channelId: '2',
                  // selectedBankId: widget.selectedBankId,
                  // totalPrice: widget.totalPrice,
                  // address: widget.address,
                  // companyName: widget.companyName,
                  // companyRegistrationNo: widget.companyRegistrationNo,
                  // endDate: widget.endDate,
                  // startDate: widget.startDate,
                  // fullName: widget.fullName,
                  // email: widget.email,
                  // mobileNumber: widget.mobileNumber,
                  // userName: widget.userName,
                  // identificationNo: widget.identificationNo,
                  // identificationType: widget.identificationType,
                  // vehicleNo: widget.vehicleNo,
                  // lotNo: widget.lotNo,
                  //   selectedPassId: widget.selectedPassId,
                  // );
                  // print('Online Payment Data: $onlinePaymentModel');
                  // Get.toNamed(
                  //   Routes.WEBVIEW_SCREEN,
                  //   arguments: {
                  //     'onlinePaymentModel': onlinePaymentModel,
                  //   },
                  // );
                  controller.completeOrder();
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.strip!.name) {
                  // Call the controller method to make the stripe payment
                  controller.stripeMakePayment(
                    amount: double.parse(
                      controller.paymentCompoundModel.value.amount!,
                    ).toStringAsFixed(Constant.currencyModel!.decimalDigits!),
                  );
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.paypal!.name) {
                  // Call the controller method to handle PayPal payment
                  controller.paypalPaymentSheet(
                    double.parse(
                      controller.paymentCompoundModel.value.amount!,
                    ).toStringAsFixed(Constant.currencyModel!.decimalDigits!),
                  );
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.wallet!.name) {
                  // Check if the wallet amount is sufficient
                  if (double.parse(controller.customerModel.value.walletAmount
                          .toString()) >=
                      double.parse(
                        controller.paymentCompoundModel.value.amount!,
                      )) {
                    // Create a transaction model for wallet deduction
                    WalletTransactionModel transactionModel =
                        WalletTransactionModel(
                      id: Constant.getUuid(),
                      amount:
                          "-${double.parse(controller.paymentCompoundModel.value.amount!).toString()}",
                      createdDate: Timestamp.now(),
                      paymentType: controller.selectedPaymentMethod.value,
                      transactionId: controller.paymentCompoundModel.value.id,
                      note: "Pay Compound ".tr,
                      type: "customer",
                      userId: FireStoreUtils.getCurrentUid(),
                      isCredit: false,
                    );

                    // Add the wallet transaction
                    await FireStoreUtils.setWalletTransaction(
                      transactionModel,
                    ).then((value) async {
                      if (value == true) {
                        // Update the user's wallet amount
                        await FireStoreUtils.updateUserWallet(
                          amount:
                              "-${double.parse(controller.paymentCompoundModel.value.amount!).toString()}",
                        ).then((value) {
                          controller.completeOrder();
                        });
                      }
                    });
                  } else {
                    // Show toast if wallet amount is insufficient
                    ShowToastDialog.showToast("Wallet Amount Insufficient".tr);
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentInformation(String passPrice) {
    // Convert passPrice to a double
    double price = double.parse(passPrice);

    // Calculate tax (6% of pass price)
    double tax = 0.06 * price;

    // Calculate total amount
    double totalPrice = price + tax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.black),
        const Text(
          "Payment Information",
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppThemData.semiBold,
            color: AppColors.darkGrey08,
          ),
        ),
        const SizedBox(height: 20),
        _buildDetailRow("Sub Total",
            "RM ${price.toStringAsFixed(2)}"), // Convert price to string
        _buildDetailRow("Tax (6%)", "RM ${tax.toStringAsFixed(2)}"),
        const Divider(),
        _buildTotalRow("Total Amount", "RM ${totalPrice.toStringAsFixed(2)}"),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: AppThemData.regular,
            color: AppColors.darkGrey05,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: AppThemData.regular,
            color: AppColors.darkGrey08,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: AppThemData.bold,
            color: AppColors.darkGrey10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: AppThemData.bold,
            color: AppColors.darkGrey10,
          ),
        ),
      ],
    );
  }

  Widget paymentOnlineDecoration({
    required PaymentCompoundScreenController controller,
    required String value,
    required String image,
    required String? selectedBankName, // Change to required parameter
    required Function(String?) updateSelectedBankName, // Add callback parameter
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          controller.selectedPaymentMethod.value = value.toString();
          if (value == "Online Banking") {
            // Get the price of the selected pass
            final compoundPrice = controller.paymentCompoundModel.value.amount!;

            // Make payment based on the selected method
            controller.commercepayMakePayment(
              amount: double.parse(compoundPrice)
                  .toStringAsFixed(Constant.currencyModel!.decimalDigits!),
            );

            // Navigate to SelectBankProviderScreen
            final result =
                await Get.toNamed(Routes.SELECT_BANK_PROVIDER_SCREEN);
            if (result != null && result is Map<String, dynamic>) {
              final selectedBankId = result['bankId'];
              final bankName = result['bankName'];
              // Update the selected bank name using the callback function
              updateSelectedBankName(bankName); // Call the callback function
              // Do something with the selected bank data
              print('Selected Bank ID: $selectedBankId');
              print('Selected Bank Name: $bankName');
            }

            // Check if result is not null and print the selected bank data
            if (result != null && result is Map<String, dynamic>) {
              print('Selected Bank: $selectedBankName');
              // You can perform any action with the selected bank data here
            }
          }
        },
        child: Row(
          children: [
            Image.asset(
              image,
              height: 62,
              width: 62,
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
                      value == "wallet" ? "My Wallet".tr : "Online Banking".tr,
                      style: const TextStyle(
                        fontFamily: AppThemData.semiBold,
                        fontSize: 16,
                        color: AppColors.darkGrey08,
                      ),
                    ),
                  ),
                  Text(
                    selectedBankName != null &&
                            selectedBankName
                                .isNotEmpty // Check if selectedBankName is not null and not empty
                        ? selectedBankName
                        : "Select Bank".tr,
                    style: const TextStyle(
                      fontFamily: AppThemData.medium,
                      color: AppColors.darkGrey05,
                    ),
                  ),
                ],
              ),
            ),
            SvgImageWidget(
              imagePath:
                  (controller.selectedPaymentMethod.value == value.toString())
                      ? "assets/icons/ic_check_active.svg"
                      : "assets/icons/ic_check_inactive.svg",
              height: 22,
              width: 22,
              color:
                  (controller.selectedPaymentMethod.value == value.toString())
                      ? AppColors.yellow04
                      : AppColors.darkGrey04,
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentDecoration({
    required PaymentCompoundScreenController controller,
    required String value,
    required String image,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          controller.selectedPaymentMethod.value = value.toString();
        },
        child: Row(
          children: [
            Image.asset(
              image,
              height: 62,
              width: 62,
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
                      (value == "wallet")
                          ? "My Wallet".tr
                          : "Online Banking".tr,
                      style: const TextStyle(
                        fontFamily: AppThemData.semiBold,
                        fontSize: 16,
                        color: AppColors.darkGrey08,
                      ),
                    ),
                  ),
                  (value == "wallet")
                      ? Text(
                          "Available Balance:-".tr +
                              Constant.amountShow(
                                amount:
                                    controller.customerModel.value.walletAmount,
                              ),
                          style: const TextStyle(
                            fontFamily: AppThemData.medium,
                            color: AppColors.darkGrey05,
                          ),
                        )
                      : Text(
                          "Select Bank".tr,
                          style: const TextStyle(
                            fontFamily: AppThemData.medium,
                            color: AppColors.darkGrey05,
                          ),
                        ),
                ],
              ),
            ),
            SvgImageWidget(
              imagePath:
                  (controller.selectedPaymentMethod.value == value.toString())
                      ? "assets/icons/ic_check_active.svg"
                      : "assets/icons/ic_check_inactive.svg",
              height: 22,
              width: 22,
              color:
                  (controller.selectedPaymentMethod.value == value.toString())
                      ? AppColors.yellow04
                      : AppColors.darkGrey04,
            ),
          ],
        ),
      ),
    );
  }
}
