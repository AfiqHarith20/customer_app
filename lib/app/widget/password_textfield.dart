import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class PasswordTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool? enabled;

  const PasswordTextField({
    super.key,
    required this.title,
    required this.controller,
    this.enabled,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: AppColors.darkGrey06,
              fontFamily: AppThemData.regular,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            validator: (value) => value != null && value.isNotEmpty
                ? null
                : 'Password required'.tr,
            keyboardType: TextInputType.text,
            obscureText: _obscureText,
            controller: widget.controller,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.darkGrey07,
              fontSize: 14,
              fontFamily: AppThemData.regular,
            ),
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              isDense: true,
              filled: true,
              enabled: widget.enabled ?? true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Icon(Icons.key_outlined),
              ),
              suffixIcon: IconButton(
                icon: FaIcon(
                  _obscureText
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  size: 18,
                  color: AppColors.darkGrey04,
                ),
                onPressed: _toggleVisibility,
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
              hintText: "Enter Password".tr,
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
