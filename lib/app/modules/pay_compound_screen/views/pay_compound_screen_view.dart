// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/commercepay/transaction_fee_model.dart';
import 'package:customer_app/app/models/compound_model.dart';
import 'package:customer_app/app/models/my_payment_compound_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/app/models/wallet_transaction_model.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import 'package:customer_app/app/modules/pay_compound_screen/controllers/pay_compoun_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/svg_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/common_ui.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';

class PayCompoundScreenView extends StatefulWidget {
  final String selectedBankId;
  late String selectedBankName;
  final String accessToken;
  final String compoundNo;
  final String vehicleNum;
  final String customerId;
  final String amount;
  final String mobileNumber;
  final String address;
  final String kodHasil;
  final String name;
  final String userName;
  final String identificationNo;
  final String identificationType;
  final String email;
  PayCompoundScreenView({
    Key? key,
    required this.selectedBankId,
    required this.selectedBankName,
    required this.accessToken,
    required this.compoundNo,
    required this.vehicleNum,
    required this.customerId,
    required this.amount,
    required this.mobileNumber,
    required this.address,
    required this.kodHasil,
    required this.name,
    required this.userName,
    required this.identificationNo,
    required this.identificationType,
    required this.email,
  }) : super(key: key);

  @override
  State<PayCompoundScreenView> createState() => _PayCompoundScreenViewState();
}

class _PayCompoundScreenViewState extends State<PayCompoundScreenView> {
  late PayCompoundScreenController controller;
  late String selectedBankId;
  // late Function() compoundModel;
  late CompoundModel compoundModel;
  late MyPaymentCompoundModel myPaymentCompoundModel = MyPaymentCompoundModel();

