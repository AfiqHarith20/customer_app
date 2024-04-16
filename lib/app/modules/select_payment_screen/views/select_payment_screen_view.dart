// ignore_for_file: library_private_types_in_public_api, must_be_immutable, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/select_payment_screen_controller.dart';

class SelectPaymentScreenView extends StatefulWidget {
  final String passId;
  final String passName;
  final String passPrice;
  final String passValidity;
  late String selectedBankName;
  final String? selectedBankId;
  final String selectedPassId;
  final String accessToken;
  final String customerId;
  final double totalPrice;
  final String address;
  final String companyName;
  final String companyRegistrationNo;
  final String endDate;
  final String startDate;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String userName;
  final String identificationNo;
  final String identificationType;
  final String vehicleNo;
  final String lotNo;
  SelectPaymentScreenView({
    Key? key,
    required this.passId,
    required this.passName,
    required this.passPrice,
    required this.passValidity,
    required this.selectedBankName,
    required this.selectedBankId,
    required this.selectedPassId,
    required this.accessToken,
    required this.customerId,
    required this.totalPrice,
    required this.address,
    required this.companyName,
    required this.companyRegistrationNo,
    required this.endDate,
    required this.startDate,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.userName,
    required this.identificationNo,
    required this.vehicleNo,
    required this.identificationType,
    required this.lotNo,
  }) : super(key: key);

  @override
  State<SelectPaymentScreenView> createState() =>
      _SelectPaymentScreenViewState();
}

