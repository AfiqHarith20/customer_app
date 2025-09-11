import 'package:customer_app/app/modules/transaction_history_screen/controllers/transaction_history_screen_controller.dart';
import 'package:get/get.dart';

class TransactionHistoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryScreenController>(
      () => TransactionHistoryScreenController(),
    );
  }
}
