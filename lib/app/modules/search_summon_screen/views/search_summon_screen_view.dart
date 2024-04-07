import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
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
  final SearchSummonScreenController controller;
  const SearchSummonScreenView({Key? key, required this.controller})
      : super(key: key);

  @override
  State<SearchSummonScreenView> createState() => _SearchSummonScreenViewState();
}

class _SearchSummonScreenViewState extends State<SearchSummonScreenView> {
  late TextEditingController _searchController;
  late String _hintText;
  String _requestMethod = 'compound'; // Default request method

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _hintText = 'Enter compound number'.tr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: UiInterface().customAppBar(
        backgroundColor: AppColors.lightGrey02,
        context,
        "Search & Pay Compound".tr,
        isBack: false,
      ),
      body: Column(
        children: [
          Text(
            'Search with'.tr,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: AppThemData.medium,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SlidingSwitch(
              value: _requestMethod == 'compound' ? false : true,
              width: 350,
              onChanged: (bool value) {
                setState(() {
                  _requestMethod = value ? 'car' : 'compound';
                  _hintText = value
                      ? 'Enter Plate number'.tr
                      : 'Enter compound number'.tr;
                });
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
            padding: const EdgeInsets.all(20),
            child: SearchBar(
              controller: _searchController,
              leading: const Icon(Icons.search),
              side: MaterialStateProperty.all(
                const BorderSide(color: Colors.grey),
              ),
              hintText: _hintText,
              shape: MaterialStateProperty.all(
                const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          ButtonThem.buildButton(
            btnHeight: 56,
            txtSize: 16,
            context,
            title: "Search".tr,
            txtColor: AppColors.lightGrey01,
            bgColor: AppColors.darkGrey10,
            onPress: () async {
              String searchText = _searchController.text;

              try {
                Map<String, dynamic> searchResult =
                    await SearchSummonScreenController().searchCompound(
                  id: 'vendor_mptemerloh',
                  pass:
                      'M=Lu5k%r8uw!6yBq^T924bdjE_piB3DU2^d9eB39^7u9^GdAKe_IG5KbK&V2vt5=KpxkB',
                  requestMethod: _requestMethod,
                  compoundNum: _requestMethod == 'compound' ? searchText : '',
                  carNum: _requestMethod == 'car' ? searchText : '',
                );

                // Handle the search result here
                print(searchResult);

                // Show a toast message based on the msg field in the response
                if (searchResult['msg'] != null) {
                  ShowToastDialog.showToast(
                    searchResult['msg'],
                  );
                }
              } catch (e) {
                // Handle any errors that occur during the search
                print('Error searching: $e');
              }
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
              Get.toNamed(Routes.QRCODE_SCREEN);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: SearchSummonScreenController().compoundList.isEmpty
                ? Constant.showEmptyView(message: "Compound not found".tr)
                : ListView.builder(
                    itemCount:
                        SearchSummonScreenController().compoundList.length,
                    itemBuilder: (context, index) {
                      CompoundModel compoundModel =
                          SearchSummonScreenController().compoundList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //       borderRadius:
                                //           BorderRadius.circular(
                                //               50),
                                //       border: Border.all(
                                //           color: AppColors
                                //               .darkGrey01)),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(
                                //         12.0),
                                //     child: SvgPicture.asset(
                                //       "assets/icons/ic_receipt.svg",
                                //       color: (compoundModel
                                //               .isCredit!)
                                //           ? AppColors.green04
                                //           : AppColors.red04,
                                //       width: 35,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                compoundModel.compoundNo
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: AppColors.darkGrey07,
                                                    fontFamily:
                                                        AppThemData.medium,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Text(
                                              Constant.amountShow(
                                                  amount: compoundModel.amount
                                                      .toString()),
                                              style: const TextStyle(
                                                  color: AppColors.darkGrey07,
                                                  fontFamily:
                                                      AppThemData.medium,
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
                                                    compoundModel.dateTime!),
                                                style: const TextStyle(
                                                    color: AppColors.darkGrey03,
                                                    fontFamily:
                                                        AppThemData.medium,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Text(
                                              'Success'.tr,
                                              style: const TextStyle(
                                                  color: AppColors.green04,
                                                  fontFamily:
                                                      AppThemData.medium,
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
                                                    compoundModel.dateTime!),
                                                style: const TextStyle(
                                                    color: AppColors.darkGrey03,
                                                    fontFamily:
                                                        AppThemData.medium,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Text(
                                              Constant.timestampToDate(
                                                  compoundModel.dateTime!),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily:
                                                      AppThemData.medium,
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
    );
  }
}