  String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  @override
  void initState() {
    myPaymentCompoundModel = MyPaymentCompoundModel();
    controller = Get.put(PayCompoundScreenController());
    controller.onInit();
    Map<String, dynamic> arguments = Get.arguments;
    if (arguments != null && arguments.containsKey("payCompoundModel")) {
      compoundModel = CompoundModel.fromJson(arguments["payCompoundModel"]);
      // Now you have access to the compoundModel, you can use it as needed
      print('Compound Number: ${compoundModel.compoundNo ?? ''}');
      print('Amount: ${compoundModel.amount}');
      print('vehicle no: ${compoundModel.vehicleNum ?? ''}');
      // TODO: implement initState
      super.initState();
      final compoundPrice = controller.compoundModel.value.amount ?? '';
      controller.commercepayCompoundPayment(
        amount: compoundPrice,
      );

      selectedBankId = widget.selectedBankId ?? "";
      String accessToken = widget.accessToken; // Access the accessToken here
      // Check if accessToken is not empty
      if (accessToken.isNotEmpty) {
        // Do something with the accessToken
        // print("Access token from select payment screen: $accessToken");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PayCompoundScreenController>(
      init: PayCompoundScreenController(),
      builder: (controller) {
        return Scaffold(
          appBar: UiInterface().customAppBar(
            context,
            "Checkout".tr,
            backgroundColor: AppColors.white,
            // onBackTap: () {
            //   Get.offAllNamed(Routes.SEARCH_SUMMON_SCREEN);
            // },
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
                            "Compound Details".tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: AppThemData.semiBold,
                              color: AppColors.darkGrey08,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow(
                            "Compound Number".tr,
                            compoundModel.compoundNo ?? '',
                          ),
                          _buildDetailRow(
                            "Full Name".tr,
                            controller.customerModel.value.fullName.toString(),
                          ),
                          _buildDetailRow(
                            "Price".tr,
                            "RM ${compoundModel.amount ?? ''}",
                          ),
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
                        ],
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: controller.paymentModel.value.wallet != null &&
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
                            controller.paymentModel.value.commercePay!.enable ==
                                true,
                        child: paymentOnlineDecoration(
                          controller: controller,
                          value:
                              controller.paymentModel.value.commercePay?.name ??
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
                        visible: controller.paymentModel.value.strip != null &&
                            controller.paymentModel.value.strip!.enable == true,
                        child: paymentDecoration(
                          controller: controller,
                          value:
                              controller.paymentModel.value.strip?.name ?? '',
                          image: "assets/images/stripe.png",
                        ),
                      ),
                      Visibility(
                        visible: controller.paymentModel.value.paypal != null &&
                            controller.paymentModel.value.paypal!.enable ==
                                true,
                        child: paymentDecoration(
                          controller: controller,
                          value:
                              controller.paymentModel.value.paypal?.name ?? '',
                          image: "assets/images/paypal.png",
                        ),
                      ),
                      _buildPaymentInformation(
                        compoundModel,
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
                // Check the selected payment method
                if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.commercePay!.name) {
                  final amount = compoundModel.amount ?? '';
                  // Obtain the access token after selecting the bank
                  await controller.commercepayCompoundPayment(
                    amount: double.parse(amount).toStringAsFixed(
                      Constant.currencyModel!.decimalDigits!,
                    ),
                  );
                  // Calculate total price using the passPrice
                  double totalPrice = calculateTotalPrice(
                    compoundModel,
                    controller.taxModel!.value! != null
                        ? double.parse(controller.taxModel!.value!)
                        : 0.0,
                  );

                  // Retrieve the access token from the controller
                  String? accessToken = controller.authResultModel.accessToken;

                  // String? accessToken =
                  //     await controller.commercepayCompoundPayment(
                  //   amount: double.parse(amount).toStringAsFixed(
                  //     Constant.currencyModel!.decimalDigits!,
                  //   ),
                  // );

                  // Convert Timestamp to DateTime
                  // DateTime? convertTimestampToDateOnly(Timestamp? timestamp) {
                  //   if (timestamp == null) return null;
                  //   DateTime dateTime = timestamp.toDate();
                  //   return DateTime(
                  //       dateTime.year, dateTime.month, dateTime.day);
                  // }

                  myPaymentCompoundModel = MyPaymentCompoundModel(
                    accessToken: accessToken,
                    customerId: FireStoreUtils.getCurrentUid(),
                    selectedBankId: selectedBankId,
                    amount: totalPrice.toStringAsFixed(2),
                    address: controller.customerModel.value.address.toString(),
                    name: controller.customerModel.value.fullName.toString(),
                    email: controller.customerModel.value.email.toString(),
                    mobileNumber:
                        controller.customerModel.value.phoneNumber.toString(),
                    userName: controller.customerModel.value.email.toString(),
                    identificationNo: controller
                        .customerModel.value.identificationNo
                        .toString(),
                    identificationType: '1',
                    vehicleNum: compoundModel.vehicleNum ?? '',
                    channelId: '18',
                    compoundNo: compoundModel.compoundNo ?? '',
                    kodHasil: compoundModel.kodHasil ?? '',
                  );
                  // print('Compound payment Data: $myPaymentCompoundModel');
                  // print('accessToken: ${myPaymentCompoundModel.accessToken}');
                  // print('customerId: ${myPaymentCompoundModel.customerId}');
                  // print(
                  //     'providerChannelId: ${myPaymentCompoundModel.selectedBankId}');
                  // print('amount: ${myPaymentCompoundModel.amount}');
                  // print('address: ${myPaymentCompoundModel.address}');
                  // print('name: ${myPaymentCompoundModel.name}');
                  // print('email: ${myPaymentCompoundModel.email}');
                  // print('mobileNumber: ${myPaymentCompoundModel.mobileNumber}');
                  // print('username: ${myPaymentCompoundModel.userName}');
                  // print(
                  //     'identificationNumber: ${myPaymentCompoundModel.identificationNo}');
                  // print(
                  //     'identificationType: ${myPaymentCompoundModel.identificationType}');
                  // print('vehicleNo: ${myPaymentCompoundModel.vehicleNum}');
                  // print('channelId: ${myPaymentCompoundModel.channelId}');
                  // print('compoundNo: ${myPaymentCompoundModel.compoundNo}');
                  // print('kodHasil: ${myPaymentCompoundModel.kodHasil}');
                  Get.offAllNamed(
                    Routes.WEBVIEW_COMPOUND_SCREEN,
                    arguments: {
                      'myPaymentCompoundModel': myPaymentCompoundModel,
                    },
                  );
                  // controller.completeOrder();
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.strip!.name) {
                  // Call the controller method to make the stripe payment
                  controller.stripeMakePayment(
                    amount: double.parse(
                      controller.myPaymentCompoundModel.value.amount!,
                    ).toStringAsFixed(Constant.currencyModel!.decimalDigits!),
                  );
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.paypal!.name) {
                  // Call the controller method to handle PayPal payment
                  controller.paypalPaymentSheet(
                    double.parse(
                      controller.myPaymentCompoundModel.value.amount!,
                    ).toStringAsFixed(Constant.currencyModel!.decimalDigits!),
                  );
                } else if (controller.selectedPaymentMethod.value ==
                    controller.paymentModel.value.wallet!.name) {
                  // Check if the wallet amount is sufficient
                  if (double.parse(controller.customerModel.value.walletAmount
                          .toString()) >=
                      double.parse(
                        controller.myPaymentCompoundModel.value.amount!,
                      )) {
                    // Create a transaction model for wallet deduction
                    WalletTransactionModel transactionModel =
                        WalletTransactionModel(
                      id: Constant.getUuid(),
                      amount:
                          "-${double.parse(controller.myPaymentCompoundModel.value.amount!).toString()}",
                      createdDate: Timestamp.now(),
                      paymentType: controller.selectedPaymentMethod.value,
                      transactionId: controller.myPaymentCompoundModel.value.id,
                      parkingId: controller.myPaymentCompoundModel.value.id!
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
                              "-${double.parse(controller.myPaymentCompoundModel.value.amount!).toString()}",
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

Widget paymentOnlineDecoration({
  required PayCompoundScreenController controller,
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
  required PayCompoundScreenController controller,
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

Widget _buildPaymentInformation(CompoundModel compoundModel, TaxModel? taxModel,
    TransactionFeeModel? transactionFee) {
  // Convert passPrice to a double
  double price = double.parse(compoundModel.amount ?? '0.0');

  // Calculate tax (based on the fetched tax value)
  double tax = double.parse(taxModel!.value!) * price;

  double taxValue = 0.0;
  if (taxModel != null) {
    taxValue = double.parse(taxModel.value!);
  }
  // Convert transaction fee from String to double and calculate the amount
  double transactionFeeAmount = 0.0;
  if (transactionFee != null) {
    transactionFeeAmount = double.parse(transactionFee.value!);
  }

  // Calculate total amount
  double totalPrice = price + tax + transactionFeeAmount;

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
      _buildDetailRow(
          "${taxModel.name}(${(taxValue * 100).toStringAsFixed(0)}%)",
          "RM ${tax.toStringAsFixed(2)}"),
      _buildDetailRow("Transaction Fee".tr,
          "RM ${transactionFeeAmount.toStringAsFixed(2)}"),
      const Divider(),
      _buildTotalRow("Total Amount".tr, "RM ${totalPrice.toStringAsFixed(2)}"),
    ],
  );
}

double calculateTotalPrice(CompoundModel compoundModel, double taxValue) {
  // Convert passPrice to a double
  double price = double.parse(compoundModel.amount ?? '0.0');

  // Calculate tax (6% of pass price)
  double tax = taxValue * price;

  // Calculate total amount
  double totalPrice = price + tax;

  return totalPrice;
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
