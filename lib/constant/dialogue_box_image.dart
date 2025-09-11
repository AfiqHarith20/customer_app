import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:flutter/material.dart';

class DialogueBoxImage extends StatelessWidget {
  final Function() onPressConfirm;
  final String onPressConfirmBtnName;
  final Color onPressConfirmColor;
  final String? imageUrl;
  const DialogueBoxImage(
      {super.key,
      required this.onPressConfirm,
      required this.onPressConfirmBtnName,
      required this.onPressConfirmColor,
      required this.imageUrl});

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
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Image.network(
                      imageUrl ?? '',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
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
          ),
        ],
      ),
    );
  }
}
