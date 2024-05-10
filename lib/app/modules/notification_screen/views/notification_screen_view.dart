import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/modules/notification_screen/controllers/notification_screen_controller.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/constant/dialogue_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/common_ui.dart';

class NotificationScreenView extends GetView<NotificationScreenController> {
  const NotificationScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NotificationScreenController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey02,
        appBar: UiInterface().customAppBar(
          backgroundColor: AppColors.yellow04,
          context,
          "Inbox".tr,
          isBack: true,
          actions: [
            InkWell(
              onTap: () {
                // Toggle the selection mode
                controller.toggleEditMode();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16.0,
                  top: 10,
                ),
                child: Icon(
                  controller.isInEditMode.value
                      ? Icons.cancel
                      : Icons.edit_notifications_rounded,
                  color: AppColors.darkGrey10,
                ),
              ),
            ),
          ],
        ),
        body: controller.isLoading.value
            ? Constant.loader()
            : DefaultTabController(
                length: 2, // Number of tabs
                child: Column(
                  children: [
                    Container(
                      color: AppColors.yellow04,
                      child: TabBar(
                        labelColor: AppColors.darkGrey10,
                        tabs: [
                          Tab(
                            text: "Notifications".tr,
                          ),
                          Tab(
                            text: "Activity".tr,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // First tab: Notifications
                          Obx(() {
                            return ListView.separated(
                              itemCount: controller.notifyList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 2,
                              ),
                              itemBuilder: (context, index) {
                                var notification = controller.notifyList[index];
                                final category = notification['category'];
                                final createAt = notification['createAt'];
                                final message = notification['message'];

                                // Render each notification card based on selection mode
                                return category != 'Petak Khas'
                                    ? NotificationCard(
                                        category: category,
                                        createAt: createAt,
                                        message: message,
                                        isInEditMode:
                                            controller.isInEditMode.value,
                                        isSelected:
                                            controller.isSelected(index),
                                        onTap: () {
                                          if (controller.isInEditMode.value) {
                                            controller.toggleSelection(index);
                                          } else {
                                            // Handle tapping on notification card in normal mode
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                final controller = Get.find<
                                                    NotificationScreenController>();
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        category ?? '',
                                                        style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        Constant
                                                            .timestampToDate(
                                                                createAt),
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        message ?? '',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Mark the notification as read and close the dialog
                                                        controller
                                                            .markSelectedAsRead();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Mark as Read'.tr,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: AppColors
                                                              .yellow04,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      )
                                    : Container();
                              },
                            );
                          }),
                          // Second tab: Activity
                          Obx(() {
                            return ListView.separated(
                              itemCount: controller.notifyList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 2,
                              ),
                              itemBuilder: (context, index) {
                                var notification = controller.notifyList[index];
                                final category = notification['category'];
                                final createAt = notification['createAt'];
                                final message = notification['message'];

                                // Only show notifications with category 'Petak Khas'
                                return category == 'Petak Khas'
                                    ? NotificationCard(
                                        category: category,
                                        createAt: createAt,
                                        message: message,
                                        isInEditMode:
                                            controller.isInEditMode.value,
                                        isSelected:
                                            controller.isSelected(index),
                                        onTap: () {
                                          if (controller.isInEditMode.value) {
                                            controller.toggleSelection(index);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                final controller = Get.find<
                                                    NotificationScreenController>();
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        category ?? '',
                                                        style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        Constant
                                                            .timestampToDate(
                                                                createAt),
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        message ?? '',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Mark the notification as read and close the dialog
                                                        controller
                                                            .markSelectedAsRead();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Ok'.tr,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      )
                                    : Container();
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    // Bottom bar for edit mode actions
                    Visibility(
                      visible: controller.isInEditMode.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        color: Colors.grey[100],
                        child: Row(
                          children: [
                            // Select all checkbox
                            Checkbox(
                              activeColor: Colors.blue,
                              value: controller.isAllSelected(),
                              onChanged: (value) {
                                controller.toggleSelectAll(value ?? false);
                              },
                            ),
                            Text(
                              "Select All".tr,
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            // Delete button
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  AppColors.red04,
                                ), // Change color here
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DialogBox(
                                        imageAsset:
                                            "assets/images/ic_delete.png",
                                        onPressConfirm: () async {
                                          controller
                                              .deleteSelectedNotifications();
                                          Navigator.of(context).pop();
                                        },
                                        onPressConfirmBtnName: "Delete".tr,
                                        onPressConfirmColor: AppColors.red04,
                                        onPressCancel: () {
                                          Get.back();
                                        },
                                        content:
                                            "Are you sure you want to Delete this notification."
                                                .tr,
                                        onPressCancelColor:
                                            AppColors.darkGrey01,
                                        subTitle: "Delete Notification".tr,
                                        onPressCancelBtnName: "Cancel".tr);
                                  },
                                );
                              },
                              child: Text(
                                "Delete".tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Mark as read button
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  AppColors.yellow04,
                                ), // Change color here
                              ),
                              onPressed: () {
                                controller.markSelectedAsRead();
                                controller.toggleEditMode();
                              },
                              child: Text(
                                "Mark as Read".tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

// NotificationCard widget

class NotificationCard extends StatelessWidget {
  final String? category;
  final dynamic createAt;
  final String? message;
  final bool isInEditMode;
  final bool isSelected;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    this.category,
    this.createAt,
    this.message,
    required this.isInEditMode,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              if (isInEditMode)
                Checkbox(
                  activeColor: Colors.blue,
                  value: isSelected,
                  onChanged: (_) => onTap(),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category ?? '',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Constant.timestampToDate(createAt),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
