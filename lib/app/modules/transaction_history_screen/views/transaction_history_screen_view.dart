import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:customer_app/app/modules/transaction_history_screen/controllers/transaction_history_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/common_ui.dart';

class TransactionHistoryScreenView extends StatefulWidget {
  const TransactionHistoryScreenView({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreenView> createState() =>
      _TransactionHistoryScreenViewState();
}

class _TransactionHistoryScreenViewState
    extends State<TransactionHistoryScreenView> {
  late TransactionHistoryScreenController controller;

  DateTime? startDate;
  DateTime? endDate;
  bool showDateSelector = false;
  int selectedFilterIndex = -1; // Default to "Today"

  @override
  void initState() {
    super.initState();
    controller = Get.put(TransactionHistoryScreenController());
    controller.getTransactionHistory();
    startDate = DateTime.now().subtract(const Duration(days: 7));
    endDate = DateTime.now();
    resetDates();
  }

  void resetDates() {
    final now = DateTime.now();
    switch (selectedFilterIndex) {
      case 0: // Today
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 1: // Yesterday
        startDate = DateTime(now.year, now.month, now.day - 1);
        endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
        break;
      case 2: // Last 7 days
        startDate = now.subtract(const Duration(days: 7));
        endDate = now;
        break;
      case 3: // Last 30 days
        startDate = now.subtract(const Duration(days: 30));
        endDate = now;
        break;
      default:
        startDate = null;
        endDate = null;
        break;
    }
    if (startDate != null && endDate != null) {
      print('Filtering transactions from $startDate to $endDate');
      controller.filterTransactions(startDate!, endDate!);
    }
  }

  Future<void> _selectStartDate() async {
    final screenSize = MediaQuery.of(context).size;
    // Adjust dialog width based on screen width
    final dialogWidth = screenSize.width * 0.8;

    final selectedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: DateTime(2020, 1, 1),
        lastDate: DateTime.now(),
        selectedDayHighlightColor: AppColors.yellow04,
        okButtonTextStyle: const TextStyle(
          color: AppColors.yellow04,
        ),
        cancelButtonTextStyle: const TextStyle(
          color: AppColors.red04,
        ),
        calendarType: CalendarDatePicker2Type.range,
      ),
      value: [startDate, endDate],
      // Adjusted size for the dialog
      dialogSize: Size(dialogWidth, 450),
    );

    if (selectedDates != null && selectedDates.isNotEmpty) {
      setState(() {
        startDate = selectedDates[0];
        endDate = selectedDates.length > 1 ? selectedDates[1] : startDate;
        selectedFilterIndex = -1; // Custom date range
      });

      // Filter transactions immediately after selecting dates
      if (startDate != null && endDate != null) {
        print('Custom date range selected: from $startDate to $endDate');
        controller.filterTransactions(startDate!, endDate!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: UiInterface().customAppBar(
        isBack: false,
        context,
        "History".tr,
        backgroundColor: AppColors.lightGrey02,
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showDateSelector = !showDateSelector;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.darkGrey02.withOpacity(0.5),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedFilterIndex == 0 || selectedFilterIndex == 1
                          ? startDate != null
                              ? DateFormat('dd MMM yyyy').format(startDate!)
                              : 'Select Date'.tr
                          : startDate != null && endDate != null
                              ? '${DateFormat('dd MMM yyyy').format(startDate!)} - ${DateFormat('dd MMM yyyy').format(endDate!)}'
                              : 'Select Date Range'.tr,
                      style: const TextStyle(
                        color: AppColors.darkGrey09,
                        fontSize: 14,
                      ),
                    ),
                    Image.asset(
                      "assets/images/filter.png",
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          if (showDateSelector)
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          'Transaction History up to 30 days only'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey09,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            showDateSelector = false;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 4.0,
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 0,
                      children: [
                        for (int i = 0; i < 4; i++)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedFilterIndex = i;
                                showDateSelector =
                                    false; // Hide date selector after selection
                                resetDates();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedFilterIndex == i
                                  ? AppColors.yellow04
                                  : AppColors.white,
                              side: const BorderSide(
                                color: AppColors.darkGrey02,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              [
                                'Today'.tr,
                                'Yesterday'.tr,
                                'Last 7 days'.tr,
                                'Last 30 days'.tr
                              ][i],
                              style: TextStyle(
                                color: selectedFilterIndex == i
                                    ? AppColors.white
                                    : AppColors.darkGrey09,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Custom Date Range'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey09,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _selectStartDate();
                            setState(() {
                              selectedFilterIndex = -1;
                              showDateSelector = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedFilterIndex == -1
                                ? AppColors.yellow04
                                : AppColors.white,
                            side: const BorderSide(
                              color: AppColors.darkGrey02,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  startDate != null
                                      ? DateFormat('dd MMM yyyy')
                                          .format(startDate!)
                                      : 'Select Date'.tr,
                                  style: const TextStyle(
                                    color: AppColors.darkGrey09,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _selectStartDate();
                            setState(() {
                              selectedFilterIndex = -1;
                              showDateSelector = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedFilterIndex == -1
                                ? AppColors.yellow04
                                : AppColors.white,
                            side: const BorderSide(
                              color: AppColors.darkGrey02,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  endDate != null
                                      ? DateFormat('dd MMM yyyy')
                                          .format(endDate!)
                                      : 'Select Date'.tr,
                                  style: const TextStyle(
                                    color: AppColors.darkGrey09,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Constant.loader();
              } else if (controller.transactionHistoryList.isEmpty) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Image.asset(
                          "assets/images/empty-box.png",
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet'.tr,
                          style: const TextStyle(
                            color: AppColors.darkGrey09,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Text(
                        //   'You currently have no transactions.\nBut, when you do, they\'ll show up here!'
                        //       .tr,
                        //   textAlign: TextAlign.center,
                        //   style: const TextStyle(
                        //     color: AppColors.darkGrey09,
                        //     fontSize: 14,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.transactionHistoryList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final comp = controller.transactionHistoryList[index];
                    final amount = comp['amount'];
                    final createAt = comp['createAt'];
                    final channelId = comp['channelId'];
                    final passType = comp['passType'];
                    final id = comp['id'];
                    final paymentType = comp['paymentType'];
                    final credit = comp['credit'];
                    final providerChannelId = comp['providerChannelId'];
                    final providerTransactionNumber =
                        comp['providerTransactionNumber'];
                    final providerPaymentMethod = comp['providerPaymentMethod'];
                    final referenceCode = comp['referenceCode'];
                    final transactionNumber = comp['transactionNumber'];
                    final status = comp['status'];
                    final transactionType = comp['transactionType'];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.TRANSACTION_HISTORY_DETAIL_SCREEN,
                          arguments: {
                            'amount': amount ?? '',
                            'createAt': createAt ?? '',
                            'id': id ?? '',
                            'passType': passType ?? '',
                            'providerPaymentMethod':
                                providerPaymentMethod ?? '',
                            'paymentType': paymentType ?? '',
                            'providerChannelId': providerChannelId ?? '',
                            'providerTransactionNumber':
                                providerTransactionNumber ?? '',
                            'referenceCode': referenceCode ?? '',
                            'transactionNumber': transactionNumber ?? '',
                            'transactionType': transactionType ?? '',
                            'status': status ?? '',
                            'channelId': channelId ?? '',
                            'credit': credit,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.darkGrey02.withOpacity(0.5),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              itemWidget(
                                subText: '',
                                title: formatDate(createAt),
                              ),
                              itemWidget2(
                                subText: 'RM${amount ?? '0.00'}',
                                title: transactionType ?? '-',
                              ),
                              itemWidget(
                                subText: '',
                                title: providerPaymentMethod ?? '-',
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  static Widget itemWidget({
    required String subText,
    required String title,
    Color? subTextColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppThemData.regular,
                  color: AppColors.darkGrey09,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                subText.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: subTextColor ?? Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ).marginOnly(left: 10, right: 10),
      ),
    );
  }

  static Widget itemWidget2({
    required String subText,
    required String title,
    Color? subTextColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: AppThemData.medium,
                  color: AppColors.darkGrey09,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                subText.tr,
                style: TextStyle(
                    fontSize: 14,
                    color: subTextColor ?? Colors.black,
                    fontFamily: AppThemData.medium),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ).marginOnly(left: 10, right: 10),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }
}
