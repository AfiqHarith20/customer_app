// ignore_for_file: file_names

class APIList {
  static String? baseUrl = "https://nazifastaging.cram-s.com";
  static String? auth = "${baseUrl!}/api/v1/commercepay/authenticate";
  static String? channels =
      "${baseUrl!}/api/v1/commercepay/channels?AccessToken=";
  static String? provider =
      "${baseUrl!}/api/v1/commercepay/provider?AccessToken=";
  static String? payment = "${baseUrl!}/api/v1/commercepay/payment";
  static String? query =
      "${baseUrl!}/api/v1/commercepay/query?AccessToken=@token&TransactionId=";
  static String? searchCompound =
      "https://mptemerloh.epa-lits.com.my/search_compound_vendor.php";
  static String? payCompound =
      "https://mptemerloh.epa-lits.com.my/payment_import_vendor.php";
}
