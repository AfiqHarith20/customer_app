import 'package:clipboard/clipboard.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/show_toast_dialogue.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/themes/button_theme.dart';
import 'package:customer_app/themes/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/refer_screen_controller.dart';

class ReferScreenView extends StatelessWidget {
  const ReferScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ReferScreenController>(
        init: ReferScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface().customAppBar(context, "Refer And Earn".tr, backgroundColor: AppColors.white),
            body: (controller.isLoading.value)
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Refer and Earn Rewards".tr,
                            style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 20, color: AppColors.darkGrey10),
                          ),
                          Text(
                            "Invite friends to use our app and earn exclusive rewards for every successful referral. Share the benefits today!"
                                .tr,
                            style: const TextStyle(fontFamily: AppThemData.regular, color: AppColors.lightGrey10),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 66.0, vertical: 32),
                            child: Image.asset("assets/images/refer_and_earnbg.png"),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: ButtonThem.buildButton(
                                context,
                                btnHeight: 45,
                                title: "${controller.referralModel.value.referralCode}",
                                txtColor: AppColors.yellow10,
                                bgColor: AppColors.yellow04,
                                onPress: () {},
                              )),
                              const SizedBox(
                                width: 20,
                              ),
                              ButtonThem.buildButton(
                                btnWidthRatio: .35,
                                context,
                                btnHeight: 45,
                                title: "Tap To Copy".tr,
                                txtColor: AppColors.lightGrey01,
                                bgColor: AppColors.darkGrey10,
                                onPress: () {
                                  FlutterClipboard.copy('${controller.referralModel.value.referralCode}')
                                      .then((value) => ShowToastDialog.showToast("Copied"));
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            "How it Works".tr,
                            style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 16, color: AppColors.darkGrey10),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          commanWidget(
                              title: "Refer Friends",
                              description: "Share your unique referral link or code with friends.",
                              imageAsset: "assets/icons/ic_mail.svg"),
                          commanWidget(
                              title: "Friends Join",
                              description: "Friends sign up for the app using your referral link or code.",
                              imageAsset: "assets/icons/ic_supervised.svg"),
                          commanWidget(
                              title: "Earn Rewards",
                              description:
                                  "You and your friends earn rewards, such as discounts or credits, when they make their first booking or transaction using the app.",
                              imageAsset: "assets/icons/ic_gift_card.svg"),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: ButtonThem.buildButton(
                txtSize: 16,
                context,
                title: "Refer Now".tr,
                txtColor: AppColors.lightGrey01,
                bgColor: AppColors.darkGrey10,
                onPress: () {
                  share(controller);
                },
              ),
            ),
          );
        });
  }
}

Future<void> share(ReferScreenController controller) async {
  await FlutterShare.share(
    title: 'NAZIFA Customer'.tr,
    text:
        'Hey there, thanks for choosing NAZIFA Customer. Hope you love our product. If you do, share it with your friends using code ${controller.referralModel.value.referralCode.toString()} and get ${Constant.amountShow(amount: Constant.referralAmount)}.'
            .tr,
  );
}

commanWidget({required String imageAsset, required String title, required String description}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 24, backgroundColor: AppColors.white, child: SvgPicture.asset(imageAsset)),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.tr,
                style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 16, color: AppColors.darkGrey10),
              ),
              Text(
                description.tr,
                style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 12, color: AppColors.lightGrey09),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
