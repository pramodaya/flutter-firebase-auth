import 'dart:typed_data';
import 'dart:ui';
import 'package:best_flutter_ui_templates/hotel_booking/model/hotel_list_data.dart';
import 'package:best_flutter_ui_templates/hotel_booking/item_detail.dart';
import 'package:best_flutter_ui_templates/login/welcome_screen.dart';
import 'package:best_flutter_ui_templates/model/product.dart';
import 'package:best_flutter_ui_templates/model/salon.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../app_theme.dart';
import 'hotel_app_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HotelHomeScreen extends StatefulWidget {
  static const String id = 'salon_home_screen_hotel';
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  //set image
  String imgUrl;
  final _firestorage = FirebaseStorage.instance;
  final FirebaseStorage storage = FirebaseStorage(
      app: Firestore.instance.app,
      storageBucket: 'gs://kalonish-21fb1.appspot.com');
  Uint8List imageBytes;
  String errorMsg;

  var _salonPariList = <Salon>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _itemFetcher = _ItemFetcher();
  var salonCount = 0;
  var _searchValue = "";

  bool _isLoading = true;
  bool _hasMore = true;

  AnimationController animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  final ScrollController _scrollController = ScrollController();
  bool isSearching = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _isLoading = true;
    _hasMore = true;
    getFilterBarUI(salonCount);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.black,
          gradient: new LinearGradient(
            colors: [
              AppTheme.gradientColor1,
              AppTheme.gradientColor2,
              AppTheme.gradientColor3,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    AppBar(
                      centerTitle: true,
                      title: Text(
                        'APP TITLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.black,
                          padding: const EdgeInsets.only(top: 10.0),
                          onPressed: () {
                            setState(() {});
                          },
                          iconSize: 30,
                        )
                      ],
                    ),
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      height: 10.0,
                                      width: MediaQuery.of(context).size.width,
                                      color: AppTheme.gradientColor2,
                                    ),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                          ];
                        },
                        body: Container(
                          decoration: new BoxDecoration(
                            color: Colors.black,
                            gradient: new LinearGradient(
                              colors: [
                                AppTheme.gradientColor1,
                                AppTheme.gradientColor2,
                                AppTheme.gradientColor3,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                          // color:
                          //     HotelAppTheme.buildLightTheme().backgroundColor,
                          child: salonCount == 0
                              ? Center(child: Text('No data found '))
                              : ListView.builder(
                                  // Need to display a loading tile if more items are coming
                                  itemCount: _salonPariList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (_salonPariList.length > 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24,
                                            right: 24,
                                            top: 8,
                                            bottom: 16),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            print('direct to item detail page');

                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ItemDetailPage(
                                                            "WonderWorld",
                                                            _salonPariList[
                                                                index])));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  offset: const Offset(4, 4),
                                                  blurRadius: 16,
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16.0)),
                                              child: Stack(
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      AspectRatio(
                                                        aspectRatio: 3,
                                                        child: Image.network(
                                                          _salonPariList[index]
                                                              .salonImg1,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                          color: HotelAppTheme
                                                                  .buildLightTheme()
                                                              .backgroundColor,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        top: 8,
                                                                        bottom:
                                                                            8),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          _salonPariList[index]
                                                                              .salonName,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                22,
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              FontAwesomeIcons.mapMarkerAlt,
                                                                              size: 12,
                                                                              color: HotelAppTheme.buildLightTheme().primaryColor,
                                                                            ),
                                                                            Text(
                                                                              _salonPariList[index].streetAddress1,
                                                                              style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                _salonPariList[index].streetAddress2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 4),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              SmoothStarRating(
                                                                                allowHalfRating: true,
                                                                                starCount: 5,
                                                                                rating: 3,
                                                                                size: 20,
                                                                                color: HotelAppTheme.buildLightTheme().primaryColor,
                                                                                borderColor: HotelAppTheme.buildLightTheme().primaryColor,
                                                                              ),
                                                                              Text(
                                                                                '434 Reviews',
                                                                                style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            16,
                                                                        top: 8),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: <
                                                                      Widget>[
                                                                    // Text(
                                                                    //   '\$200',
                                                                    //   textAlign:
                                                                    //       TextAlign
                                                                    //           .left,
                                                                    //   style: TextStyle(
                                                                    //     fontWeight:
                                                                    //         FontWeight
                                                                    //             .w600,
                                                                    //     fontSize: 22,
                                                                    //   ),
                                                                    // ),
                                                                    Text(
                                                                      'More >>',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.8)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                    top: 8,
                                                    right: 8,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(32.0),
                                                        ),
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons
                                                                .favorite_border,
                                                            color: HotelAppTheme
                                                                    .buildLightTheme()
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose date',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI(int salonCounts) {
    print('total salon count $salonCounts');
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: AppTheme.gradientColor2,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$salonCounts salons found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      // FocusScope.of(context).requestFocus(FocusNode());
                      // Navigator.push<dynamic>(
                      //   context,
                      //   MaterialPageRoute<dynamic>(
                      //       builder: (BuildContext context) => FiltersScreen(),
                      //       fullscreenDialog: true),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort, color: Colors.grey),
                            // color: HotelAppTheme.buildLightTheme()
                            //     .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }
}

class _ItemFetcher {
  final _firestore = Firestore.instance;
  // This async function simulates fetching results from Internet, etc.
  Future<List<Salon>> fetch({String searchValue = ""}) async {
    var salonList = <Salon>[];

    var salonListResponse;
    //store local storage

    if (searchValue == "") {
      salonListResponse = await _firestore.collection('salon').getDocuments();
    } else {
      salonListResponse = await _firestore
          .collection('salon')
          .where('cityCapital', isEqualTo: searchValue)
          .getDocuments();
    }

    if (salonListResponse.documents.length > 0) {
      for (var i = 0; i < salonListResponse.documents.length; i++) {
        Salon salon = Salon();
        List<Product> productList = [];
        var docId = salonListResponse.documents[i].documentID;
        salon.salonDocId = docId;
        salon.description = salonListResponse.documents[i].data['description'];
        salon.hotline = salonListResponse.documents[i].data['hotline'];
        salon.salonName = salonListResponse.documents[i].data['salonName'];
        salon.streetAddress1 =
            salonListResponse.documents[i].data['streetAddress1'];
        salon.streetAddress2 =
            salonListResponse.documents[i].data['streetAddress2'];

        // salon.salonImagesList =
        //     salonListResponse.documents[i].data['salonImages'][0];

        salon.salonImg1 = salonListResponse.documents[i].data['salonImages'][0];
        salon.salonImg2 = salonListResponse.documents[i].data['salonImages'][1];
        salon.salonImg3 = salonListResponse.documents[i].data['salonImages'][2];
        salon.salonImg4 = salonListResponse.documents[i].data['salonImages'][3];
        salon.salonImg5 = salonListResponse.documents[i].data['salonImages'][4];
        //get salon's first image url
        // var productCount = int.parse(
        //     salonListResponse.documents[i].data['categoryImageCount']);
        try {
          for (int j = 0; j < 5; j++) {
            var intNum = j + 1;
            var imgKey = 'productImage$intNum';

            var productLength =
                salonListResponse.documents[i].data[imgKey].length;
            if (productLength > 0) {
              Product p = Product(
                category: salonListResponse.documents[i].data[imgKey][0],
                name: salonListResponse.documents[i].data[imgKey][1],
                price: salonListResponse.documents[i].data[imgKey][2],
                img: salonListResponse.documents[i].data[imgKey][3],
              );

              productList.add(p);
            }
          }

          salon.productList = productList;
        } catch (ex) {
          print('error');
        }
        salonList.add(salon);
      }
    }
    var k = salonList;
    print(salonList.length);
    return salonList;
  }
}
