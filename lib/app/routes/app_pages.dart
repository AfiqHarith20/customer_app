import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/modules/news_detail_screen/bindings/news_detail_screen_binding.dart';
import 'package:customer_app/app/modules/news_detail_screen/views/news_detail_screen_view.dart';
import 'package:customer_app/app/modules/news_screen/bindings/news_screen_binding.dart';
import 'package:customer_app/app/modules/news_screen/views/news_screen_view.dart';
import 'package:customer_app/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:customer_app/app/modules/pay_compound_screen/bindings/pay_compound_screen_binding.dart';
import 'package:customer_app/app/modules/pay_compound_screen/views/pay_compound_screen_view.dart';
import 'package:customer_app/app/modules/pay_pending_pass_screen/bindings/pay_pending_pass_screen_binding.dart';
import 'package:customer_app/app/modules/pay_pending_pass_screen/views/pay_pending_pass_screen_view.dart';
import 'package:customer_app/app/modules/purchase_pass_private/bindings/purchase_pass_private_binding.dart';
import 'package:customer_app/app/modules/purchase_pass_private/views/purchase_pass_private_view.dart';
import 'package:customer_app/app/modules/qrcode_screen/controllers/qrcode_screen_controller.dart';
import 'package:customer_app/app/modules/qrcode_screen/views/qrcode_screen_view.dart';
import 'package:customer_app/app/modules/register_screen/bindings/register_screen_binding.dart';
import 'package:customer_app/app/modules/register_screen/views/register_screen_view.dart';
import 'package:customer_app/app/modules/reset_password_screen/bindings/reset_password_screen_binding.dart';
import 'package:customer_app/app/modules/reset_password_screen/views/reset_password_screen_view.dart';
import 'package:customer_app/app/modules/search_summon_screen/bindings/search_summon_screen_binding.dart';
import 'package:customer_app/app/modules/search_summon_screen/controllers/search_summon_screen_controller.dart';
import 'package:customer_app/app/modules/search_summon_screen/views/search_summon_screen_view.dart';
import 'package:customer_app/app/modules/select_bank_provider_screen/bindings/select_bank_provider_screen_binding.dart';
import 'package:customer_app/app/modules/select_bank_provider_screen/views/select_bank_provider_screen_view.dart';
import 'package:customer_app/app/modules/transaction_history_detail_screen/bindings/transaction_history_detail_screen_binding.dart';
import 'package:customer_app/app/modules/transaction_history_detail_screen/views/transaction_history_detail_screen_view.dart';
import 'package:customer_app/app/modules/transaction_history_screen/bindings/transaction_history_screen_binding.dart';
import 'package:customer_app/app/modules/transaction_history_screen/views/transaction_history_screen_view.dart';
import 'package:customer_app/app/modules/webview/bindings/webview_screen_binding.dart';
import 'package:customer_app/app/modules/webview/views/webview_screen_view.dart';
import 'package:customer_app/app/modules/webview_compound_screen/bindings/webview_compound_screen_binding.dart';
import 'package:customer_app/app/modules/webview_compound_screen/views/webview_compound_screen_view.dart';
import 'package:get/get.dart';

