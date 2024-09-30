// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/commercepay/pending_payment_model.dart';
import 'package:customer_app/app/models/commercepay/transaction_fee_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/app/models/wallet_transaction_model.dart';
import 'package:customer_app/app/modules/pay_pending_pass_screen/controllers/pay_pending_pass_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/svg_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unnecessary_import
import 'package:get/get_state_manager/get_state_manager.dart';

class PayPendingPassScreenView extends StatefulWidget {
  PayPendingPassScreenView({
    super.key,
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
  });

  final String accessToken;
  final String address;
  final String companyName;
  final String companyRegistrationNo;
  final String customerId;
  final String email;
  final Timestamp endDate;
  final String fullName;
  final String identificationNo;
  final String identificationType;
  final String lotNo;
  final String mobileNumber;
  final String passId;
  final String passName;
  final String passPrice;
  final String passValidity;
  final String? selectedBankId;
  late String selectedBankName;
  final String selectedPassId;
  final Timestamp startDate;
  final double totalPrice;
  final String userName;
  final String vehicleNo;

  @override
  State<PayPendingPassScreenView> createState() =>
      _PayPendingPassScreenViewState();
}

class _PayPendingPassScreenViewState extends State<PayPendingPassScreenView>
    with SingleTickerProviderStateMixin {
  late PayPendingPassScreenController controller;
  late PendingPaymentModel pendingPaymentModel = PendingPaymentModel();
  late String selectedBankId;

  @override
  void dispose() {
    if (Get.isRegistered<PayPendingPassScreenController>()) {
      Get.delete<PayPendingPassScreenController>();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pendingPaymentModel = PendingPaymentModel();
    controller = Get.put(PayPendingPassScreenController());
    controller.onInit(); // Call onInit manually

    final passPrice = controller.passPrice.value.toString();
    controller.commercepayMakePayment(
      amount: double.parse(passPrice)
          .toStringAsFixed(Constant.currencyModel!.decimalDigits!),
    );

    selectedBankId = widget.selectedBankId ?? "";
    String accessToken = widget.accessToken; // Access the accessToken here
    // Check if accessToken is not empty
    if (accessToken.isNotEmpty) {
      // Do something with the accessToken
      // print("Access token from select payment screen: $accessToken");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PayPendingPassScreenController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.cleanup();
            Get.back();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Checkout".tr,
                style: const TextStyle(color: AppColors.darkGrey07),
              ),
              backgroundColor: AppColors.white,
              leading: IconButton(
                color: AppColors.darkGrey07,
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  controller.cleanup();
                  Get.back();
                  // if (result != null && result is Map<String, dynamic>) {
                  //   setState(() {
                  //     controller.passId = result['passId'];
                  //     widget.selectedBankName = result['bankName'];
                  //     controller.purchasePassModel.value.startDate;
                  //     controller.purchasePassModel.value.endDate;
                  //     controller.purchasePassModel.value.vehicleNo;
                  //   });
                  // }
                },
              ),
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
                              "Pass Details".tr,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: AppThemData.semiBold,
                                color: AppColors.darkGrey08,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDetailRow(
                                "Pass Name".tr, controller.passName.value),
                            const SizedBox(height: 5),
                            _buildDetailRow(
                              "Price".tr,
                              "RM ${controller.passPrice.value.toString()}",
                            ),
                            const SizedBox(height: 5),
                            _buildDetailRow("Validity".tr,
                                controller.passValidity.value.tr),
                            const SizedBox(height: 5),
                            _buildDetailRow(
                              "Start Time".tr,
                              Timestamp.fromDate(DateTime.now()) != null
                                  ? Constant.timestampToDate(
                                      Timestamp.fromDate(DateTime.now()),
                                    )
                                  : "Start date not available",
                            ),
                            const SizedBox(height: 5),
                            _buildDetailRow(
                              "End Time".tr,
                              Timestamp.fromDate(DateTime.now().add(
                                        Duration(
                                          days: controller.checkDuration(
                                            controller.passValidity.value,
                                          ),
                                        ),
                                      )) !=
                                      null
                                  ? Constant.timestampToDate(
                                      Timestamp.fromDate(
                                        DateTime.now().add(
                                          Duration(
                                            days: controller.checkDuration(
                                              controller.passValidity.value,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : "End date not available",
                            ),
                            const SizedBox(height: 5),
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
                          visible: controller.paymentModel.value.wallet !=
                                  null &&
                              controller.paymentModel.value.wallet!.enable ==
                                  true,
                          child: paymentDecoration(
                            controller: controller,
                            value: controller.paymentModel.value.wallet != null
                                ? controller.paymentModel.value.wallet!.name!
                                : '',
                            image: "assets/images/wallet.png",
                          ),
                        ),
                        Visibility(
                          visible: controller.paymentModel.value.commercePay !=
                                  null &&
                              controller
                                      .paymentModel.value.commercePay!.enable ==
                                  true,
                          child: paymentOnlineDecoration(
                            controller: controller,
                            value: controller
                                    .paymentModel.value.commercePay?.name ??
                                '',
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
                          visible:
                              controller.paymentModel.value.strip != null &&
                                  controller.paymentModel.value.strip!.enable ==
                                      true,
                          child: paymentDecoration(
                            controller: controller,
                            value:
                                controller.paymentModel.value.strip?.name ?? '',
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
                            value: controller.paymentModel.value.paypal?.name ??
                                '',
                            image: "assets/images/paypal.png",
                          ),
                        ),
                        _buildPaymentInformation(
                          controller.passPrice.value,
                          controller.taxModel,
                          controller.transactionFeeModel,
                        ),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.darkGrey10,
                            ),
                          ),
                        );
                      },
                      barrierDismissible: false,
                    );
                    return;
                  }

                  try {
                    // Check if no payment method is selected
                    if (controller.selectedPaymentMethod.value.isEmpty ||
                        (controller.selectedPaymentMethod.value ==
                                "Online Banking" &&
                            (widget.selectedBankName == null ||
                                widget.selectedBankName.isEmpty))) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogBoxNotify(
                            imageAsset: "assets/images/mobile-payment.png",
                            onPressConfirm: () async {
                              Navigator.of(context).pop();
                            },
                            onPressConfirmBtnName: "Ok".tr,
                            onPressConfirmColor: AppColors.red04,
                            content:
                                "Please select payment method before proceeding to pay."
                                    .tr,
                            subTitle: "Select Payment".tr,
                          );
                        },
                      );
                      return;
                    }

                    // Check if the stored access token is valid before proceeding
                    await controller.checkAuthTokenValidity();

                    // Check the selected payment method
                    if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.commercePay!.name) {
                      // final passData = await addSeasonPassData();
                      final passPrice = controller.passPrice.value.toString();
                      // Obtain the access token after selecting the bank

                      // Calculate total price using the passPrice
                      double totalPrice = calculateTotalPrice(
                        passPrice,
                        controller.taxModel!.value != null
                            ? double.parse(controller.taxModel!.value!)
                            : 0.0,
                        controller.transactionFeeModel?.value != null
                            ? double.parse(
                                controller.transactionFeeModel!.value!)
                            : 0.0,
                      );

                      // Convert Timestamp to DateTime
                      DateTime? convertDateTimeToDateOnly(DateTime? dateTime) {
                        if (dateTime == null) return null;
                        return DateTime(
                            dateTime.year, dateTime.month, dateTime.day);
                      }

                      if (controller.authResultModel.accessToken != null &&
                          controller.authResultModel.accessToken!.isNotEmpty) {
                        String accessToken =
                            controller.authResultModel.accessToken!;

                        DateTime startDate = DateTime.now();
                        DateTime endDate = startDate.add(
                          Duration(
                            days: controller.checkDuration(
                              controller.passValidity.value,
                            ),
                          ),
                        );

                        // Convert startDate and endDate to date-only format
                        DateTime? dateOnlyStartDate =
                            convertDateTimeToDateOnly(startDate);
                        DateTime? dateOnlyEndDate =
                            convertDateTimeToDateOnly(endDate);

                        pendingPaymentModel = PendingPaymentModel(
                          accessToken: accessToken,
                          customerId: controller.customerId.value,
                          selectedBankId: selectedBankId,
                          totalPrice: totalPrice,
                          address: controller.address.value,
                          companyName: controller.companyName.value,
                          companyRegistrationNo:
                              controller.companyRegistrationNo.value,
                          endDate: dateOnlyEndDate,
                          startDate: dateOnlyStartDate,
                          fullName: controller.name.value,
                          email: controller.email.value,
                          mobileNumber: controller.mobileNumber.value,
                          userName: controller.username.value,
                          identificationNo:
                              controller.identificationNumber.value,
                          identificationType: 2,
                          vehicleNo: controller.vehicleNo.value,
                          lotNo: controller.lotNo.value,
                          selectedPassId: controller.privatePassId.value,
                          channelId: '18',
                          zoneId: controller.zoneId.value,
                          zoneName: controller.zoneName.value,
                          roadId: controller.roadId.value,
                          roadName: controller.roadName.value,
                        );

                        // Proceed with navigation
                        controller.cleanup();
                        Get.toNamed(
                          Routes.WEBVIEW_RESERVED_SCREEN,
                          arguments: {
                            'pendingPaymentModel': pendingPaymentModel,
                          },
                        );
                      } else if (controller.selectedPaymentMethod.value ==
                          controller.paymentModel.value.strip!.name) {
                        // Call the controller method to make the stripe payment
                        controller.stripeMakePayment(
                          amount: double.parse(
                            controller.purchasePassModel.value.seasonPassModel!
                                .price!,
                          ).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                        );
                      }
                    }
                    // else if (controller.selectedPaymentMethod.value ==
                    //     controller.paymentModel.value.paypal!.name) {
                    //   // Call the controller method to handle PayPal payment
                    //   controller.paypalPaymentSheet(
                    //     double.parse(
                    //       controller
                    //           .purchasePassModel.value.seasonPassModel!.price!,
                    //     ).toStringAsFixed(Constant.currencyModel!.decimalDigits!),
                    //   );
                    // }
                    else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.wallet!.name) {
                      // Check if the wallet amount is sufficient
                      if (double.parse(controller
                              .customerModel.value.walletAmount
                              .toString()) >=
                          double.parse(
                            controller.purchasePassModel.value.seasonPassModel!
                                .price!,
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
                        ShowToastDialog.showToast(
                            "Wallet Amount Insufficient".tr);
                      }
                    }
                  } finally {
                    controller.isLoading.value = false;
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildPaymentInformation(
    String passPrice, TaxModel? taxModel, TransactionFeeModel? transactionFee) {
  // Convert passPrice to a double
  double price = double.parse(passPrice);

  // Calculate tax (based on the fetched tax value)
  // double taxValue = 0.0;
  // if (taxModel != null && taxModel.value != null) {
  //   try {
  //     taxValue = double.parse(taxModel.value!);
  //   } catch (e) {
  //     // Handle parse error
  //     print("Error parsing tax value: $e");
  //   }
  // }
  // double tax = taxValue * price;

  // Convert transaction fee from String to double and calculate the amount
  double transactionFeeAmount = 0.0;
  if (transactionFee != null && transactionFee.value != null) {
    try {
      transactionFeeAmount = double.parse(transactionFee.value!);
    } catch (e) {
      // Handle parse error
      print("Error parsing transaction fee: $e");
    }
  }

  // Calculate total amount
  double totalPrice = price + transactionFeeAmount;

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
      // _buildDetailRow(
      //     "${taxModel?.name}(${(taxValue * 100).toStringAsFixed(0)}%)",
      //     "RM ${tax.toStringAsFixed(2)}"),
      _buildDetailRow("Transaction Fee".tr,
          "RM ${transactionFeeAmount.toStringAsFixed(2)}"),
      const Divider(),
      _buildTotalRow("Total Amount".tr, "RM ${totalPrice.toStringAsFixed(2)}"),
    ],
  );
}

double calculateTotalPrice(
    String passPrice, double taxValue, double transactionFeeAmount) {
  // Convert passPrice to a double
  double price = double.parse(passPrice);

  // Calculate tax (as a percentage of pass price)
  double tax = taxValue * price;

  // Calculate total amount including transaction fee
  double totalPrice = price + tax + transactionFeeAmount;

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
  required PayPendingPassScreenController controller,
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
  required PayPendingPassScreenController controller,
  required String value,
  required String image,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: InkWell(
      onTap: () {
        if (value != "wallet") {
          controller.selectedPaymentMethod.value = value.toString();
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
                    (value == "wallet") ? "My Wallet".tr : "Online Banking".tr,
                    style: const TextStyle(
                      fontFamily: AppThemData.semiBold,
                      fontSize: 16,
                      color: AppColors.darkGrey08,
                    ),
                  ),
                ),
                Text(
                  (value == "wallet" &&
                          controller.paymentModel.value.wallet != null)
                      ? "Available Balance:-".tr +
                          Constant.amountShow(
                            amount: controller.customerModel.value.walletAmount,
                          )
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
