import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldWidgetSuffix extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController controller;
  final Function() onPress;
  final Widget? suffix;
  final bool? enable;
  final bool? readOnly;
  final TextInputType? textInputType;

  const TextFieldWidgetSuffix(
      {super.key,
      this.textInputType,
      this.enable,
      this.readOnly,
      this.suffix,
      this.title,
      required this.hintText,
      required this.controller,
      required this.onPress});

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
                Text(title ?? '', style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06)),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          TextFormField(
            validator: (value) => value != null && value.isNotEmpty ? null : 'phone_number_required'.tr,
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            onTap: onPress,
            textAlign: TextAlign.start,
            readOnly: readOnly ?? false,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
                errorStyle: const TextStyle(color: Colors.red, fontFamily: AppThemData.regular),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                suffixIcon: suffix,
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
                hintText: hintText.tr,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black12, fontFamily: AppThemData.medium)),
          ),
        ],
      ),
    );
  }
}