import '../modules/MySeason_Pass/bindings/my_season_pass_binding.dart';
import '../modules/MySeason_Pass/views/my_season_pass_view.dart';
import '../modules/Season_pass/bindings/season_pass_binding.dart';
import '../modules/Season_pass/views/season_pass_view.dart';
import '../modules/apply_coupon_screen/bindings/apply_coupon_screen_binding.dart';
import '../modules/apply_coupon_screen/views/apply_coupon_screen_view.dart';
import '../modules/booking_detail_screen/bindings/booking_detail_screen_binding.dart';
import '../modules/booking_detail_screen/views/booking_detail_screen_view.dart';
import '../modules/booking_screen/bindings/booking_screen_binding.dart';
import '../modules/booking_screen/views/booking_screen_view.dart';
import '../modules/booking_summary_screen/bindings/booking_summary_screen_binding.dart';
import '../modules/booking_summary_screen/views/booking_summary_screen_view.dart';
import '../modules/cancel_screen/bindings/cancel_screen_binding.dart';
import '../modules/cancel_screen/views/cancel_screen_view.dart';
import '../modules/choose_date_time_screen/bindings/choose_date_time_screen_binding.dart';
import '../modules/choose_date_time_screen/views/choose_date_time_screen_view.dart';
import '../modules/completed_screen/bindings/completed_screen_binding.dart';
import '../modules/completed_screen/views/completed_screen_view.dart';
import '../modules/contact_us_screen/bindings/contact_us_screen_binding.dart';
import '../modules/contact_us_screen/views/contact_us_screen_view.dart';
import '../modules/dashboard_screen/bindings/dashboard_screen_binding.dart';
import '../modules/dashboard_screen/views/dashboard_screen_view.dart';
import '../modules/edit_profile_screen/bindings/edit_profile_screen_binding.dart';
import '../modules/edit_profile_screen/views/edit_profile_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/information_screen/bindings/information_screen_binding.dart';
import '../modules/information_screen/views/information_screen_view.dart';
import '../modules/intro_screen/bindings/intro_screen_binding.dart';
import '../modules/intro_screen/views/intro_screen_view.dart';
import '../modules/language_screen/bindings/language_screen_binding.dart';
import '../modules/language_screen/views/language_screen_view.dart';
import '../modules/like_screen/bindings/like_screen_binding.dart';
import '../modules/like_screen/views/like_screen_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/notification_screen/bindings/notification_screen_binding.dart';
import '../modules/on_going_screen/bindings/on_going_screen_binding.dart';
import '../modules/on_going_screen/views/on_going_screen_view.dart';
import '../modules/otp_screen/bindings/otp_screen_binding.dart';
import '../modules/otp_screen/views/otp_screen_view.dart';
import '../modules/parking_detail_screen/bindings/parking_detail_screen_binding.dart';
import '../modules/parking_detail_screen/views/parking_detail_screen_view.dart';
import '../modules/placed_screen/bindings/placed_screen_binding.dart';
import '../modules/placed_screen/views/placed_screen_view.dart';
import '../modules/profile_screen/bindings/profile_screen_binding.dart';
import '../modules/profile_screen/views/profile_screen_view.dart';
import '../modules/purchase_pass/bindings/purchase_pass_binding.dart';
import '../modules/purchase_pass/views/purchase_pass_view.dart';
import '../modules/qrcode_screen/bindings/qrcode_screen_binding.dart';
import '../modules/rate_us_screen/bindings/rate_us_screen_binding.dart';
import '../modules/rate_us_screen/views/rate_us_screen_view.dart';
import '../modules/refer_screen/bindings/refer_screen_binding.dart';
import '../modules/refer_screen/views/refer_screen_view.dart';
import '../modules/search_screen/bindings/search_screen_binding.dart';
import '../modules/search_screen/views/search_screen_view.dart';
import '../modules/select_payment_screen/bindings/select_payment_screen_binding.dart';
import '../modules/select_payment_screen/views/select_payment_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/wallet_screen/bindings/wallet_screen_binding.dart';
import '../modules/wallet_screen/views/wallet_screen_view.dart';
import '../modules/welcome_screen/bindings/welcome_screen_binding.dart';
import '../modules/welcome_screen/views/welcome_screen_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREEN,
      page: () => const IntroScreenView(),
      binding: IntroScreenBinding(),
    ),
    GetPage(
        name: _Paths.LOGIN_SCREEN,
        page: () => const LoginScreenView(),
        binding: LoginScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.REGISTER_SCREEN,
        page: () => const RegisterScreenView(),
        binding: RegisterScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.RESET_PASS_SCREEN,
        page: () => const ResetPasswordScreenView(),
        binding: ResetPasswordScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
      name: _Paths.WELCOME_SCREEN,
      page: () => const WelcomeScreenView(),
      binding: WelcomeScreenBinding(),
    ),
    GetPage(
        name: _Paths.INFORMATION_SCREEN,
        page: () => const InformationScreenView(),
        binding: InformationScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
      name: _Paths.OTP_SCREEN,
      page: () => const OtpScreenView(),
      binding: OtpScreenBinding(),
    ),
    GetPage(
        name: _Paths.BOOKING_SCREEN,
        page: () => const BookingScreenView(),
        binding: BookingScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
      name: _Paths.DASHBOARD_SCREEN,
      page: () => const DashboardScreenView(),
      binding: DashboardScreenBinding(),
    ),
    GetPage(
      name: _Paths.ON_GOING_SCREEN,
      page: () => const OnGoingScreenView(),
      binding: OnGoingScreenBinding(),
    ),
    GetPage(
        name: _Paths.BOOKING_SUMMARY_SCREEN,
        page: () => const BookingSummaryScreenView(),
        binding: BookingSummaryScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.WALLET_SCREEN,
        page: () => WalletScreenView(
              selectedBankId: Get.arguments["selectedBankId"] ?? '',
              selectedBankName: Get.arguments["selectedBankName"] ?? '',
              accessToken: Get.arguments["accessToken"] ?? '',
              customerId: Get.arguments["customerId"] ?? '',
              amount: Get.arguments["amount"] ?? '0.0',
              name: Get.arguments["name"] ?? '',
              mobileNumber: Get.arguments["mobileNumber"] ?? '',
              username: Get.arguments["username"] ?? '',
              identificationNumber: Get.arguments["identificationNumber"] ?? '',
              identificationType: Get.arguments["identificationType"] ?? '',
              email: Get.arguments["email"] ?? '',
              channelId: Get.arguments["channelId"] ?? '',
            ),
        binding: WalletScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.LIKE_SCREEN,
        page: () => const LikeScreenView(),
        binding: LikeScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.PARKING_DETAIL_SCREEN,
        page: () => const ParkingDetailScreenView(),
        binding: ParkingDetailScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const ProfileScreenView(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_SCREEN,
      page: () => const SearchScreenView(),
      binding: SearchScreenBinding(),
    ),
    GetPage(
        name: _Paths.BOOKING_DETAIL_SCREEN,
        page: () => const BookingDetailScreenView(),
        binding: BookingDetailScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.CHOOSE_DATE_TIME_SCREEN,
        page: () => const ChooseDateTimeScreenView(),
        binding: ChooseDateTimeScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.APPLY_COUPON_SCREEN,
        page: () => const ApplyCouponScreenView(),
        binding: ApplyCouponScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.SELECT_PAYMENT_SCREEN,
        page: () => SelectPaymentScreenView(
              passId: Get.arguments['passId'] ?? '',
              passName: Get.arguments["passName"] ?? '',
              passPrice: Get.arguments["passPrice"] ?? '',
              passValidity: Get.arguments["passValidity"] ?? '',
              selectedBankName: Get.arguments["bankName"] ?? '',
              selectedBankId: Get.arguments["selectedBankId"] ?? '',
              accessToken: Get.arguments["accessToken"] ?? '',
              customerId: Get.arguments["customerId"] ?? '',
              totalPrice: double.parse(Get.arguments["totalPrice"] ?? '0.0'),
              address: Get.arguments["address"] ?? '',
              companyName: Get.arguments["companyName"] ?? '',
              companyRegistrationNo:
                  Get.arguments["companyRegistrationNo"] ?? '',
              endDate: Get.arguments["endDate"] ?? '',
              startDate: Get.arguments["startDate"] ?? '',
              fullName: Get.arguments["name"] ?? '',
              email: Get.arguments["email"] ?? '',
              mobileNumber: Get.arguments["mobileNumber"] ?? '',
              userName: Get.arguments["username"] ?? '',
              identificationNo: Get.arguments["identificationNumber"] ?? '',
              identificationType: Get.arguments["identificationType"] ?? '',
              vehicleNo: Get.arguments["vehicleNo"] ?? '',
              lotNo: Get.arguments["lotNo"] ?? '',
              selectedPassId: Get.arguments["passId"] ?? '',
            ),
        binding: SelectPaymentScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
      name: _Paths.PLACED_SCREEN,
      page: () => const PlacedScreenView(),
      binding: PlacedScreenBinding(),
    ),
    GetPage(
        name: _Paths.EDIT_PROFILE_SCREEN,
        page: () => const EditProfileScreenView(),
        binding: EditProfileScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
      name: _Paths.COMPLETED_SCREEN,
      page: () => const CompletedScreenView(),
      binding: CompletedScreenBinding(),
    ),
    GetPage(
      name: _Paths.CANCEL_SCREEN,
      page: () => const CancelScreenView(),
      binding: CancelScreenBinding(),
    ),
    GetPage(
        name: _Paths.RATE_US_SCREEN,
        page: () => const RateUsScreenView(),
        binding: RateUsScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.REFER_SCREEN,
        page: () => const ReferScreenView(),
        binding: ReferScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.LANGUAGE_SCREEN,
        page: () => const LanguageScreenView(),
        binding: LanguageScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
        name: _Paths.CONTACT_US_SCREEN,
        page: () => const ContactUsScreenView(),
        binding: ContactUsScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 250)),
    GetPage(
      name: _Paths.SEASON_PASS,
      page: () => const SeasonPassView(),
      binding: SeasonPassBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE_PASS,
      page: () => const PurchasePassView(),
      binding: PurchasePassBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE_PASS_PRIVATE,
      page: () => const PurchasePassPrivateView(),
      binding: PurchasePassPrivateBinding(),
    ),
    GetPage(
      name: _Paths.MY_SEASON_PASS,
      page: () => const MySeasonPassView(),
      binding: MySeasonPassBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_SUMMON_SCREEN,
      page: () => SearchSummonScreenView(
        controller:
            Get.arguments['controller'] ?? SearchSummonScreenController(),
      ),
      binding: SearchSummonScreenBinding(),
    ),
    GetPage(
      name: _Paths.QRCODE_SCREEN,
      page: () => QRCodeScanScreenView(
        controller: Get.arguments['controller'] ?? QRCodeScanController(),
        // searchController:
        //     Get.arguments['searchController'] ?? QRCodeScanController(),
      ),
      binding: QRCodeScanBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SCREEN,
      page: () => NotificationScreenView(
          // controller: Get.arguments['controller'] ?? '',
          ),
      binding: NotificationScreenBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_BANK_PROVIDER_SCREEN,
      page: () => const SelectBankProviderScreenView(),
      binding: SelectBankProviderScreenBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW_SCREEN,
      page: () => const WebviewScreen(),
      binding: WebviewScreenBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW_COMPOUND_SCREEN,
      page: () => const WebviewCompoundScreen(),
      binding: WebviewCompoundScreenBinding(),
    ),
    GetPage(
      name: _Paths.PAY_COMPOUND,
      page: () => PayCompoundScreenView(
        selectedBankName: Get.arguments["bankName"] ?? '',
        selectedBankId: Get.arguments["selectedBankId"] ?? '',
        accessToken: Get.arguments["accessToken"] ?? '',
        customerId: Get.arguments["customerId"] ?? '',
        amount: Get.arguments["amount"] ?? '0.0',
        address: Get.arguments["address"] ?? '',
        name: Get.arguments["name"] ?? '',
        mobileNumber: Get.arguments["mobileNumber"] ?? '',
        userName: Get.arguments["username"] ?? '',
        identificationNo: Get.arguments["identificationNumber"] ?? '',
        identificationType: Get.arguments["identificationType"] ?? '',
        vehicleNum: Get.arguments["vehicle_num"] ?? '',
        email: Get.arguments["email"] ?? '',
        compoundNo: Get.arguments["compoundNo"] ?? '',
        kodHasil: Get.arguments["kodHasil"] ?? '',
      ),
      binding: PayCompoundScreenBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_SCREEN,
      page: () => const NewsScreenView(),
      binding: NewsScreenBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL_SCREEN,
      page: () => const NewsDetailScreenView(),
      binding: NewsDetailScreenBinding(),
    ),
    GetPage(
      name: _Paths.PAY_PENDING_PASS,
      page: () => PayPendingPassScreenView(
        passId: Get.arguments['passId'] ?? '',
        passName: Get.arguments["passName"] ?? '',
        passPrice: Get.arguments["passPrice"] ?? '',
        passValidity: Get.arguments["passValidity"] ?? '',
        selectedBankName: Get.arguments["bankName"] ?? '',
        selectedBankId: Get.arguments["selectedBankId"] ?? '',
        accessToken: Get.arguments["accessToken"] ?? '',
        customerId: Get.arguments["customerId"] ?? '',
        totalPrice: double.parse(Get.arguments["totalPrice"] ?? '0.0'),
        address: Get.arguments["address"] ?? '',
        companyName: Get.arguments["companyName"] ?? '',
        companyRegistrationNo: Get.arguments["companyRegistrationNo"] ?? '',
        endDate:
            Timestamp.fromDate(DateTime.parse(Get.arguments["endDate"] ?? '')),
        startDate: Timestamp.fromDate(
            DateTime.parse(Get.arguments["startDate"] ?? '')),
        fullName: Get.arguments["name"] ?? '',
        email: Get.arguments["email"] ?? '',
        mobileNumber: Get.arguments["mobileNumber"] ?? '',
        userName: Get.arguments["username"] ?? '',
        identificationNo: Get.arguments["identificationNumber"] ?? '',
        identificationType: Get.arguments["identificationType"] ?? '',
        vehicleNo: Get.arguments["vehicleNo"] ?? '',
        lotNo: Get.arguments["lotNo"] ?? '',
        selectedPassId: Get.arguments["passId"] ?? '',
      ),
      binding: PayPendingPassScreenBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_HISTORY_SCREEN,
      page: () => const TransactionHistoryScreenView(),
      binding: TransactionHistoryScreenBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_HISTORY_DETAIL_SCREEN,
      page: () => const TransactionHistoryDetailScreenView(),
      binding: TransactionHistoryDetailScreenBinding(),
    ),
  ];
}
