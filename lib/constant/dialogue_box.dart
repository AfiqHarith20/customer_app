import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class DialogBox extends StatelessWidget {
  const DialogBox(
      {super.key,
      required this.onPressConfirm,
      required this.onPressConfirmBtnName,
      required this.onPressConfirmColor,
      required this.onPressCancel,
      required this.content,
      required this.onPressCancelColor,
      required this.subTitle,
      required this.imageAsset,
      required this.onPressCancelBtnName});

  final Function() onPressConfirm;
  final String onPressConfirmBtnName;
  final Color onPressConfirmColor;
  final Function() onPressCancel;
  final String onPressCancelBtnName;
  final Color onPressCancelColor;
  final String subTitle;
  final String imageAsset;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Image.asset(
                      imageAsset,
                      height: 56,
                      width: 56,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      subTitle,
                      style: const TextStyle(
                          decoration: TextDecoration.none, fontFamily: AppThemData.bold, fontSize: 18, color: AppColors.darkGrey09),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      content,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: AppThemData.regular,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey05),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Row(
                      children: [
                        Expanded(
                            child: ButtonThem.buildButton(
                          context,
                          title: onPressCancelBtnName,
                          btnHeight: 52,
                          txtColor: AppColors.darkGrey05,
                          bgColor: onPressCancelColor,
                          fontWeight: FontWeight.w600,
                          onPress: onPressCancel,
                        )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: ButtonThem.buildButton(
                          context,
                          title: onPressConfirmBtnName,
                          btnHeight: 52,
                          fontWeight: FontWeight.w600,
                          txtColor: AppColors.white,
                          bgColor: onPressConfirmColor,
                          onPress: onPressConfirm,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
