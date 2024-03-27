// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/booking_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_model.dart';
import 'package:customer_app/app/modules/choose_date_time_screen/controllers/choose_date_time_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/text_field_suffix_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChooseDateTimeScreenView extends StatelessWidget {
  const ChooseDateTimeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ChooseDateTimeScreenController>(
        init: ChooseDateTimeScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface().customAppBar(context, "Select Date and Time".tr, backgroundColor: AppColors.white),
            body: controller.isLoading.value
                ? Constant.loader()
                : (controller.isLoadingNumber.value)
                    ? Center(
                        child: Lottie.asset(
                          "assets/gif/car-number-plate.json",
                          width: 150,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWidgetSuffix(
                                suffix: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_calender.svg",
                                  ),
                                ),
                                title: "Date".tr,
                                readOnly: true,
                                hintText: "Enter Date".tr,
                                controller: controller.selectedDateController.value,
                                onPress: () {},
                              ),
                              Container(
                                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                                  child: SfDateRangePicker(
                                    allowViewNavigation: true,
                                    headerStyle: const DateRangePickerHeaderStyle(
                                        textStyle: TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.bold, fontSize: 18)),
                                    selectionMode: DateRangePickerSelectionMode.single,
                                    view: DateRangePickerView.month,
                                    monthCellStyle: const DateRangePickerMonthCellStyle(textStyle: TextStyle(fontFamily: AppThemData.regular)),
                                    selectionColor: AppColors.yellow04,
                                    selectionTextStyle: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.semiBold),
                                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                                      controller.selectedDateTime.value = dateRangePickerSelectionChangedArgs.value;
                                      controller.selectedDateController.value.text = DateFormat('dd MMMM yyyy').format(controller.selectedDateTime.value);
                                      log(controller.selectedDateTime.value.toString());
                                    },
                                    showNavigationArrow: true,
                                    minDate: DateTime.now(),
                                    initialSelectedDate: DateTime.now(),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Select Duration".tr,
                                style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06),
                              ),
                              Obx(
                                () => Slider(
                                  value: controller.selectedDuration.value,
                                  onChanged: (value) {
                                    controller.selectedDuration.value = value;
                                    controller.startTimeController.value.text = DateFormat('HH:mm').format(controller.startTime.value);
                                    Duration duration = Duration(hours: controller.selectedDuration.value.toInt());
                                    controller.endTime.value = controller.startTime.value.add(duration);
                                    controller.endTimeController.value.text = DateFormat('HH:mm').format(controller.endTime.value);
                                  },
                                  autofocus: false,
                                  activeColor: AppColors.yellow04,
                                  inactiveColor: AppColors.lightGrey05,
                                  min: 0,
                                  max: 24,
                                  divisions: 24,
                                  label: "${controller.selectedDuration.value.round().toString()} hours".tr,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFieldWidgetSuffix(
                                      readOnly: true,
                                      title: "Start Time".tr,
                                      onPress: () async {
                                        TimeOfDay? startTime = await Constant.selectTime(context);

                                        if (startTime != null) {
                                          controller.startTime.value = DateTime(controller.selectedDateTime.value.year, controller.selectedDateTime.value.month,
                                              controller.selectedDateTime.value.day, startTime.hour, startTime.minute);

                                          controller.startTimeController.value.text = DateFormat('HH:mm').format(controller.startTime.value);
                                          Duration duration = Duration(hours: controller.selectedDuration.value.toInt());
                                          controller.endTime.value = controller.startTime.value.add(duration);
                                          controller.endTimeController.value.text = DateFormat('HH:mm').format(controller.endTime.value);
                                        }
                                      },
                                      controller: controller.startTimeController.value,
                                      textInputType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                      hintText: 'Select Time'.tr,
                                      enable: true,
                                      suffix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_clock.svg",
                                          color: AppColors.lightGrey10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFieldWidgetSuffix(
                                      title: "End Time".tr,
                                      onPress: () async {
                                        if (controller.startTimeController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please select start time first".tr);
                                          return;
                                        }
                                        TimeOfDay? startTime = await Constant.selectTime(context);

                                        if (startTime != null) {
                                          controller.endTime.value = DateTime(controller.selectedDateTime.value.year, controller.selectedDateTime.value.month,
                                              controller.selectedDateTime.value.day, startTime.hour, startTime.minute);

                                          controller.endTimeController.value.text = DateFormat('HH:mm').format(controller.endTime.value);
                                          Duration duration = Duration(hours: controller.selectedDuration.value.toInt());
                                          controller.startTime.value = controller.endTime.value.subtract(duration);
                                          controller.startTimeController.value.text = DateFormat('HH:mm').format(controller.startTime.value);
                                        }
                                      },
                                      controller: controller.endTimeController.value,
                                      textInputType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                      hintText: 'Select Time'.tr,
                                      enable: true,
                                      readOnly: true,
                                      suffix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_clock.svg",
                                          color: AppColors.lightGrey10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Text("Select season pass", style: TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06)),
                              const SizedBox(
                                height: 5,
                              ),
                              if (controller.mySeasonPassList.isEmpty)
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.SEASON_PASS);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(30)),
                                    child: const Text(
                                      "Please purchase season pass",
                                      style: TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey05),
                                    ),
                                  ),
                                )
                              else
                                DropdownButtonFormField<MyPurchasePassModel>(
                                    isExpanded: false,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.lightGrey10,
                                      size: 30,
                                    ),
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(color: Colors.red),
                                      filled: true,
                                      fillColor: AppColors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                      disabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                                      ),
                                      hintStyle: const TextStyle(fontFamily: AppThemData.regular),
                                    ),
                                    // value: controller.selectedSeasonPass.value,
                                    onChanged: (value) {
                                      controller.selectedSeasonPass.value = value!;
                                      controller.plateNumberController.value.text = controller.selectedSeasonPass.value.vehicleNo.toString();
                                    },
                                    style: const TextStyle(color: AppColors.darkGrey10),
                                    hint: Text(
                                      "Select Pass Type".tr,
                                      style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey05),
                                    ),
                                    items: controller.mySeasonPassList.map((item) {
                                      return DropdownMenuItem<MyPurchasePassModel>(
                                        value: item,
                                        child: Text(item.seasonPassModel!.passName.toString(),
                                            style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10)),
                                      );
                                    }).toList()),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidgetSuffix(
                                suffix: InkWell(
                                  onTap: () {
                                    controller.getLicensePlate();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(16),
                                  ),
                                ),
                                enable: false,
                                title: "Vehicle Number".tr,
                                hintText: "Enter Vehicle Number GJ 05 FG 6251".tr,
                                controller: controller.plateNumberController.value,
                                onPress: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
            bottomNavigationBar: (controller.isLoadingNumber.value)
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: ButtonThem.buildButton(
                      txtSize: 16,
                      context,
                      title:
                          "${"Continue".tr} ${controller.selectedDuration.value == 0 ? "" : "(${controller.selectedDuration.value.toStringAsFixed(0)} ${"Hours".tr})"}",
                      txtColor: AppColors.lightGrey01,
                      bgColor: AppColors.darkGrey10,
                      onPress: () {
                        controller.startTime.value = DateTime(controller.selectedDateTime.value.year, controller.selectedDateTime.value.month,
                            controller.selectedDateTime.value.day, controller.startTime.value.hour, controller.startTime.value.minute);

                        Duration duration = Duration(hours: controller.selectedDuration.value.toInt());
                        controller.endTime.value = controller.startTime.value.add(duration);

                        if (controller.startTimeController.value.text.isEmpty || controller.endTimeController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Select Time".tr);
                          return;
                        }

                        if (controller.plateNumberController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter Vehicle Number".tr);
                          return;
                        }

                        BookingModel bookingModel = BookingModel();
                        bookingModel.parkingDetails = controller.parkingModel.value;
                        bookingModel.duration = controller.selectedDuration.value.toStringAsFixed(0);
                        bookingModel.bookingDate = Timestamp.fromDate(controller.selectedDateTime.value);
                        bookingModel.bookingStartTime = Timestamp.fromDate(controller.startTime.value);
                        bookingModel.bookingEndTime = Timestamp.fromDate(controller.endTime.value);
                        bookingModel.status = Constant.placed;
                        bookingModel.customerId = FireStoreUtils.getCurrentUid();
                        bookingModel.id = Constant.getUuid();
                        bookingModel.parkingId = controller.parkingModel.value.id;
                        bookingModel.subTotal = controller.calculateParkingAmount().toString();
                        bookingModel.taxList = Constant.taxList;
                        bookingModel.numberPlate = controller.plateNumberController.value.text;
                        bookingModel.myPurchasePassModel = controller.selectedSeasonPass.value;

                        Get.toNamed(Routes.BOOKING_DETAIL_SCREEN, arguments: {"bookingModel": bookingModel});
                      },
                    ),
                  ),
          );
        });
  }
}
