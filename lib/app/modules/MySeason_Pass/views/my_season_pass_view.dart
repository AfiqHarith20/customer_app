import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_them_data.dart';
import '../../../../themes/common_ui.dart';
import '../../../routes/app_pages.dart';
import '../controllers/my_season_pass_controller.dart';

class MySeasonPassView extends GetView<MySeasonPassController> {
  const MySeasonPassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<MySeasonPassController>(
        init: MySeasonPassController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(
              backgroundColor: AppColors.lightGrey02,
              context,
              "My Season Pass".tr,
              isBack: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.SEASON_PASS);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          color: AppColors.yellow04,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "Add".tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: AppThemData.bold,
                            color: AppColors.darkGrey08,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.mySeasonPassList.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color:
                                      AppColors.darkGrey02.withOpacity(0.5))),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  leading: Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                        color: AppColors.yellow04,
                                        borderRadius:
                                            BorderRadius.circular(200)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/ic_pass.svg',
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    controller.mySeasonPassList[index]
                                        .seasonPassModel!.passName
                                        .toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: AppThemData.bold,
                                      color: AppColors.darkGrey08,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        'RM ${controller.mySeasonPassList[index].seasonPassModel!.price.toString()}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppThemData.medium,
                                          color: AppColors.yellow04,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '/ ${controller.mySeasonPassList[index].seasonPassModel?.validity.toString()}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: AppThemData.medium,
                                            color: AppColors.darkGrey08,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 2,
                                color: AppColors.darkGrey02,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              itemWidget(
                                  subText: controller
                                      .mySeasonPassList[index].id!
                                      .substring(0, 8),
                                  title: 'Serial Number:'.tr,
                                  svgImage: 'assets/icons/ic_hash.svg'),
                              itemWidget(
                                  subText: Constant.timestampToDate(controller
                                      .mySeasonPassList[index].endDate!),
                                  title: '${'Validity'.tr}:',
                                  svgImage: 'assets/icons/ic_timer.svg'),
                              itemWidget(
                                  subText:
                                      '${controller.mySeasonPassList[index].vehicleNo}',
                                  title: 'Plate Number:'.tr,
                                  svgImage: 'assets/icons/ic_carsimple.svg'),
                              itemWidget(
                                  subText:
                                      '${controller.mySeasonPassList[index].paymentType}',
                                  title: 'Payment Type:'.tr,
                                  svgImage: 'assets/icons/ic_payment.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        });
  }

  static Widget itemWidget({
    required String subText,
    required String svgImage,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgImage,
            color: AppColors.darkGrey05,
            height: 20,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(title.tr,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppThemData.regular,
                color: AppColors.darkGrey09,
              )),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Text(
              subText.tr,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ).marginOnly(left: 10, right: 10),
    );
  }
}
