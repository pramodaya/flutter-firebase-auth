import 'dart:io';
import 'dart:ui';
import 'package:best_flutter_ui_templates/hotel_booking/salon_list_view.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/hotel_list_data.dart';
import 'package:best_flutter_ui_templates/hotel_booking/model/salon_service_list.dart';
import 'package:best_flutter_ui_templates/hotel_booking/item_detail.dart';
import 'package:best_flutter_ui_templates/login/welcome_screen.dart';
import 'package:best_flutter_ui_templates/model/product.dart';
import 'package:best_flutter_ui_templates/model/salon.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import 'hotel_app_theme.dart';

class ItemDetailPage extends StatefulWidget {
  static const String id = 'salon_home_screen_hotel';
  final String salonId;
  final Salon salonObj;
  const ItemDetailPage(this.salonId, this.salonObj);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage>
    with TickerProviderStateMixin {
  String key = "";
  AnimationController animationController;
  List<SalonServiceListData> salonServiceList =
      SalonServiceListData.salonServiceList;
  final ScrollController _scrollController = ScrollController();
  bool isSearching = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  List salonImagesList = [];
  List productImagesList = [];
  List<Product> finalSalonList = [];
  String userFirstName;
  String userLastName;
  String userNic;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    print(widget.salonId);
    getUserData();

    setState(() {
      for (var i = 0; i < widget.salonObj.productList.length; i++) {
        Product _product = Product(
          name: widget.salonObj.productList[i].name,
          category: widget.salonObj.productList[i].category,
          price: widget.salonObj.productList[i].price,
          img: widget.salonObj.productList[i].img,
        );
        finalSalonList.add(_product);
      }
    });
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userFirstName = prefs.getString('fistName');
    userLastName = prefs.getString('lastName');
    userNic = prefs.getString('nic');
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

  _textFunc(String hotline, String product, String firstName, String lastName,
      String nic) async {
    // Android
    if (Platform.isAndroid) {
      var uri =
          'sms:$hotline?body=Book-%20$product-%20$firstName-%20$lastName-%20$nic';
      await launch(uri);
    } else if (Platform.isIOS) {
      // iOS
      const uri = 'sms:0039-222-060-888&body=hello%20there';
      await launch(uri);
    }
  }

  void _callFunc(telephoneNum) async {
    await launch('tel:$telephoneNum');
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
                      title: Text(
                        widget.salonObj.salonName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      automaticallyImplyLeading: true,
                      iconTheme: IconThemeData(
                        color: Colors.black, //change your color here
                      ),
                      actions: <Widget>[
                        // Icon(
                        //   Icons.star,
                        //   color: Colors.pink[300],
                        // ),
                        // Text('41   '),
                        // SizedBox(),
                        IconButton(
                          icon: Icon(Icons.call),
                          color: Colors.black,
                          onPressed: () {
                            _callFunc(widget.salonObj.hotline);
                          },
                          iconSize: 30,
                        ),
                      ],
                    ),
                    // getAppBarUI()
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Container(
                                  color: AppTheme.gradientColor2,
                                  child: Column(
                                    children: <Widget>[
                                      // getSearchBarUI(),
                                      // getTimeDateUI(),
                                      SizedBox(
                                          height: 130.0,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Carousel(
                                            images: [
                                              NetworkImage(
                                                  widget.salonObj.salonImg1),
                                              NetworkImage(
                                                  widget.salonObj.salonImg2),
                                              NetworkImage(
                                                  widget.salonObj.salonImg3),
                                              NetworkImage(
                                                  widget.salonObj.salonImg4),
                                              NetworkImage(
                                                  widget.salonObj.salonImg5),
                                            ],
                                            dotSize: 4.0,
                                            dotSpacing: 15.0,
                                            dotColor: Colors.white,
                                            indicatorBgPadding: 3.0,
                                            dotBgColor: AppTheme.gradientColor2,
                                            // Colors.pink.withOpacity(0.5),
                                            borderRadius: false,
                                            defaultImage: 0,
                                          )),
                                      getTitleSection(widget.salonObj),
                                    ],
                                  ),
                                );
                              }, childCount: 1),
                            ),
                            // SliverPersistentHeader(
                            //   pinned: true,
                            //   floating: true,
                            //   delegate: ContestTabHeader(
                            //       // getFilterBarUI(),
                            //       ),
                            // ),
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
                          child: ListView.builder(
                            itemCount: widget.salonObj.productList.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 8,
                                        bottom: 16),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        print('direct to item detail page');
                                        Navigator.pushNamed(
                                            context, ItemDetailPage.id);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              offset: const Offset(4, 4),
                                              blurRadius: 16,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0)),
                                          child: Stack(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  AspectRatio(
                                                    aspectRatio: 3,
                                                    child: Image.network(
                                                      finalSalonList[index].img,
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
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        top: 8,
                                                                        bottom:
                                                                            8),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      finalSalonList[
                                                                              index]
                                                                          .name,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
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
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          finalSalonList[index]
                                                                              .category,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.grey.withOpacity(0.8)),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              4),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          SmoothStarRating(
                                                                            allowHalfRating:
                                                                                true,
                                                                            starCount:
                                                                                5,
                                                                            rating:
                                                                                3,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                HotelAppTheme.buildLightTheme().primaryColor,
                                                                            borderColor:
                                                                                HotelAppTheme.buildLightTheme().primaryColor,
                                                                          ),
                                                                          Text(
                                                                            '434 Reviews',
                                                                            style:
                                                                                TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
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
                                                                    right: 16,
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
                                                                Text(
                                                                  '\Rs ${finalSalonList[index].price}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        22,
                                                                  ),
                                                                ),
                                                                RaisedButton(
                                                                  onPressed:
                                                                      () {
                                                                    // sendSMS(
                                                                    //     'sms:+94762115926');
                                                                    _textFunc(
                                                                        widget
                                                                            .salonObj
                                                                            .hotline,
                                                                        finalSalonList[index]
                                                                            .name,
                                                                        userFirstName,
                                                                        userLastName,
                                                                        userNic);
                                                                  },
                                                                  color: AppTheme
                                                                      .btnColor,
                                                                  child: Text(
                                                                      'Book'),
                                                                  textColor:
                                                                      Colors
                                                                          .black,
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
                                                        const BorderRadius.all(
                                                      Radius.circular(32.0),
                                                    ),
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.favorite_border,
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
                                  ),
                                ],
                              );
                            },
                          ),
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

  Widget showBookDate() {
    return AlertDialog(
      title: Text('Enter the code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            // controller: _codeController,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Text is empty';
              }
              return null;
            },
          ),
        ],
      ),
      actions: <Widget>[
        //cancel button
        FlatButton(
          child: Text('Cancel'),
          textColor: Colors.black,
          color: AppTheme.gradientColor2,
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Confirm'),
          textColor: Colors.black,
          color: AppTheme.gradientColor2,
          onPressed: () async {},
        ),
      ],
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
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

Widget getTitleSection(Salon salon) {
  return Container(
    // color: AppTheme.gradientColor2,
    padding: const EdgeInsets.all(32),
    child: Expanded(
      /*1*/
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*2*/
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              salon.description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${salon.streetAddress1} ${salon.streetAddress2}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ),

          // Icon(
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Icon(
          //       Icons.star,
          //       color: Colors.pink[300],
          //     ),
          //     Text('41   '),
          //     SizedBox(),
          //     IconButton(
          //       icon: Icon(Icons.call),
          //       color: Colors.pink[300],
          //       onPressed: () {
          //         _callFunc();
          //       },
          //       iconSize: 30,
          //     ),
          //   ],
          // ),
        ],
      ),
    ),
  );
}
