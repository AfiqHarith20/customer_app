// ignore_for_file: file_names

class APIList {
  static String? baseUrl = "https://nazifastaging.cram-s.com";
  static String? auth = "${baseUrl!}/api/v1/commercepay/authenticate";
  static String? channels =
      "${baseUrl!}/api/v1/commercepay/channels?AccessToken=";
  static String? provider =
      "${baseUrl!}/api/v1/commercepay/provider?AccessToken=";
  static String? payment = "${baseUrl!}/api/v1/commercepay/purchase_pass";
  static String? payCompound = "${baseUrl!}/api/v1/commercepay/pay_compound";
  static String? walletTopyp = "${baseUrl!}/api/v1/commercepay/wallet_topup";
  static String? query =
      "${baseUrl!}/api/v1/commercepay/query?AccessToken=@token&TransactionId=";
  static String? searchCompound =
      "https://mptemerloh.epa-lits.com.my/search_compound_vendor.php";
  static String? reserveLot = "${baseUrl!}/api/v1/firebase/reservelot";
  static String? zone = "${baseUrl!}/api/v1/Parking/Zone";
  static String? road = "${baseUrl!}/api/v1/Parking/Road?ZoneId=";
  static String? queryPass = "${baseUrl!}/api/v1/Parking/QueryPass?";
  static String? queryLot = "${baseUrl!}/api/v1/Parking/QueryLot?";
  static String? bulkPaySeasonPass =
      "${baseUrl!}/api/v1/firebase/bulkpayseasonpass";
  static String? bulkpayreservelot =
      "${baseUrl!}/api/v1/firebase/bulkpayreservelot";
  static String? bulkpaycompound =
      "${baseUrl!}/api/v1/firebase/bulkpaycompound";
}