class _SelectPaymentScreenViewState extends State<SelectPaymentScreenView>
    with SingleTickerProviderStateMixin {
  late SelectPaymentScreenController controller;
  late OnlinePaymentModel onlinePaymentModel = OnlinePaymentModel();
  late Function() addSeasonPassData;
  late String selectedBankId;

  String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  @override
  void initState() {
    super.initState();
    onlinePaymentModel = OnlinePaymentModel();
    controller = Get.put(SelectPaymentScreenController());
    controller.onInit(); // Call onInit manually

    // Retrieve arguments and assign addSeasonPassData
    final Map<String, dynamic> args = Get.arguments;
    addSeasonPassData = args["addSeasonPassData"];

    selectedBankId = widget.selectedBankId ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SelectPaymentScreenController>(
      init: SelectPaymentScreenController(),
      builder: (controller) {
        return Scaffold(
          appBar: UiInterface().customAppBar(
            context,
            "Checkout".tr,
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
                      // const Divider(
                      //   color: Colors.black,
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pass Details".tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: AppThemData.semiBold,
                              color: AppColors.darkGrey08,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow("Pass Name".tr, widget.passName),
                          _buildDetailRow(
                            "Price".tr,
                            "RM ${widget.passPrice}",
                          ),
                          _buildDetailRow("Validity".tr, widget.passValidity),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      // Payment methods
                      // PaymentMethodsSections(
                      //   controller: controller,
                      // ),
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
                        ],
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: controller.paymentModel.value.wallet != null &&
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
                        visible: controller.paymentModel.value.commercePay !=
                                null &&
                            controller.paymentModel.value.commercePay!.enable ==
                                true,
                        child: paymentOnlineDecoration(
                          controller: controller,
                          value: controller.paymentModel.value.commercePay!.name
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
                          selectedBankId: widget.selectedBankId,
                          updateSelectedBankId: (bankId) {
                            setState(() {
                              selectedBankId =
                                  bankId ?? ""; // Update selected bank ID
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: controller.paymentModel.value.strip != null &&
                            controller.paymentModel.value.strip!.enable == true,
                        child: paymentDecoration(
                          controller: controller,
                          value: controller.paymentModel.value.strip!.name
                              .toString(),
                          image: "assets/images/stripe.png",
                        ),
                      ),
                      Visibility(
                        visible: controller.paymentModel.value.paypal != null &&
                            controller.paymentModel.value.paypal!.enable ==
                                true,
                        child: paymentDecoration(
                          controller: controller,
                          value: controller.paymentModel.value.paypal!.name
                              .toString(),
                          image: "assets/images/paypal.png",
                        ),
                      ),
                      _buildPaymentInformation(widget.passPrice),
                      const Divider(
                        color: Colors.black,
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
                  final passData = await addSeasonPassData();
                  final passPrice = controller
                      .purchasePassModel.value.seasonPassModel!.price!;
                  // Obtain the access token after selecting the bank
                  await controller.commercepayMakePayment(
                    amount: double.parse(passPrice).toStringAsFixed(
                      Constant.currencyModel!.decimalDigits!,
                    ),
                  );

                  // Calculate total price using the passPrice
                  double totalPrice = calculateTotalPrice(passPrice);

                  // String? accessToken = await controller.commercepayMakePayment(
                  //   amount: double.parse(passPrice).toStringAsFixed(
                  //     Constant.currencyModel!.decimalDigits!,
                  //   ),
                  // );

                  // Retrieve the access token from the controller
                  String? accessToken = controller.authResultModel.accessToken;

                  // Convert Timestamp to DateTime
                  DateTime? convertTimestampToDateOnly(Timestamp? timestamp) {
                    if (timestamp == null) return null;
                    DateTime dateTime = timestamp.toDate();
                    return DateTime(
                        dateTime.year, dateTime.month, dateTime.day);
                  }

                  onlinePaymentModel = OnlinePaymentModel(
                    accessToken: accessToken,
                    customerId: passData['customerId'],
                    selectedBankId: selectedBankId,
                    totalPrice: totalPrice,
                    address: passData['address'],
                    companyName: passData['companyName'],
                    companyRegistrationNo: passData['companyRegistrationNo'],
                    endDate: convertTimestampToDateOnly(passData['endDate']),
                    startDate:
                        convertTimestampToDateOnly(passData['startDate']),
                    fullName: passData['fullName'],
                    email: passData['email'],
                    mobileNumber: passData['mobileNumber'],
                    userName: passData['email'],
                    identificationNo: passData['identificationNo'],
                    identificationType: '2',
                    vehicleNo: passData['vehicleNo'],
                    lotNo: passData['lotNo'],
                    selectedPassId: widget.passId,
                    channelId: '2',
                  );
                  print('Online Payment Data: $onlinePaymentModel');
                  Get.toNamed(
                    Routes.WEBVIEW_SCREEN,
                    arguments: {
                      'onlinePaymentModel': onlinePaymentModel,
                    },
                  );
                  // controller.completeOrder();
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.strip!.name) {
                  // Call the controller method to make the stripe payment
                  controller.stripeMakePayment(
                    amount: double.parse(
                      controller
                          .purchasePassModel.value.seasonPassModel!.price!,
                    ).toStringAsFixed(Constant.currencyModel!.decimalDigits!),
                  );
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.paypal!.name) {
                  // Call the controller method to handle PayPal payment
                  controller.paypalPaymentSheet(
                    double.parse(
                      controller
                          .purchasePassModel.value.seasonPassModel!.price!,
                    ).toStringAsFixed(Constant.currencyModel!.decimalDigits!),
                  );
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.wallet!.name) {
                  // Check if the wallet amount is sufficient
                  if (double.parse(controller.customerModel.value.walletAmount
                          .toString()) >=
                      double.parse(
                        controller
                            .purchasePassModel.value.seasonPassModel!.price!,
                      )) {
                    // Create a transaction model for wallet deduction
                    WalletTransactionModel transactionModel =
                        WalletTransactionModel(
                      id: Constant.getUuid(),
                      amount:
                          "-${double.parse(controller.purchasePassModel.value.seasonPassModel!.price!).toString()}",
                      createdDate: Timestamp.now(),
                      paymentType: controller.selectedPaymentMethod.value,
                      transactionId: controller.purchasePassModel.value.id,
                      parkingId: controller
                          .purchasePassModel.value.seasonPassModel!.passid!
                          .toString(),
                      note: "Season pass ".tr,
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
                              "-${double.parse(controller.purchasePassModel.value.seasonPassModel!.price!).toString()}",
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
      Text(
        "Payment Information".tr,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: AppThemData.semiBold,
          color: AppColors.darkGrey08,
        ),
      ),
      const SizedBox(height: 20),
      _buildDetailRow("Sub Total".tr,
          "RM ${price.toStringAsFixed(2)}"), // Convert price to string
      _buildDetailRow("${"Tax ".tr}(6%)", "RM ${tax.toStringAsFixed(2)}"),
      const Divider(),
      _buildTotalRow("Total Amount".tr, "RM ${totalPrice.toStringAsFixed(2)}"),
    ],
  );
}

double calculateTotalPrice(String passPrice) {
  // Convert passPrice to a double
  double price = double.parse(passPrice);

  // Calculate tax (6% of pass price)
  double tax = 0.06 * price;

  // Calculate total amount
  double totalPrice = price + tax;

  return totalPrice;
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
  required SelectPaymentScreenController controller,
  required String value,
  required String image,
  required String? selectedBankName,
  required String? selectedBankId,
  required Function(String?) updateSelectedBankName,
  required Function(String?) updateSelectedBankId,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: InkWell(
      onTap: () async {
        controller.selectedPaymentMethod.value = value.toString();
        if (value == "Online Banking") {
          final passPrice =
              controller.purchasePassModel.value.seasonPassModel!.price!;
          controller.commercepayMakePayment(
            amount: double.parse(passPrice)
                .toStringAsFixed(Constant.currencyModel!.decimalDigits!),
          );
          final result = await Get.toNamed(Routes.SELECT_BANK_PROVIDER_SCREEN);
          if (result != null && result is Map<String, dynamic>) {
            updateSelectedBankName(
                result['bankName']); // Update selected bank name
            updateSelectedBankId(result['bankId']); // Update selected bank ID
            print('Selected Bank Name: ${result['bankName']}');
            print('Selected Bank Id: ${result['bankId']}');
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
                    "Online Banking".tr,
                    style: const TextStyle(
                      fontFamily: AppThemData.semiBold,
                      fontSize: 16,
                      color: AppColors.darkGrey08,
                    ),
                  ),
                ),
                Text(
                  selectedBankName != null && selectedBankName.isNotEmpty
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
            color: (controller.selectedPaymentMethod.value == value.toString())
                ? AppColors.yellow04
                : AppColors.darkGrey04,
          ),
        ],
      ),
    ),
  );
}

Widget paymentDecoration({
  required SelectPaymentScreenController controller,
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
                    (value == "wallet") ? "My Wallet".tr : "Online Banking".tr,
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
            color: (controller.selectedPaymentMethod.value == value.toString())
                ? AppColors.yellow04
                : AppColors.darkGrey04,
          ),
        ],
      ),
    ),
  );
}
