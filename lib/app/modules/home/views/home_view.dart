// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/modules/notification_screen/controllers/notification_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';

int _currentIndex = 0;

List<String> imagesList = [];

final List<String> titles = [
  ' Coffee ',
  ' Bread ',
  ' Gelato ',
  ' Ice Cream ',
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchCarouselImages(); // Fetch carousel images on initialization
    fetchInformation();
  }

  void fetchCarouselImages() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('carousel')
              .orderBy('date', descending: true) // Order by 'date' descending
              .get();

      // Extract image URLs from documents in the 'carousel' collection
      List<String> urls = querySnapshot.docs
          .map((doc) => doc.data()['image'].toString())
          .toList();

      setState(() {
        imagesList = urls; // Update imagesList with fetched URLs
      });
    } catch (e) {
      print('Error fetching carousel images: $e');
    }
  }

  void fetchInformation() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('information')
              .where("active", isEqualTo: true)
              .get();

      List<dynamic> fetchedItems = querySnapshot.docs.map((doc) {
        return {
          "des": doc.data()['desc'].toString(),
          "link": doc.data()['link'].toString(),
          "read": doc.data()['read'].toString(),
          "title": doc.data()['title'].toString(),
          "pubDate": doc.data()['date'], // Store as dynamic
          "categories": doc.data()['categories'].toString(),
        };
      }).toList();
      fetchedItems.sort((a, b) {
        return b['pubDate'].compareTo(a['pubDate']);
      });
      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print('Error fetching information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationScreenController());
    return GetX<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: WillPopScope(
              onWillPop: () async {
                _exitApp();
                return true;
              },
              child: Scaffold(
                  backgroundColor: AppColors.lightGrey02,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: AppColors.yellow04,
                    surfaceTintColor: Colors.transparent,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            'NAZIFA PARKING'.tr,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: AppThemData.medium,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      FutureBuilder<bool>(
                        future: FireStoreUtils.isLogin(), // Fetch login status
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   // While the future is loading, you might want to show a loading indicator
                          //   return const CircularProgressIndicator(); // Replace with any loading widget you prefer
                          // }

                          if (snapshot.hasError) {
                            // Handle any error that might occur
                            return const SizedBox
                                .shrink(); // or display an error message
                          }

                          bool isLoggedIn =
                              snapshot.data ?? false; // Use the login status

                          return Visibility(
                            visible:
                                isLoggedIn, // Show the icon only if the user is logged in
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.NOTIFICATION_SCREEN);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16.0,
                                  top: 14,
                                ),
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_bell.svg",
                                      color: Colors.black,
                                      height: 30,
                                    ),
                                    Obx(() {
                                      final unreadCount =
                                          notificationController.unreadCount;
                                      if (unreadCount > 0) {
                                        return Positioned(
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              '$unreadCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    automaticallyImplyLeading: false,
                  ),
                  body: controller.isLoading.value
                      ? Constant.loader()
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                  ),
                                  color: AppColors.yellow04,
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'Hi, ${controller.customerModel.value.fullName ?? ''}',
                                        style: const TextStyle(
                                          fontFamily: AppThemData.bold,
                                          fontSize: 18,
                                          color: AppColors.darkGrey09,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.customerModel.value
                                                  .countryCode
                                                  ?.toString() ??
                                              '',
                                          style: const TextStyle(
                                            fontFamily: AppThemData.regular,
                                            color: AppColors.darkGrey06,
                                          ),
                                        ),
                                        Text(
                                          controller.customerModel.value
                                                  .phoneNumber
                                                  ?.toString() ??
                                              '',
                                          style: const TextStyle(
                                            fontFamily: AppThemData.regular,
                                            color: AppColors.darkGrey06,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  viewportFraction:
                                      0.8, // Adjust this to show partial items on the sides
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                ),
                                items: controller.carouselData.map((carousel) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Navigate to CarouselDetailScreen when tapped
                                      Get.toNamed(
                                        Routes.CAROUSEL_DETAIL_SCREEN,
                                        arguments: {
                                          'image': carousel.image,
                                          'title': carousel.title,
                                          'desc': carousel.desc,
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        margin: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                        ),
                                        elevation: 6.0,
                                        shadowColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          child: Image.network(
                                            carousel.image!,
                                            fit: BoxFit
                                                .fill, // Change this to scale down the image
                                            width:
                                                null, // Remove double.infinity to let the image set its width
                                            height:
                                                null, // Remove double.infinity to let the image set its height
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imagesList.map((urlOfItem) {
                                  int index = imagesList.indexOf(urlOfItem);
                                  return Container(
                                    width: 10.0,
                                    height: 10.0,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentIndex == index
                                          ? const Color.fromRGBO(0, 0, 0, 0.8)
                                          : const Color.fromRGBO(0, 0, 0, 0.3),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Latest News'.tr,
                                      style: const TextStyle(
                                        fontFamily: AppThemData.medium,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to the news screen
                                        Get.toNamed(Routes.NEWS_SCREEN);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'More News'.tr,
                                            style: const TextStyle(
                                              fontFamily: AppThemData.medium,
                                              color: AppColors.darkGrey04,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          const Icon(
                                            Icons.newspaper,
                                            color: AppColors.darkGrey04,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  items.length > 5 ? 5 : items.length,
                                  (index) {
                                    final itemData = items[index];
                                    final title = itemData['title'] as String?;
                                    final pubDate = itemData['pubDate'];
                                    final des = itemData['des'];
                                    return GestureDetector(
                                      onTap: () {
                                        final titleValue = title ?? '';
                                        final desValue = des ?? '';
                                        final dateValue = pubDate;

                                        Get.toNamed(
                                          Routes.NEWS_DETAIL_SCREEN,
                                          arguments: {
                                            'title': titleValue,
                                            'des': desValue,
                                            'date': dateValue,
                                          },
                                        );
                                      },
                                      child: Card(
                                        elevation: 4,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        title ?? '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              AppThemData.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            8), // Add some spacing between title and pubDate
                                                    Text(
                                                      Constant.timestampToDate(
                                                          pubDate),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  des ?? '',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    color: AppColors.darkGrey07,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
            ),
          );
        });
  }

  void _exitApp() {
    SystemNavigator.pop(); // This will close the app
  }

  String formatDate(dynamic date) {
    try {
      DateTime dateTime;
      if (date is Timestamp) {
        dateTime = date.toDate();
      } else if (date is String) {
        dateTime = DateTime.parse(date);
      } else {
        return ''; // Handle unexpected date type
      }
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return ''; // Return empty string if parsing fails
    }
  }
}
