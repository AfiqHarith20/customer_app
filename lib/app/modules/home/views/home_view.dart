import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

int _currentIndex = 0;

List<String> imagesList = [];

final List<String> titles = [
  ' Coffee ',
  ' Bread ',
  ' Gelato ',
  ' Ice Cream ',
];

final List<String> listViewItems = [
  'List Item 1',
  'List Item 2',
  'List Item 3',
  'List Item 4',
  'List Item 5',
];

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

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
          await FirebaseFirestore.instance.collection('carousel').get();

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
          await FirebaseFirestore.instance.collection('information').get();

      List<dynamic> fetchedItems = querySnapshot.docs.map((doc) {
        return {
          "des": doc.data()['desc'].toString(),
          "link": doc.data()['link'].toString(),
          "read": doc.data()['read'].toString(),
          "title": doc.data()['title'].toString(),
          "pubDate": doc.data()['date'].toString(),
          "categories": doc.data()['categories'].toString(),
        };
      }).toList();

      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print('Error fetching information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
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
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.NOTIFICATION_SCREEN);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16.0,
                          top: 10,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/ic_bell.svg",
                          color: Colors.black,
                        ),
                      ),
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
                              height: 90,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.customerModel.value != null
                                            ? controller
                                                .customerModel.value.countryCode
                                                .toString()
                                            : '',
                                        style: const TextStyle(
                                          fontFamily: AppThemData.regular,
                                          color: AppColors.darkGrey06,
                                        ),
                                      ),
                                      Text(
                                        controller.customerModel.value != null
                                            ? controller
                                                .customerModel.value.phoneNumber
                                                .toString()
                                            : '',
                                        style: const TextStyle(
                                          fontFamily: AppThemData.regular,
                                          color: AppColors.darkGrey06,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/ic_wallet.svg",
                                        height: 25,
                                        width: 25,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Constant.amountShow(
                                          amount: controller.customerModel.value
                                                  .walletAmount
                                                  ?.toString() ??
                                              '0',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
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
                                enlargeCenterPage: false,
                                scrollDirection: Axis.horizontal,
                                height: 220,
                                onPageChanged: (index, reason) {
                                  setState(
                                    () {
                                      _currentIndex = index;
                                    },
                                  );
                                },
                              ),
                              items: imagesList
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        margin: const EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        elevation: 6.0,
                                        shadowColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.network(
                                                item,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
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
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Latest News'.tr,
                                    style: const TextStyle(
                                      fontFamily: AppThemData.medium,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.darkGrey04,
                                            fontSize: 18,
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
                                  final pubDate =
                                      itemData['pubDate'] as String?;
                                  final des = itemData['des'];
                                  return GestureDetector(
                                    onTap: () {
                                      final titleValue = title ?? '';
                                      final desValue = des ?? '';
                                      final dateValue = pubDate ?? '';

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
                                        horizontal: 16,
                                        vertical: 3,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '$pubDate',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   itemCount: listViewItems.length,
                            //   itemBuilder: (context, index) {
                            //     return Padding(
                            //       padding: const EdgeInsets.all(10.0),
                            //       child: Container(
                            //         color: Colors.white,
                            //         child: ListTile(
                            //           leading: CircleAvatar(
                            //             backgroundColor: AppColors
                            //                 .yellow04, // Adjust the color as needed
                            //             child: Text(
                            //               (index + 1).toString(),
                            //               style: const TextStyle(
                            //                 color: Colors.black,
                            //                 fontFamily: AppThemData.bold,
                            //               ),
                            //             ),
                            //           ),
                            //           title: Text(
                            //             listViewItems[index],
                            //             style: const TextStyle(
                            //               color: Colors.black,
                            //               fontFamily: AppThemData.medium,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //           ),
                            //           subtitle: const Text(
                            //             'Description',
                            //             style: TextStyle(
                            //               color: Colors.black54,
                            //               fontFamily: AppThemData.regular,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      )),
          );
        });
  }
}
