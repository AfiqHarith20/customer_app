import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class EmailTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function() onPress;
  final bool? enabled;
  const EmailTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.onPress,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: AppColors.darkGrey06, fontFamily: AppThemData.regular),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            validator: (value) =>
                value != null && value.isNotEmpty ? null : 'Email required'.tr,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.darkGrey07,
              fontSize: 14,
              fontFamily: AppThemData.regular,
            ),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            // ],
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              isDense: true,
              filled: true,
              enabled: enabled ?? true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Icon(
                  Icons.email,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black12, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black12, width: 1),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              errorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black12, width: 1),
              ),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black12, width: 1),
              ),
              hintText: "Enter Email".tr,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: AppColors.darkGrey04,
                fontFamily: AppThemData.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
