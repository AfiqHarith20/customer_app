import 'package:customer_app/app/models/notification_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/state_manager.dart';

class NotificationScreenController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
}
