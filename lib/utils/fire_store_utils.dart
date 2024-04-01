import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/admin_commission.dart';
import 'package:customer_app/app/models/booking_model.dart';
import 'package:customer_app/app/models/contact_us_model.dart';
import 'package:customer_app/app/models/coupon_model.dart';
import 'package:customer_app/app/models/currency_model.dart';
import 'package:customer_app/app/models/customer_model.dart';
import 'package:customer_app/app/models/language_model.dart';
import 'package:customer_app/app/models/my_purchase_pass_private_model.dart';
import 'package:customer_app/app/models/owner_model.dart';
import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/app/models/payment_method_model.dart';
import 'package:customer_app/app/models/private_pass_model.dart';
import 'package:customer_app/app/models/referral_model.dart';
import 'package:customer_app/app/models/review_model.dart';
import 'package:customer_app/app/models/tax_model.dart';
import 'package:customer_app/app/models/wallet_transaction_model.dart';
import 'package:customer_app/app/models/watchman_model.dart';
import 'package:customer_app/constant/collection_name.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import '../app/models/carousel_model.dart';
import '../app/models/my_purchase_pass_model.dart';
import '../app/models/season_pass_model.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.customers).doc(uid).get().then(
      (value) {
        if (value.exists) {
          Constant.customerName = value.data()!['fullName'];
          isExist = true;
        } else {
          isExist = false;
        }
      },
    ).catchError((error) {
      log("Failed to check user exist: $error");
      isExist = false;
    });
    return isExist;
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = await userExistOrNot(FirebaseAuth.instance.currentUser!.uid);
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static Future<CustomerModel?> getUserProfile(String uuid) async {
    CustomerModel? customerModel;

    await fireStore
        .collection(CollectionName.customers)
        .doc(uuid)
        .get()
        .then((value) {
      if (value.exists) {
        customerModel = CustomerModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      customerModel = null;
    });
    return customerModel;
  }

  static Future<OwnerModel?> getOwnerProfile(String uuid) async {
    OwnerModel? ownerModel;

    await fireStore
        .collection(CollectionName.owners)
        .doc(uuid)
        .get()
        .then((value) {
      if (value.exists) {
        ownerModel = OwnerModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      ownerModel = null;
    });
    return ownerModel;
  }

  static Future<WatchManModel?> getWatchManProfile(String parkingId) async {
    WatchManModel? watchManModel;

    await fireStore
        .collection(CollectionName.watchmans)
        .where("parkingId", isEqualTo: parkingId)
        .get()
        .then((value) {
      if (value.docs.first.exists) {
        watchManModel = WatchManModel.fromJson(value.docs.first.data());
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      watchManModel = null;
    });
    return watchManModel;
  }

  Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;
    await fireStore
        .collection(CollectionName.currencies)
        .where("active", isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(value.docs.first.data());
      }
    });
    return currencyModel;
  }

  static Future<List<CouponModel>?> getCoupon() async {
    List<CouponModel> couponList = [];
    await fireStore
        .collection(CollectionName.coupon)
        .where("active", isEqualTo: true)
        .where("isPrivate", isEqualTo: false)
        .where('expireAt', isGreaterThanOrEqualTo: Timestamp.now())
        .get()
        .then((value) {
      for (var element in value.docs) {
        CouponModel couponModel = CouponModel.fromJson(element.data());
        couponList.add(couponModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return couponList;
  }

  Future<List<TaxModel>?> getTaxList() async {
    List<TaxModel> taxList = [];

    await fireStore
        .collection(CollectionName.countryTax)
        .where('country', isEqualTo: Constant.country)
        .where('active', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        TaxModel taxModel = TaxModel.fromJson(element.data());
        taxList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return taxList;
  }

  static Future<bool?> checkReferralCodeValidOrNot(String referralCode) async {
    bool? isExit;
    try {
      await fireStore
          .collection(CollectionName.referral)
          .where("referralCode", isEqualTo: referralCode)
          .get()
          .then((value) {
        if (value.size > 0) {
          isExit = true;
        } else {
          isExit = false;
        }
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return false;
    }
    return isExit;
  }

  static Future<ReferralModel?> getReferralUserByCode(
      String referralCode) async {
    ReferralModel? referralModel;
    try {
      await fireStore
          .collection(CollectionName.referral)
          .where("referralCode", isEqualTo: referralCode)
          .get()
          .then((value) {
        referralModel = ReferralModel.fromJson(value.docs.first.data());
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return null;
    }
    return referralModel;
  }

  static Future<ReferralModel?> getReferral() async {
    ReferralModel? referralModel;
    await fireStore
        .collection(CollectionName.referral)
        .doc(FireStoreUtils.getCurrentUid())
        .get()
        .then((value) {
      if (value.exists) {
        referralModel = ReferralModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      referralModel = null;
    });
    return referralModel;
  }

  static Future<bool?> setWalletTransaction(
      WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.walletTransaction)
        .doc(walletTransactionModel.id)
        .set(walletTransactionModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> updateUserWallet({required String amount}) async {
    bool isAdded = false;
    await getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
      if (value != null) {
        CustomerModel customerModel = value;
        customerModel.walletAmount =
            (double.parse(customerModel.walletAmount.toString()) +
                    double.parse(amount))
                .toString();
        await FireStoreUtils.updateUser(customerModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool?> updateOtherUserWallet(
      {required String amount, required String id}) async {
    bool isAdded = false;
    await getOwnerProfile(id).then((value) async {
      if (value != null) {
        OwnerModel ownerModel = value;
        ownerModel.walletAmount =
            (double.parse(ownerModel.walletAmount.toString()) +
                    double.parse(amount))
                .toString();
        await FireStoreUtils.updateOwner(ownerModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> languageList = [];

    await fireStore
        .collection(CollectionName.languages)
        .where("active", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        LanguageModel languageModel = LanguageModel.fromJson(element.data());
        languageList.add(languageModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return languageList;
  }

  static Future<bool> getFirstOrderOrNOt(BookingModel bookingModel) async {
    bool isFirst = true;
    await fireStore
        .collection(CollectionName.bookParkingOrder)
        .where('customerId', isEqualTo: bookingModel.customerId)
        .get()
        .then((value) {
      log(":::Value Size: ${value.size}");
      if (value.size == 1) {
        isFirst = true;
      } else {
        isFirst = false;
      }
    });
    return isFirst;
  }

  static Future<bool?> setOrder(BookingModel bookingModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.bookParkingOrder)
        .doc(bookingModel.id)
        .set(bookingModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    await fireStore
        .collection(CollectionName.settings)
        .doc("payment")
        .get()
        .then((value) {
      paymentModel = PaymentModel.fromJson(value.data()!);
    });
    return paymentModel;
  }

  static Future updateReferralAmount(BookingModel bookingModel) async {
    ReferralModel? referralModel;
    await fireStore
        .collection(CollectionName.referral)
        .doc(bookingModel.customerId)
        .get()
        .then((value) {
      if (value.data() != null) {
        referralModel = ReferralModel.fromJson(value.data()!);
      } else {
        return;
      }
    });
    if (referralModel != null) {
      if (referralModel!.referralBy != null &&
          referralModel!.referralBy!.isNotEmpty) {
        await fireStore
            .collection(CollectionName.customers)
            .doc(referralModel!.referralBy)
            .get()
            .then((value) async {
          DocumentSnapshot<Map<String, dynamic>> userDocument = value;
          if (userDocument.data() != null && userDocument.exists) {
            try {
              log(userDocument.data().toString());
              CustomerModel user = CustomerModel.fromJson(userDocument.data()!);
              user.walletAmount = (double.parse(user.walletAmount.toString()) +
                      double.parse(Constant.referralAmount.toString()))
                  .toString();
              updateUser(user);
              WalletTransactionModel transactionModel = WalletTransactionModel(
                  id: Constant.getUuid(),
                  amount: Constant.referralAmount.toString(),
                  createdDate: Timestamp.now(),
                  paymentType: "Wallet",
                  isCredit: true,
                  type: "Wallet",
                  transactionId: bookingModel.id,
                  userId: user.id.toString(),
                  note: "Referral Amount");

              await FireStoreUtils.setWalletTransaction(transactionModel);
            } catch (error) {
              if (kDebugMode) {
                print(error);
              }
            }
          }
        });
      } else {
        return;
      }
    }
  }

  static Future<String?> referralAdd(ReferralModel ratingModel) async {
    try {
      await fireStore
          .collection(CollectionName.referral)
          .doc(ratingModel.id)
          .set(ratingModel.toJson());
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return null;
    }
    return null;
  }

  static Future<bool> updateUser(CustomerModel customerModel) async {
    bool isUpdate = false;
    await fireStore
        .collection(CollectionName.customers)
        .doc(customerModel.id)
        .set(customerModel.toJson())
        .whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> deleteUser() async {
    bool isDelete = false;
    await fireStore
        .collection(CollectionName.customers)
        .doc(getCurrentUid())
        .delete()
        .then((value) {
      isDelete = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isDelete = false;
    });
    return isDelete;
  }

  static Future<bool> updateOwner(OwnerModel ownerModel) async {
    bool isUpdate = false;
    await fireStore
        .collection(CollectionName.owners)
        .doc(ownerModel.id)
        .set(ownerModel.toJson())
        .whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  getSettings() async {
    await fireStore
        .collection(CollectionName.settings)
        .doc("constant")
        .get()
        .then((value) {
      if (value.exists) {
        Constant.radius = value.data()!["radius"] ?? "50";
        Constant.notificationServerKey =
            value.data()!["notification_server_key"] ?? "";
        Constant.minimumAmountToDeposit =
            value.data()!["minimum_amount_deposit"] ?? "100";
        Constant.termsAndConditions = value.data()!["termsAndConditions"] ?? "";
        Constant.privacyPolicy = value.data()!["privacyPolicy"] ?? "";
        Constant.supportEmail = value.data()!["supportEmail"] ?? "";
        Constant.supportURL = value.data()!["supportURL"] ?? "";
        Constant.googleMapKey = value.data()!["googleMapKey"] ?? "";
        Constant.plateRecognizerApiToken =
            value.data()!["plateRecognizerApiToken"] ?? "";
      }
    });

    await fireStore
        .collection(CollectionName.settings)
        .doc("admin_commission")
        .get()
        .then((value) {
      Constant.adminCommission = AdminCommission.fromJson(value.data()!);
    });

    await fireStore
        .collection(CollectionName.settings)
        .doc("referral_setting")
        .get()
        .then((value) {
      Constant.referralAmount = value.data()!["amount"] ?? "0";
      log(Constant.referralAmount.toString());
    });
  }

  static Future<ParkingModel?> getParkingDetail(String id) async {
    ParkingModel? parkingModel;
    await fireStore
        .collection(CollectionName.parkings)
        .doc(id)
        .get()
        .then((value) {
      parkingModel = ParkingModel.fromJson(value.data()!);
    }).catchError((e) {
      log("Failed to get data");
    });
    return parkingModel;
  }

  static Future<ReviewModel?> getReview(String orderId) async {
    ReviewModel? reviewModel;
    await fireStore
        .collection(CollectionName.review)
        .doc(orderId)
        .get()
        .then((value) {
      if (value.data() != null) {
        reviewModel = ReviewModel.fromJson(value.data()!);
      }
    });
    return reviewModel;
  }

  static Future<bool?> setReview(ReviewModel reviewModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.review)
        .doc(reviewModel.id)
        .set(reviewModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<ParkingModel>?> getParkingList() async {
    List<ParkingModel> parkingModelList = [];
    await fireStore
        .collection(CollectionName.parkings)
        .where("active", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        ParkingModel parkingModel = ParkingModel.fromJson(element.data());
        parkingModelList.add(parkingModel);
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return parkingModelList;
  }

  static Future<List<ParkingModel>?> getLikedParkingList() async {
    List<ParkingModel> parkingModelList = [];
    await fireStore
        .collection(CollectionName.parkings)
        .where("likedUser", arrayContains: getCurrentUid())
        .get()
        .then((value) {
      for (var element in value.docs) {
        ParkingModel parkingModel = ParkingModel.fromJson(element.data());
        parkingModelList.add(parkingModel);
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return parkingModelList;
  }

  static Future saveParkingDetails(ParkingModel parkingModel) async {
    await fireStore
        .collection(CollectionName.parkings)
        .doc(parkingModel.id)
        .set(parkingModel.toJson())
        .catchError((error) {
      log("Failed to update parkingList: $error");
      return null;
    });
    return null;
  }

  static Future<ContactUsModel?> getContactUsInformation() async {
    ContactUsModel? contactUsModel;
    await fireStore
        .collection(CollectionName.settings)
        .doc('contact_us')
        .get()
        .then((value) {
      contactUsModel = ContactUsModel.fromJson(value.data()!);
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return contactUsModel;
  }

  StreamController<List<ParkingModel>>? getNearestParkingRequestController;

  Stream<List<ParkingModel>> getParkingNearest(
      {double? latitude, double? longLatitude}) async* {
    getNearestParkingRequestController =
        StreamController<List<ParkingModel>>.broadcast();
    List<ParkingModel> parkingList = [];
    Query query = fireStore
        .collection(CollectionName.parkings)
        .where("active", isEqualTo: true);

    GeoFirePoint center = GeoFlutterFire()
        .point(latitude: latitude ?? 0.0, longitude: longLatitude ?? 0.0);

    Stream<List<DocumentSnapshot>> stream = GeoFlutterFire()
        .collection(collectionRef: query)
        .within(
            center: center,
            radius: double.parse(Constant.radius),
            field: 'position',
            strictMode: true);

    stream.listen((List<DocumentSnapshot> documentList) {
      parkingList.clear();
      for (var document in documentList) {
        final data = document.data() as Map<String, dynamic>;
        ParkingModel orderModel = ParkingModel.fromJson(data);
        parkingList.add(orderModel);
      }
      getNearestParkingRequestController!.sink.add(parkingList);
    });

    yield* getNearestParkingRequestController!.stream;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModel = [];

    await fireStore
        .collection(CollectionName.walletTransaction)
        .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        WalletTransactionModel taxModel =
            WalletTransactionModel.fromJson(element.data());
        walletTransactionModel.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return walletTransactionModel;
  }

  static Future<bool?> setPurchasePass(
      MyPurchasePassModel purchasePassModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.purchasePass)
        .doc(purchasePassModel.id)
        .set(purchasePassModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<SeasonPassModel>?> getSeasonPassData() async {
    List<SeasonPassModel> seasonPassList = [];
    await fireStore
        .collection(CollectionName.seasonPass)
        .where('userType', isEqualTo: 'Customer')
        .get()
        .then((value) {
      for (var element in value.docs) {
        SeasonPassModel seasonPassModel =
            SeasonPassModel.fromJson(element.data());
        print('${element['passName']}');
        seasonPassList.add(seasonPassModel);
        print('-------length----->${seasonPassList.length}');
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return seasonPassList;
  }

  static Future<List<PrivatePassModel>?> getPrivatePassData() async {
    List<PrivatePassModel> privatePassList = [];
    await fireStore
        .collection(CollectionName.privatePass)
        .where('userType', isEqualTo: 'Customer')
        .get()
        .then((value) {
      for (var element in value.docs) {
        PrivatePassModel privatePassModel =
            PrivatePassModel.fromJson(element.data());
        print('${element['passName']}');
        privatePassList.add(privatePassModel);
        print('-------length----->${privatePassList.length}');
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return privatePassList;
  }

  static Future<List<MyPurchasePassModel>?> getMySeasonPassData() async {
    List<MyPurchasePassModel> mySeasonPassList = [];
    await fireStore
        .collection(CollectionName.purchasePass)
        .where('customerId', isEqualTo: getCurrentUid())
        .get()
        .then((value) {
      for (var element in value.docs) {
        MyPurchasePassModel mySeasonPassModel =
            MyPurchasePassModel.fromJson(element.data());
        mySeasonPassList.add(mySeasonPassModel);
        print('-------length----->${mySeasonPassList.length}');
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return mySeasonPassList;
  }

  static Future<List<MyPurchasePassPrivateModel>?>
      getMyPrivatePassData() async {
    List<MyPurchasePassPrivateModel> myPrivatePassList = [];
    await fireStore
        .collection(CollectionName.purchasePass)
        .where('customerId', isEqualTo: getCurrentUid())
        .get()
        .then((value) {
      for (var element in value.docs) {
        MyPurchasePassPrivateModel myPrivatePassModel =
            MyPurchasePassPrivateModel.fromJson(element.data());
        myPrivatePassList.add(myPrivatePassModel);
        print('-------length----->${myPrivatePassList.length}');
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return myPrivatePassList;
  }

  static Future<List<CarouselModel>?> getCarousel() async {
    List<CarouselModel> carouselData = [];
    await fireStore
        .collection(CollectionName.carousel)
        .where("active", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        CarouselModel carouselModel = CarouselModel.fromJson(element.data());
        carouselData.add(carouselModel);
        print('-------length----->${carouselData.length}');
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return carouselData;
  }
}
