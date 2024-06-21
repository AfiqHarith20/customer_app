import 'package:customer_app/app/modules/transaction_history_detail_screen/controllers/transaction_history_detail_screen_controller.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionHistoryDetailScreenView extends StatefulWidget {
  const TransactionHistoryDetailScreenView({super.key});

  @override
  State<TransactionHistoryDetailScreenView> createState() =>
      _TransactionHistoryDetailScreenViewState();
}

class _TransactionHistoryDetailScreenViewState
    extends State<TransactionHistoryDetailScreenView> {
  final TransactionHistoryDetailScreenController controller =
      Get.put(TransactionHistoryDetailScreenController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: RepaintBoundary(
                key: GlobalKey(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'NAZIFA RESOURCES SDN. BHD.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGrey08,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'NO.32, JALAN SUDIRMAN 7, 28000, TEMERLOH',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGrey08,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'PAHANG DARUL MAKMUR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGrey08,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'TEL: 09-2964820, FAX: 09-2968475',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGrey08,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'NO SST: C21-1808-31010712',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGrey08,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: FittedBox(
                          child: Text(
                            "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkGrey08,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Center(
                            child: Text(
                              controller.customerModel.value.fullName ??
                                  ''.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.darkGrey08,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          )),
                      const SizedBox(height: 8),
                      Obx(() => Center(
                            child: Text(
                              "Email: ${controller.customerModel.value.email ?? ''}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.darkGrey08,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          )),
                      const SizedBox(height: 8),
                      const Center(
                        child: FittedBox(
                          child: Text(
                            "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkGrey08,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Receipt #${controller.transactionHistoryModel.transactionNumber.toString()}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: AppColors.darkGrey08,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Date ${formatDate(controller.transactionHistoryModel.createAt!)}",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.darkGrey08,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Center(
                        child: FittedBox(
                          child: Text(
                            "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkGrey08,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text(
                              "Item Description",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.darkGrey06,
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Price",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.darkGrey06,
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Center(
                        child: FittedBox(
                          child: Text(
                            "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkGrey06,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text(
                              controller.transactionHistoryModel.transactionType
                                  .toString(),
                              style: const TextStyle(
                                color: AppColors.darkGrey08,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              textAlign: TextAlign.end,
                              'RM${controller.transactionHistoryModel.amount!}',
                              style: const TextStyle(
                                color: AppColors.darkGrey08,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: FittedBox(
                          child: Text(
                            "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkGrey06,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // const Expanded(flex: 1, child: SizedBox()),
                              Expanded(
                                flex: 11,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'SUBTOTAL'.tr,
                                      style: const TextStyle(
                                        color: AppColors.darkGrey06,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'RM${controller.transactionHistoryModel.amount!}',
                                      style: const TextStyle(
                                        color: AppColors.darkGrey06,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "TOTAL",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.darkGrey06,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'RM${controller.transactionHistoryModel.amount!}',
                                style: const TextStyle(
                                  color: AppColors.darkGrey06,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const Center(
                            child: FittedBox(
                              child: Text(
                                "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.darkGrey06,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Payment Method",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.darkGrey08,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                controller.transactionHistoryModel.paymentType
                                    .toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: AppColors.darkGrey08,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: FittedBox(
                              child: Text(
                                "Thank You",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.darkGrey06,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy hh:mm a');
    return formatter.format(dateTime);
  }
}
