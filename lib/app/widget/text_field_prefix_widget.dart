// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFieldWidgetPrefix extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController controller;
  final Function() onPress;
  final Widget? prefix;
  final bool? enable;
  final bool? readOnly;
  final validator;
  final TextInputType? textInputType;
  final textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWidgetPrefix({
    super.key,
    this.textInputType,
    this.enable,
    this.prefix,
    this.readOnly,
    this.title,
    this.inputFormatters,
    this.validator,
    required this.hintText,
    required this.controller,
    required this.onPress,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? '',
                    style: const TextStyle(
                        color: AppColors.darkGrey06,
                        fontFamily: AppThemData.regular)),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          TextFormField(
            validator: validator,
            keyboardType: textInputType ?? TextInputType.text,
            onTap: onPress,
            readOnly: readOnly ?? false,
            textCapitalization: TextCapitalization.characters,
            controller: controller,
            textAlign: TextAlign.start,
            inputFormatters: inputFormatters,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
                errorStyle: const TextStyle(
                    color: Colors.red, fontFamily: AppThemData.regular),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: prefix != null ? 0 : 10),
                prefixIcon: prefix,
                disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: AppColors.white, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: AppColors.white, width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: AppColors.white, width: 1),
                ),
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: AppColors.white, width: 1),
                ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: AppColors.white, width: 1),
                ),
                hintText: hintText.tr,
                hintStyle: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGrey04,
                    fontFamily: AppThemData.medium)),
          ),
        ],
      ),
    );
  }
}
