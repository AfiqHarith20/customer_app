import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:customer_app/app/models/commercepay/transaction_fee_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/transaction_history_model.dart';
import 'package:customer_app/utils/fire_store_utils.dart';

class TransactionHistoryDetailScreenController extends GetxController {
  RxBool isLoading = true.obs;
  late TransactionHistoryModel transactionHistoryModel;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  TransactionFeeModel transactionFeeModel = TransactionFeeModel();
  var invoiceNumber = ''.obs;
  var invoiceDate = ''.obs;

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

  Future<void> generateAndSharePdf({
    required String fullName,
    required String email,
    required String transactionType,
    required String amount,
    required String invoiceNumber,
    required String invoiceDate,
    required String transactionFee,
    required String paymentType,
    required String totalPrice,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'NAZIFA RESOURCES SDN. BHD.',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'NO.32, JALAN SUDIRMAN 7, 28000, TEMERLOH',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'PAHANG DARUL MAKMUR',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'TEL: 09-2964820, FAX: 09-2968475',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'NO SST: C21-1808-31010712',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  fullName.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  'Email: $email',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Reciept #$invoiceNumber",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.Text(
                    "Date $invoiceDate",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.grey800,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 10,
                    child: pw.Text(
                      "Item Description",
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      "Price",
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Center(
                child: pw.Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 10,
                    child: pw.Text(
                      transactionType,
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      'RM$amount',
                      textAlign: pw.TextAlign.end,
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 11,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'SUBTOTAL',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              'RM$amount',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 11,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'TRANSACTION FEE',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              'RM$transactionFee',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 11,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'TOTAL',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              'RM$totalPrice',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 11,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Payment Type',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              paymentType,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Center(
                child: pw.Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  "Thank You!",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    final xfile = XFile(file.path);
    Share.shareXFiles([xfile], text: 'Here is your invoice');
  }
}
