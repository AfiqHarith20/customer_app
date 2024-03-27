import 'package:customer_app/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonThem {
  static buildButton(BuildContext context,
      {required String title,
      required Color txtColor,
      required Color bgColor,
      double btnHeight = 60,
      double txtSize = 14,
      double btnWidthRatio = 0.9,
      String? imageAsset,
      double borderRadius = 30,
      required Function() onPress,
      String iconAssetImage = '',
      fontWeight = FontWeight.w700}) {
    return Container(
      height: btnHeight,
      width: MediaQuery.of(context).size.width * btnWidthRatio ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: MaterialButton(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        onPressed: onPress,
        elevation: 0,
        child: Row(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 6),
                child: SvgPicture.asset(imageAsset),
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: AppThemData.semiBold, fontSize: txtSize, color: txtColor, fontWeight: fontWeight),
            ),
          ],
        ),
      ),
    );
  }
}
