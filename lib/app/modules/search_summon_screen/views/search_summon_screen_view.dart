// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:customer_app/app/modules/qrcode_screen/controllers/qrcode_screen_controller.dart';
import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../../../../constant/constant.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/button_theme.dart';
import '../../../../themes/common_ui.dart';
import '../../../models/compound_model.dart';
import '../../../routes/app_pages.dart';

class SearchSummonScreenView extends StatefulWidget {
  final SearchSummonScreenController controller;
  // ignore: use_super_parameters
  const SearchSummonScreenView({Key? key, required this.controller})
      : super(key: key);

  @override
  State<SearchSummonScreenView> createState() => _SearchSummonScreenViewState();
}

class _SearchSummonScreenViewState extends State<SearchSummonScreenView> {
  late TextEditingController _searchController;

  late String _hintText;
  String _requestMethod = 'compound';
  bool _isPageLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _hintText = 'Enter compound number'.tr;
    _loadCompoundNumber();
    final args = Get.arguments;
    if (args != null && args['compoundNumber'] != null) {
      final compoundNumber = args['compoundNumber'];
      _searchController.text = compoundNumber;
      // Call the search method with the compoundNumber
      widget.controller.handleCompoundNumber(compoundNumber);

      bool paymentCompleted = Get.arguments?['paymentCompleted'] ?? false;

      // If paymentCompleted is true, refresh the data
      if (paymentCompleted) {
        widget.controller.searchCompounds(
          requestMethod: _requestMethod, // Adjust as per your logic
          searchText: '', // Pass relevant search text if needed
        );
      }
    }
  }

  _loadCompoundNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? compoundNumber = prefs.getString('compoundNumber');
    if (compoundNumber != null) {
      // Do something with compoundNumber
      print('Compound Number: $compoundNumber');
    }
  }

  @override
  void dispose() {
    // Clear the compound list when the page is disposed
    widget.controller.clearCompoundList();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SearchSummonScreenController>(
        init: SearchSummonScreenController(),
        builder: (controller) {
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
                    width: 340,
                    onChanged: (bool value) {
                      setState(() {
                        _requestMethod = value ? 'car' : 'compound';
                        _hintText = value
                            ? 'Enter Plate number'.tr
                            : 'Enter compound number'.tr;
                        _searchController.clear();
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
                    textCapitalization: TextCapitalization.characters,
                    controller: _searchController,
                    leading: const Icon(Icons.search),
                    side: WidgetStateProperty.all(
                      const BorderSide(color: Colors.grey),
                    ),
                    hintText: _hintText,
                    shape: WidgetStateProperty.all(
                      const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonThem.buildButton(
                      btnHeight: 40,
                      btnWidthRatio: 0.43,
                      // _requestMethod == 'compound' ? 0.43 : 0.9,
                      txtSize: 14,
                      context,
                      title: _isPageLoading ? "Loading...".tr : "Search".tr,
                      txtColor: AppColors.lightGrey01,
                      bgColor: AppColors.darkGrey10,
                      onPress: _isPageLoading
                          ? () {} // Provide a no-op function when loading
                          : () {
                              _handleSearch(); // Call the actual search function
                            },
                    ),
                    if (_requestMethod == 'compound')
                      const SizedBox(
                        width: 10,
                      ),
                    if (_requestMethod == 'compound')
                      ButtonThem.buildButton(
                        btnHeight: 40,
                        btnWidthRatio: 0.43,
                        txtSize: 14,
                        context,
                        title: "Scan a Barcode".tr,
                        txtColor: AppColors.lightGrey01,
                        bgColor: AppColors.darkGrey10,
                        onPress: () async {
                          final result = await Get.toNamed(
                            Routes.QRCODE_SCREEN,
                            arguments: {
                              'controller': QRCodeScanController(),
                              'searchController': _searchController,
                            },
                          );
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            // Check if the result contains the compound number
                            if (result.containsKey('compoundNumber')) {
                              // Set the compound number in the search bar
                              _searchController.text = result['compoundNumber'];
                              // Trigger the API request automatically
                              await _triggerApiRequest();
                            }
                          }
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: widget.controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.darkGrey10,
                            ),
                          ),
                        ) // Show loading indicator
                      : ListView.builder(
                          itemCount: widget.controller.compoundList.length,
                          itemBuilder: (controller, index) {
                            // print('Building item at index: $index');
                            CompoundModel compoundModel =
                                widget.controller.compoundList[index];
                            List<String> imageUrls =
                                compoundModel.imageUrl!.split(";");
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors
                                      .lightGrey06, // Specify the border color
                                  width: 3.0, // Specify the border width
                                ),
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ), // Specify the border radius
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        Text(
                                          compoundModel.compoundNo.toString(),
                                          style: const TextStyle(
                                            color: AppColors.darkGrey07,
                                            fontFamily: AppThemData.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          Constant.amountShow(
                                            amount: (compoundModel.amount !=
                                                        null &&
                                                    double.tryParse(
                                                            compoundModel
                                                                .amount!) !=
                                                        null)
                                                ? compoundModel.amount
                                                    .toString()
                                                : '0.00', // Use a default value if invalid
                                          ),
                                          style: const TextStyle(
                                            color: AppColors.darkGrey07,
                                            fontFamily: AppThemData.medium,
                                            fontSize: 14,
                                          ),
                                        ),

                                        const SizedBox(height: 3),
                                        Text(
                                          compoundModel.vehicleNum ?? '',
                                          style: const TextStyle(
                                            color: AppColors.darkGrey07,
                                            fontFamily: AppThemData.medium,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          compoundModel.dateTime!,
                                          style: const TextStyle(
                                            color: AppColors.darkGrey03,
                                            fontFamily: AppThemData.medium,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        // Text(
                                        //   compoundModel.status
                                        //       .toString(),
                                        //   style: TextStyle(
                                        //     color: compoundModel
                                        //                 .status ==
                                        //             'unpaid'
                                        //         ? Colors.red
                                        //         : AppColors.green04,
                                        //     fontFamily:
                                        //         AppThemData.medium,
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 3),
                                        Text(
                                          // Safely handle the substring to prevent RangeError
                                          '${compoundModel.offence != null && compoundModel.offence!.isNotEmpty ? compoundModel.offence!.length > 30 ? compoundModel.offence!.substring(0, 30) : compoundModel.offence : ''}\n'
                                          '${compoundModel.offence != null && compoundModel.offence!.length > 51 ? compoundModel.offence!.substring(30, 51) : ''}',
                                          style: const TextStyle(
                                            color: AppColors.darkGrey03,
                                            fontFamily: AppThemData.medium,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // This property will handle overflow text
                                          maxLines:
                                              2, // Set the maximum number of lines
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Only show the image gallery icon if not in the process of making payment
                                        widget.controller.isMakingPayment
                                            ? Container()
                                            : InkWell(
                                                onTap: () async {
                                                  bool isLogin =
                                                      await FireStoreUtils
                                                          .isLogin();
                                                  if (!isLogin) {
                                                    // If the user is not logged in, show the login dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return DialogBox(
                                                          imageAsset:
                                                              "assets/images/ic_log_in.png",
                                                          onPressConfirm:
                                                              () async {
                                                            // Navigate to the login screen
                                                            Get.offAllNamed(Routes
                                                                .LOGIN_SCREEN);
                                                          },
                                                          onPressConfirmBtnName:
                                                              "Login".tr,
                                                          onPressConfirmColor:
                                                              AppColors.green04,
                                                          onPressCancel: () {
                                                            Get.back();
                                                          },
                                                          content:
                                                              "Please login or register before proceeding."
                                                                  .tr,
                                                          subTitle:
                                                              "Login Required"
                                                                  .tr,
                                                          onPressCancelBtnName:
                                                              "Cancel".tr,
                                                          onPressCancelColor:
                                                              AppColors
                                                                  .darkGrey01,
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    bool emailVerified =
                                                        await widget.controller
                                                            .isEmailVerified();
                                                    if (emailVerified) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            child: SizedBox(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 215,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: GridView
                                                                    .builder(
                                                                  gridDelegate:
                                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        3,
                                                                    crossAxisSpacing:
                                                                        4.0,
                                                                    mainAxisSpacing:
                                                                        4.0,
                                                                  ),
                                                                  itemCount:
                                                                      imageUrls
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showImageFullScreen(
                                                                            imageUrls[index]);
                                                                      },
                                                                      child: Image
                                                                          .network(
                                                                        imageUrls[
                                                                            index],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      showVerifyEmailDialog();
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 45.0,
                                                    horizontal: 5.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color: Colors.amber,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Image.asset(
                                                    "assets/images/image-gallery.png",
                                                    width: 30,
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(width: 2),
                                        InkWell(
                                          onTap: () async {
                                            // Check if the user is logged in
                                            bool isLogin =
                                                await FireStoreUtils.isLogin();

                                            if (!isLogin) {
                                              // If the user is not logged in, show the login dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogBox(
                                                    imageAsset:
                                                        "assets/images/ic_log_in.png",
                                                    onPressConfirm: () async {
                                                      // Navigate to the login screen
                                                      Get.offAllNamed(
                                                          Routes.LOGIN_SCREEN);
                                                    },
                                                    onPressConfirmBtnName:
                                                        "Login".tr,
                                                    onPressConfirmColor:
                                                        AppColors.green04,
                                                    onPressCancel: () {
                                                      Get.back();
                                                    },
                                                    content:
                                                        "Please login or register before proceeding."
                                                            .tr,
                                                    subTitle:
                                                        "Login Required".tr,
                                                    onPressCancelBtnName:
                                                        "Cancel".tr,
                                                    onPressCancelColor:
                                                        AppColors.darkGrey01,
                                                  );
                                                },
                                              );
                                            } else {
                                              // If the user is logged in, check email verification
                                              bool emailVerified = await widget
                                                  .controller
                                                  .isEmailVerified();
                                              if (emailVerified) {
                                                // Navigate to pay compound if email is verified
                                                navigateToPayCompound(
                                                    compoundModel);
                                              } else {
                                                // Show the email verification dialog
                                                showVerifyEmailDialog();
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 45.0,
                                              horizontal: 5.0,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Image.asset(
                                              "assets/images/money.png",
                                              width: 30,
                                              height: 28,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _handleSearch() async {
    setState(() {
      _isPageLoading = true; // Start loading
    });

    String searchText = _searchController.text;
    widget.controller.setLoading(true);

    try {
      // Perform the search operation
      Map<String, dynamic> searchResult =
          await SearchSummonScreenController().searchCompound(
        id: 'vendor_mptemerloh',
        pass:
            'M=Lu5k%r8uw!6yBq^T924bdjE_piB3DU2^d9eB39^7u9^GdAKe_IG5KbK&V2vt5=KpxkB',
        requestMethod: _requestMethod,
        compoundNum: _requestMethod == 'compound' ? searchText : '',
        carNum: _requestMethod == 'car' ? searchText : '',
      );

      // Parse and update the compound list
      List<CompoundModel> compounds = _parseSearchResult(searchResult);
      widget.controller.updateCompoundList(compounds);

      // Show a toast message if available
      if (searchResult.containsKey('msg') &&
          searchResult['msg'] != null &&
          searchResult['msg'].isNotEmpty) {
        ShowToastDialog.showToast(searchResult['msg']);
      }

      // If no compounds are found, show a Snackbar
      if (compounds.isEmpty) {
        _noCompoundSnackBar("No compound is found.".tr);
      }
    } catch (e) {
      print('Error searching: $e');
    } finally {
      setState(() {
        _isPageLoading = false; // Stop loading
      });
      widget.controller.setLoading(false);
    }
  }

  List<CompoundModel> _parseSearchResult(Map<String, dynamic> searchResult) {
    List<CompoundModel> compounds = [];

    // Helper function to decode base64 strings
    String convertBase64ToUrl(String base64Strings) {
      final String decodedUrl = utf8.decode(base64.decode(base64Strings));
      return decodedUrl;
    }

    // Extract data from the search result
    List<String> compoundNums = searchResult['compound_num'] != null &&
            searchResult['compound_num'] is String
        ? searchResult['compound_num'].split("::")
        : [];
    List<String> amounts =
        searchResult['amount'] != null && searchResult['amount'] is String
            ? searchResult['amount'].split("::")
            : [searchResult['amount'].toString()];
    List<String> dateTimes =
        searchResult['datetime'] != null && searchResult['datetime'] is String
            ? searchResult['datetime'].split("::")
            : [];
    List<String> statuses =
        searchResult['status'] != null && searchResult['status'] is String
            ? searchResult['status'].split("::")
            : [];
    List<String> offences =
        searchResult['offence'] != null && searchResult['offence'] is String
            ? searchResult['offence'].split("::")
            : [];
    List<String> kodHasils =
        searchResult['kod_hasil'] != null && searchResult['kod_hasil'] is String
            ? searchResult['kod_hasil'].split("::")
            : [];
    List<String> vehicleNums = searchResult['vehicle_num'] != null &&
            searchResult['vehicle_num'] is String
        ? searchResult['vehicle_num'].split("::")
        : [];
    List<String> imageUrls = searchResult['allCompoundImage'] != null &&
            searchResult['allCompoundImage'] is String
        ? convertBase64ToUrl(searchResult['allCompoundImage']).split("::")
        : [];

    // Create `CompoundModel` objects and add them to the list
    for (int i = 0; i < compoundNums.length; i++) {
      CompoundModel compound = CompoundModel(
        compoundNo: compoundNums.isNotEmpty ? compoundNums[i] : '',
        amount: amounts.isNotEmpty ? amounts[i] : '',
        dateTime: dateTimes.isNotEmpty
            ? dateTimes[i] // Assign the string directly
            : DateTime.now()
                .toIso8601String(), // Provide a default value in ISO 8601 format
        status: statuses.isNotEmpty ? statuses[i] : '',
        offence: offences.isNotEmpty ? offences[i] : '',
        kodHasil: kodHasils.isNotEmpty ? kodHasils[i] : '',
        vehicleNum: vehicleNums.isNotEmpty ? vehicleNums[i] : '',
        imageUrl: imageUrls.isNotEmpty ? imageUrls[i] : '',
      );
      compounds.add(compound);
    }

    return compounds;
  }

  void navigateToPayCompound(CompoundModel compoundModel) {
    CompoundModel payCompoundModel = CompoundModel(
      compoundNo: compoundModel.compoundNo,
      amount: compoundModel.amount,
      dateTime: compoundModel.dateTime,
      status: compoundModel.status,
      offence: compoundModel.offence,
      kodHasil: compoundModel.kodHasil,
      vehicleNum: compoundModel.vehicleNum,
    );

    Get.toNamed(Routes.PAY_COMPOUND, arguments: {
      "payCompoundModel": payCompoundModel.toJson(),
      "myPaymentCompoundModel": widget.controller.myPaymentCompoundModel.value
    });
  }

  void showImageFullScreen(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Dismiss the dialog when tapped
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _triggerApiRequest() async {
    String searchText = _searchController.text;
    // Set loading state to true immediately after clicking search
    widget.controller.setLoading(true);

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
      String convertBase64ToUrl(String base64Strings) {
        final String decodedUrl = utf8.decode(base64.decode(base64Strings));

        return decodedUrl;
      }

      // Parse the JSON response into a list of CompoundModel objects
      List<CompoundModel> compounds = [];
      List<String> compoundNums = searchResult['compound_num'] != null
          ? searchResult['compound_num'].split("::")
          : [];
      List<String> amounts = searchResult['amount'] != null
          ? searchResult['amount'].split("::")
          : [];
      List<String> dateTimes = searchResult['datetime'] != null
          ? searchResult['datetime'].split("::")
          : [];
      List<String> statuses = searchResult['status'] != null
          ? searchResult['status'].split("::")
          : [];
      List<String> offences = searchResult['offence'] != null
          ? searchResult['offence'].split("::")
          : [];
      List<String> kodHasils = searchResult['kod_hasil'] != null
          ? searchResult['kod_hasil'].split("::")
          : [];
      List<String> vehicleNums = searchResult['vehicle_num'] != null
          ? searchResult['vehicle_num'].split("::")
          : [];

      List<String> imageUrls = searchResult['allCompoundImage'] != null
          ? convertBase64ToUrl(searchResult['allCompoundImage']).split("::")
          : [];
      for (int i = 0; i < compoundNums.length; i++) {
        CompoundModel compound = CompoundModel(
          compoundNo: compoundNums[i],
          amount: amounts.isNotEmpty ? amounts[i] : '',
          dateTime: dateTimes.isNotEmpty
              ? dateTimes[i] // Assign the string directly
              : DateTime.now()
                  .toIso8601String(), // Provide a default value in ISO 8601 format
          status: statuses.isNotEmpty ? statuses[i] : '',
          offence: offences.isNotEmpty ? offences[i] : '',
          kodHasil: kodHasils.isNotEmpty ? kodHasils[i] : '',
          vehicleNum: vehicleNums.isNotEmpty ? vehicleNums[i] : '',
          imageUrl: imageUrls.isNotEmpty ? imageUrls[i] : '',
        );
        compounds.add(compound);
      }

      // Update the compoundList in the controller
      widget.controller.updateCompoundList(compounds);

      // Rebuild the widget tree to reflect the changes
      setState(() {});

      // Show a toast message based on the msg field in the response
      if (searchResult.containsKey('msg') &&
          searchResult['msg'] != null &&
          searchResult['msg'].isNotEmpty) {
        ShowToastDialog.showToast(
          searchResult['msg'],
        );
      }

      // If no compound is found, show a Snackbar
      if (compounds.isEmpty) {
        _noCompoundSnackBar("No compound is found.".tr);
      }
    } on SocketException catch (e) {
      // Handle connection problem
      _noConnectionSnackBar("Connection problem. Please try again.".tr);
    }
    // Set loading state back to false after search completes
    widget.controller.setLoading(false);
  }

  void _noCompoundSnackBar(String message) {
    Get.snackbar(
      "No Compound".tr,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16.0),
      borderRadius: 10.0,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  void _noConnectionSnackBar(String message) {
    Get.snackbar(
      "No Connection".tr,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16.0),
      borderRadius: 10.0,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  void showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogBoxNotify(
          imageAsset: "assets/images/ic_email.png",
          onPressConfirm: () async {
            Navigator.of(context).pop();
          },
          onPressConfirmBtnName: "Ok".tr,
          onPressConfirmColor: AppColors.yellow04,
          content: "Please verify your email before proceeding.".tr,
          subTitle: "Email Verification".tr,
        );
      },
    );
  }
}
