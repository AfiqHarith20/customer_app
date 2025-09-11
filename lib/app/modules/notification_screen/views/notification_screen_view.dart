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
                ),
                child: Icon(
                  size: 30,
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
                          // Tab: Notifications
                          Tab(
                            child: Obx(() => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Notifications".tr),
                                    const SizedBox(width: 5),
                                    _buildNotificationCount(
                                        controller.notificationCount.value),
                                  ],
                                )),
                          ),
                          // Tab: Activity
                          Tab(
                            child: Obx(() => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Activity".tr),
                                    const SizedBox(width: 5),
                                    _buildNotificationCount(
                                        controller.activityCount.value),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // First tab: Notifications
                          RefreshIndicator(
                            onRefresh: () async {
                              await controller.loadNotifications();
                            },
                            child: ListView.builder(
                              itemCount: controller.notifyList.length,
                              itemBuilder: (context, index) {
                                var notification = controller.notifyList[index];
                                final category = notification['category'];
                                final createAt = notification['createAt'];
                                final message = notification['message'];
                                final title = notification['title'];
                                final isRead = RxBool(notification[
                                    'isRead']); // Ensure RxBool here
                                final reference = notification['reference'];

                                return category != 'Petak Khas'
                                    ? NotificationCard(
                                        controller: controller,
                                        title: title,
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
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        title ?? '',
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .darkGrey09,
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
                                                      onPressed: () async {
                                                        controller
                                                            .markAsRead(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'OK'.tr,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: AppColors
                                                              .darkGrey09,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        isRead: isRead,
                                      )
                                    : Container();
                              },
                            ),
                          ),
                          // Second tab: Activity
                          RefreshIndicator(
                            onRefresh: () async {
                              controller.loadNotifications();
                            },
                            child: ListView.builder(
                              itemCount: controller.notifyList.length,
                              itemBuilder: (context, index) {
                                var notification = controller.notifyList[index];
                                final category = notification['category'];
                                final createAt = notification['createAt'];
                                final message = notification['message'];
                                final title = notification['title'];
                                final isRead = RxBool(notification[
                                    'isRead']); // Ensure RxBool here
                                final reference = notification['reference'];

                                return category == 'Petak Khas'
                                    ? NotificationCard(
                                        controller: controller,
                                        title: title,
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
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        title ?? '',
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .darkGrey09,
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
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        message ?? '',
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        controller
                                                            .markAsRead(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'OK'.tr,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: AppColors
                                                              .darkGrey09,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        isRead:
                                            isRead, // Pass isRead property to NotificationCard
                                      )
                                    : Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom bar for edit mode actions
                    Visibility(
                      visible: controller.isInEditMode.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
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
                                            "Are you sure you want to delete this notification?"
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
                                  fontSize: 12,
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
                                controller.markAllSelectedAsRead();
                                controller.toggleEditMode();
                              },
                              child: Text(
                                "Mark as Read".tr,
                                style: const TextStyle(
                                  fontSize: 12,
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

  Widget _buildNotificationCount(int count) {
    if (count > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.red04,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

// NotificationCard widget

class NotificationCard extends StatelessWidget {
  final String? title;
  final dynamic createAt;
  final String? message;
  final bool isInEditMode;
  final bool isSelected;
  final VoidCallback onTap;
  final RxBool isRead; // Use RxBool here for reactivity
  final NotificationScreenController controller;

  const NotificationCard({
    Key? key,
    this.title,
    this.createAt,
    this.message,
    required this.isInEditMode,
    required this.isSelected,
    required this.onTap,
    required this.isRead,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Define the background color based on isRead
      Color backgroundColor = isRead.value
          ? Colors.white // Transparent grey background
          : AppColors.yellow03;

      // Define text color with opacity
      Color textColor = isRead.value
          ? Colors.black.withOpacity(0.6) // Transparent grey text
          : Colors.black;

      Color textTitleColor = isRead.value
          ? AppColors.darkGrey09.withOpacity(0.6) // Transparent grey text
          : AppColors.darkGrey09;

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: backgroundColor, // Use dynamic color based on isRead
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                              width:
                                  8), // Add some spacing between title and createAt
                          Text(
                            Constant.timestampToDate(createAt),
                            style: TextStyle(
                              color:
                                  textColor, // Use the defined textColor here
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor, // Use the defined textColor here
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
