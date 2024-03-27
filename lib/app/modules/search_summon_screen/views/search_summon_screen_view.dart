import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../../../../constant/constant.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/button_theme.dart';
import '../../../../themes/common_ui.dart';
import '../../../models/compound_model.dart';
import '../../../models/wallet_transaction_model.dart';
import '../../../routes/app_pages.dart';

class SearchSummonScreenView extends StatefulWidget {
  const SearchSummonScreenView({Key? key}) : super(key: key);

  @override
  State<SearchSummonScreenView> createState() => _SearchSummonScreenViewState();
}

class _SearchSummonScreenViewState extends State<SearchSummonScreenView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SearchSummonScreenController>(
        init: SearchSummonScreenController(),
    builder: (controller) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
        appBar: UiInterface().customAppBar(backgroundColor: AppColors.lightGrey02, context, "Search & Pay Compound".tr, isBack: false,
          // actions: [
          //   Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: InkWell(
          //       onTap: () {
          //         Get.toNamed(Routes.QRCODE_SCREEN);
          //       },
          //       child: Container(
          //         height: 40,
          //         width: 100,
          //         decoration: BoxDecoration(color: AppColors.yellow04, borderRadius: BorderRadius.circular(20)),
          //         child: Center(
          //           child: Text(
          //             "Scanner".tr,
          //             style: TextStyle(
          //               fontSize: 13,
          //               fontFamily: AppThemData.bold,
          //               color: AppColors.darkGrey08,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   )
          // ],
          ),
          body: Column(
              children: [ Text(
                'Search with'.tr,
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppThemData.medium,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                ),
                Padding(
                padding: EdgeInsets.fromLTRB(20,10,20,10), //apply padding to all four sides
                  child:SlidingSwitch(
                      value: false,
                      width: 350,
                      onChanged: (bool value) {
                        print(value);
                      },
                      height: 40,
                      animationDuration: const Duration(milliseconds: 400),
                      onTap: () {},
                      onDoubleTap: () {},
                      onSwipe: () {},
                      textOff: "Compound No.".tr,
                      textOn: "Plate No.".tr,
                      colorOn: Colors.black,
                      colorOff: Colors.black,
                      background: Colors.amber,
                      buttonColor: const Color(0xfff7f5f7),
                      inactiveColor: const Color(0xff636f7b),
                    ),
                ),
                Padding(
                    padding: EdgeInsets.all(20), //apply padding to all four sides
                    child:SearchBar(leading: const Icon(Icons.search),
                      side: MaterialStateProperty.all(const BorderSide(color: Colors.grey)),
                      hintText: 'Enter number'.tr,
                      shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),)
                ),
                ButtonThem.buildButton(
                  btnHeight: 56,
                  txtSize: 16,
                  context,
                  title: "Search".tr,
                  txtColor: AppColors.lightGrey01,
                  bgColor: AppColors.darkGrey10,
                  onPress: () {
                    // if (controller.formKey.value.currentState!.validate()) {
                    //   controller.sendCode();
                    // }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ButtonThem.buildButton(
                  btnHeight: 56,
                  txtSize: 16,
                  context,
                  title: "Scan a Barcode".tr,
                  txtColor: Colors.black,
                  bgColor: AppColors.yellow04,
                  onPress: () {
                    // if (controller.formKey.value.currentState!.validate()) {
                    //   controller.sendCode();
                    // }
                    Get.toNamed(Routes.QRCODE_SCREEN);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: controller.compoundList.isEmpty
                      ? Constant.showEmptyView(
                      message: "Compound not found".tr)
                      : ListView.builder(
                    itemCount: controller.compoundList.length,
                    itemBuilder: (context, index) {
                      CompoundModel compoundModel =
                      controller.compoundList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //       borderRadius:
                                //       BorderRadius.circular(
                                //           50),
                                //       border: Border.all(
                                //           color: AppColors
                                //               .darkGrey01)),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(
                                //         12.0),
                                //     child: SvgPicture.asset(
                                //       "assets/icons/ic_receipt.svg",
                                //       color: (compoundModel
                                //           .isCredit!)
                                //           ? AppColors.green04
                                //           : AppColors.red04,
                                //       width: 35,
                                //     ),
                                //   ),
                                // ),
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
                                                compoundModel
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
                                                  amount: compoundModel
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
                                                    compoundModel
                                                        .createdDate!),
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .darkGrey03,
                                                    fontFamily:
                                                    AppThemData
                                                        .medium,
                                                    fontSize: 16),
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
                                                    compoundModel
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
                                              Constant.timestampToDate(
                                                  compoundModel
                                                      .createdDate!),
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black,
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
                ]
              )
        );
      }
    );
  }
}



