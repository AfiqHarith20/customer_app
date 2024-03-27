// ignore_for_file: deprecated_member_use

import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UiInterface {
  AppBar customAppBar(
    BuildContext context,
    String title, {
    bool isBack = true,
    Color? backgroundColor,
    Color iconColor = AppColors.darkGrey10,
    Color textColor = AppColors.darkGrey10,
    List<Widget>? actions,
    Function()? onBackTap,
  }) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          if (isBack)
            InkWell(
                onTap: onBackTap ?? () => Get.back(),
                child: SvgPicture.asset(
                  "assets/icons/ic_arrow_left.svg",
                  color: AppColors.darkGrey06,
                )),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: const TextStyle(color: AppColors.darkGrey10, fontSize: 18, fontFamily: AppThemData.semiBold),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 8,
      actions: actions,
    );
  }
}
