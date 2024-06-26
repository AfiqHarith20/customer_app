import 'package:customer_app/app/models/commercepay/transaction_fee_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/transaction_history_model.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class TransactionHistoryDetailScreenController extends GetxController {
  RxBool isLoading = true.obs;
  late TransactionHistoryModel transactionHistoryModel;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  TransactionFeeModel transactionFeeModel = TransactionFeeModel();

  @override
  void onInit() {
    super.onInit();
    // Ensure Get.arguments is correctly passed as a Map<String, dynamic>
    Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
    transactionHistoryModel = TransactionHistoryModel.fromMap(arguments);
    getProfileData();
    fetchTransactionFee();
  }

  getProfileData() async {
    try {
      isLoading.value = true;
      await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
          .then((value) {
        if (value != null) {
          customerModel.value = value;
        }
      });
    } finally {
      isLoading.value = false;
    }
  }

  fetchTransactionFee() async {
    isLoading.value = true;
    transactionFeeModel = (await FireStoreUtils.getTransactionFee())!;
    if (transactionFeeModel != null) {
      print('Fetched Transaction Fee: ${transactionFeeModel.value}');
    }
    update(); // Notify the UI to rebuild with the fetched data
  }
}
