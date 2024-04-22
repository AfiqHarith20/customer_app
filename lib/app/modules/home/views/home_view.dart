// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app/models/location_lat_lng.dart';
import 'package:customer_app/app/models/parking_model.dart';
import 'package:customer_app/app/modules/profile_screen/controllers/profile_screen_controller.dart';
import 'package:customer_app/app/routes/app_pages.dart';
import 'package:customer_app/app/widget/network_image_widget.dart';
import 'package:customer_app/constant/constant.dart';
import 'package:customer_app/themes/app_colors.dart';
import 'package:customer_app/themes/app_them_data.dart';
import 'package:customer_app/utils/fire_store_utils.dart';
import 'package:customer_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:place_picker/entities/entities.dart';
import '../controllers/home_controller.dart';
import 'carousel_loading.dart';
import 'carousel_slider_data_found.dart';

int _currentIndex = 0;

List<String> imagesList = [
  // 'assets/images/mpt_5_321.jpg',
  // 'assets/images/nazifa_ticketless.png',
  // 'assets/images/mpt_5_323.jpg',
  // 'assets/images/parking_machine.jpg',
];

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
  List<dynamic> items = [
    // {
    //   "des":
    //       "Timbalan Menteri Kerja Raya Datuk Seri Ahmad Maslan hari ini memberi bayangan pengumuman berkaitan tol sempena perayaan Krismas, berkemungkinan dibuat Jumaat ini.",
    //   "link":
    //       "https://loveandroid.medium.com/find-even-or-odd-without-using-conditions-loop-784463c6b187",
    //   "read": "1 min read",
    //   "title": "Pengumuman berkaitan tol sempena Krismas dijangka Jumaat ini",
    //   "pubDate": "Nov 1 2022",
    //   "categories": "Logical Programs"
    // },
    // {
    //   "des":
    //       "AWS Re-Invent 2023 masih diteruskan di las vegas dengan beberapa pengumuman kerjasama antara AWS dan syarikat Malaysia.\r\n\r\nAerodyne antara syarikat yang umum kerjasama dengan AWS bagi penggunaan perkhidmatan tertentu untuk pengembangan syarikat.\r\n\r\nEditor Astro AWANI, Najib Aroff Ada laporannya.",
    //   "link": "https://loveandroid.medium.com/happy-coding-d68e99cabebc",
    //   "read": "4 min read",
    //   "title": "Aerodyne kerjasama dengan AWS untuk penyelesaian dron",
    //   "pubDate": "Oct 29 2022",
    //   "categories": "Flutter"
    // },
    // {
    //   "des":
    //       "Ringgit ditutup rendah berbanding dolar AS apabila mata wang Amerika Syarikat (AS) itu kekal kukuh hampir di paras tertingginya dalam tempoh enam bulan menjelang pengumuman kadar beberapa bank utama d",
    //   "link": "https://loveandroid.medium.com/happy-coding-d68e99cabebc",
    //   "read": "4 min read",
    //   "title": "Ringgit ditutup rendah berbanding dolar AS",
    //   "pubDate": "Oct 29 2022",
    //   "categories": "Flutter"
    // },
    // {
    //   "des":
    //       "Lets see how to design Homepage in flutter which has appbar, bottomnavigatonbar and body which ",
    //   "link": "https://loveandroid.medium.com/happy-coding-d68e99cabebc",
    //   "read": "4 min read",
    //   "title": "Design Homepage in Flutter",
    //   "pubDate": "Oct 29 2022",
    //   "categories": "Flutter"
    // },
    // {
    //   "des":
    //       "Lets see how to design Homepage in flutter which has appbar, bottomnavigatonbar and body which ",
    //   "link": "https://loveandroid.medium.com/happy-coding-d68e99cabebc",
    //   "read": "4 min read",
    //   "title": "Design Homepage in Flutter",
    //   "pubDate": "Oct 29 2022",
    //   "categories": "Flutter"
    // }
  ];

  @override
  void initState() {
    super.initState();
    fetchCarouselImages(); // Fetch carousel images on initialization
    fetchInformation();
    //fetchMediumArticleItems();
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

  // void fetchMediumArticleItems() async {
  //   print("Fetch Started");
  //   const loadingUrl = "https://api.npoi/asdfaf";
  //   // final url = Uri.parse(loadingUrl);
  //   // final response = await http.get(url);
  //   // final body = response.body;
  //   // final json = jsonDecode(body);
  //   setState(() {
  //     items = [{
  //       "des": "We have to find binary number of the given value so far 2 it will be 10 , 3 → 11, 4 →100, 5 →101 so if you see its ends with 1 and 0 at last.",
  //       "link": "https://loveandroid.medium.com/find-even-or-odd-without-using-conditions-loop-784463c6b187",
  //       "read": "1 min read",
  //       "title": "Find Even or Odd without using Conditions Loop",
  //       "pubDate": "Nov 1 2022",
  //       "categories": "Logical Programs"
  //     }, {
  //     "des": "Lets see how to design Homepage in flutter which has appbar, bottomnavigatonbar and body which ",
  //     "link": "https://loveandroid.medium.com/happy-coding-d68e99cabebc",
  //     "read": "4 min read",
  //     "title": "Design Homepage in Flutter",
  //     "pubDate": "Oct 29 2022",
  //     "categories": "Flutter"
  //     }];
  //   });
  //   print("Fetch Completed");
  // }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
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
                          // Image.asset("assets/images/logo.png", height: 45, width: 45),
                          // const SizedBox(
                          //   width: 10,
                          // ),
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
                  body: Column(
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
                                'Hi, ${controller.customerModel.value.fullName}',
                                style: const TextStyle(
                                  fontFamily: AppThemData.bold,
                                  fontSize: 18,
                                  color: AppColors.darkGrey09,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                controller.customerModel.value.countryCode
                                        .toString() +
                                    controller.customerModel.value.phoneNumber
                                        .toString(),
                                //controller.customerModel.value.email.toString(),
                                style: const TextStyle(
                                  fontFamily: AppThemData.regular,
                                  color: AppColors.darkGrey06,
                                ),
                              ),
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
                                    amount: controller
                                            .customerModel.value.walletAmount
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        //apply padding to all four sides
                        child: Text(
                          'Information'.tr,
                          style: const TextStyle(
                            fontFamily: AppThemData.medium,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                          height: 250,
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
                                    borderRadius: BorderRadius.circular(30.0),
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
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        //apply padding to all four sides
                        child: Text(
                          'Latest News'.tr,
                          style: const TextStyle(
                            fontFamily: AppThemData.medium,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      // ListView
                      Expanded(
                        child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final itemData = items[index];
                              final title = itemData['title'];
                              final des = itemData['des'];
                              final date = itemData['pubDate'];
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          des,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              date,
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.blueGrey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
