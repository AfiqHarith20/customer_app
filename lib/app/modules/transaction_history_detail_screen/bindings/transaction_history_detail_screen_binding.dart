import 'package:customer_app/app/modules/transaction_history_detail_screen/controllers/transaction_history_detail_screen_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class TransactionHistoryDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryDetailScreenController>(
      () => TransactionHistoryDetailScreenController(),
    );
  }
}
