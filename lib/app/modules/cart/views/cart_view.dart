// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/cart_model.dart';
import 'package:customer_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late CartController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CartController());
    // Fetch or refresh the cart items when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshCartItems();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh the cart items when the view comes back into focus
    Get.find<CartController>().refreshCartItems();
  }

  Widget _buildCartItem(
    BuildContext context, {
    CartModel? cartItem,
    String? passType,
    String? vehiclePlate,
    String? passPrice,
    String? validity,
    DateTime? startDate,
    DateTime? endDate,
    String? compoundNo,
    String? kodHasil,
    String? lotNo,
    String? dateTime,
  }) {
    // Determine pass type color and icon
    Color cardColor;
    String svgIconPath;

    if (passType == "Season Pass".tr) {
      cardColor = AppColors.yellow04.withOpacity(0.1);
      svgIconPath = 'assets/icons/ic_pass.svg';
    } else if (passType == "Reserve Lot".tr) {
      cardColor = AppColors.yellow04.withOpacity(0.1);
      svgIconPath = 'assets/icons/ic_pass.svg';
    } else if (passType == "Compound".tr) {
      cardColor = AppColors.yellow04.withOpacity(0.1);
      svgIconPath = 'assets/icons/ic_pass.svg';
    } else {
      cardColor = AppColors.darkGrey04.withOpacity(0.1);
      svgIconPath = 'assets/icons/ic_close.svg';
    }

    return Obx(() {
      bool isSelected = controller.selectedCartItems.contains(cartItem);

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main widget containing the Row elements
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value == true) {
                              controller.addToSelectedCartItems(cartItem!);
                            } else {
                              controller.removeFromSelectedCartItems(cartItem!);
                            }
                          },
                          checkColor: Colors.white, // Checkbox tick color
                          activeColor:
                              Colors.blueAccent, // Checkbox color when selected
                          fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors
                                  .blueAccent; // Background color when selected
                            }
                            return Colors
                                .white; // Background color when not selected
                          }),
                        ),
                        SvgPicture.asset(
                          svgIconPath,
                          color: AppColors.primaryBlack,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            passType!,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.primaryBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.red04,
                          ),
                          onPressed: () async {
                            await controller.deleteCartItem(cartItem!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 8.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_wallet.svg',
                          color: AppColors.primaryBlack,
                          width: 19,
                          height: 19,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          "Amount:".tr,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.darkGrey09,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "RM ${passPrice ?? '0.0'}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.darkGrey09,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                // Conditionally render Vehicle Plate or Lot No based on passType

                if (passType != "Reserve Lot".tr) ...[
                  // Vehicle Plate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_carsimple.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Plate Number:".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        vehiclePlate ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ] else ...[
                  // Lot No (for Reserved Lot)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_hash.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Lot No:".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        lotNo ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],

                // Conditional Rendering: Compound fields vs Season Pass/Reserved Lot fields
                if (passType == "Compound".tr) ...[
                  // Compound No
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/validity.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "${"Compound No.".tr}:",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        compoundNo ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Kod Hasil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/validity.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Kod Hasil:".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        kodHasil ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // DateTime
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_timer.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Date:".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        dateTime ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Validity (Season Pass/Reserved Lot)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/validity.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Validity:".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        validity!.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Start Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_timer.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Start Date:".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        startDate != null
                            ? startDate.toShortDateString()
                            : 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // End Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_timer.svg',
                            color: AppColors.primaryBlack,
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "End Date:".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGrey09,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        endDate != null ? endDate.toShortDateString() : 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.darkGrey09,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),

            const SizedBox(height: 8.0),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryWhite,
        appBar: AppBar(
          backgroundColor: AppColors.primaryWhite,
          elevation: 0,
          title: Text(
            'Cart'.tr,
            style: const TextStyle(color: AppColors.darkGrey07),
          ),
          leading: IconButton(
            color: AppColors.darkGrey07,
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              Get.back();
            },
          ),
          actions: [
            Obx(() {
              // Check if all items are selected
              bool allSelected = controller.selectedCartItems.length ==
                      controller.cartItemList.length &&
                  controller.cartItemList.isNotEmpty;

              // Show delete icon only if all are selected
              bool showDeleteIcon = allSelected;

              // Determine the text to display based on the selection state
              String buttonText =
                  allSelected ? 'Remove All'.tr : 'Select All'.tr;

              return Row(
                children: [
                  TextButton(
                    onPressed: () {
                      if (controller.cartItemList.isNotEmpty) {
                        if (allSelected) {
                          // Deselect all items
                          controller.clearSelectedCartItems();
                        } else {
                          // Select all items
                          controller.selectAllCartItems();
                        }
                      }
                    },
                    child: Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: allSelected ? Colors.red : AppColors.darkGrey10,
                      ),
                    ),
                  ),
                  // Show delete icon if all items are selected
                  if (showDeleteIcon)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                    ),
                ],
              );
            }),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                ),
                padding: const EdgeInsets.all(20),
                width: 60,
                height: 60,
                child: const CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            );
          } else if (controller.cartItemList.isEmpty) {
            return Center(
              child: Text(
                'No items in your cart.'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.primaryBlack,
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(14.0),
              itemCount: controller.cartItemList.length,
              itemBuilder: (context, index) {
                var cartItem = controller.cartItemList[index];
                var purchasePass = cartItem.purchasePassModel;
                var reservedLot = cartItem.purchaseReservedLotModel;
                var compound = cartItem.compoundModel;

                if (compound != null) {
                  // Handle "Compound" case with compound-specific fields
                  return _buildCartItem(
                    context,
                    cartItem: cartItem,
                    passType: compound != null ? "Compound".tr : "Unknown".tr,
                    passPrice: compound.amount ?? '',
                    vehiclePlate: compound.vehicleNum ?? '',
                    // Use compound-specific fields for "Compound" type
                    compoundNo: compound.compoundNo ?? '',
                    kodHasil: compound.kodHasil ?? '',
                    dateTime: compound.dateTime.toString(),
                  );
                } else {
                  // Handle "Season Pass" or "Reserved Lot" case
                  return _buildCartItem(context,
                      cartItem: cartItem,
                      passType: purchasePass != null
                          ? "Season Pass".tr
                          : reservedLot != null
                              ? "Reserve Lot".tr
                              : "Unknown",
                      passPrice: purchasePass?.seasonPassModel?.price ??
                          reservedLot?.privatePassModel?.price ??
                          '',
                      vehiclePlate: purchasePass?.vehicleNo ??
                          reservedLot?.vehicleNo ??
                          '',
                      // Use dates and validity for "Season Pass" or "Reserved Lot"
                      startDate: purchasePass?.startDate?.toDate(),
                      endDate: purchasePass?.endDate?.toDate(),
                      validity: purchasePass?.seasonPassModel?.validity ??
                          reservedLot?.privatePassModel?.validity ??
                          '',
                      lotNo: reservedLot?.lotNo);
                }
              },
            );
          }
        }),
        bottomNavigationBar: Container(
          color: AppColors.primaryWhite,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ButtonThem.buildButton(
              context,
              btnHeight: 48,
              title: "Proceed".tr,
              txtColor: Colors.black,
              bgColor: AppColors.yellow04,
              onPress: () {
                if (controller.selectedCartItems.isNotEmpty) {
                  bool isSeasonPass = controller.selectedCartItems
                      .every((item) => item.purchasePassModel != null);

                  bool isCompound = controller.selectedCartItems
                      .every((item) => item.compoundModel != null);

                  if (isSeasonPass) {
                    Get.toNamed(Routes.SELECT_PAYMENT_SCREEN,
                        arguments: controller.selectedCartItems);
                  } else if (isCompound) {
                    Get.toNamed(Routes.PAY_COMPOUND, arguments: {
                      "selectedItems": controller.selectedCartItems,
                      "myPaymentCompoundModel":
                          controller.myPaymentCompoundModel.value
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Please select only Season Pass or Reserved Lot items.'
                                .tr),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please select items to proceed.'.tr)),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DialogBox(
          imageAsset: "assets/images/ic_warning.png", // Use a warning icon
          onPressConfirm: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.darkGrey10,
                    ),
                  ),
                );
              },
            );
            await controller
                .deleteSelectedCartItems(); // Call the method to delete items
            Get.back(); // Close the dialog after deletion
            Get.back();
          },
          onPressConfirmBtnName: "Delete".tr,
          onPressConfirmColor: AppColors.red04,
          onPressCancel: () {
            Get.back(); // Close the dialog without deletion
          },
          content:
              "Are you sure you want to delete the selected items from the cart?"
                  .tr,
          onPressCancelColor: AppColors.darkGrey01,
          subTitle: "Delete Confirmation".tr,
          onPressCancelBtnName: "Cancel".tr,
        );
      },
    );
  }
}

extension TimestampExtension on Timestamp {
  String toShortDateString() {
    DateTime dateTime = toDate();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return "$day/$month/$year";
  }
}
