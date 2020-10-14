import 'package:best_flutter_ui_templates/model/product.dart';

class Salon {
  String salonName;
  String subTxt;
  double dist;
  double rating;
  int reviews;
  int perService;
  String description;
  String hotline;
  String streetAddress1;
  String streetAddress2;
  List<String> salonImagesList;
  List<String> salonImagesUrlList;
  List<Product> productList;
  String salonDocId;

  String salonImg1;
  String salonImg2;
  String salonImg3;
  String salonImg4;
  String salonImg5;

  Salon({
    this.salonName = '',
    this.subTxt = "",
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perService = 180,
    this.description = '',
    this.hotline = '',
    this.streetAddress1 = '',
    this.streetAddress2 = '',
    this.salonImagesList = const [],
    this.salonImagesUrlList = const [],
    this.productList = const [],
    this.salonDocId = '',
    this.salonImg1 = '',
    this.salonImg2 = '',
    this.salonImg3 = '',
    this.salonImg4 = '',
    this.salonImg5 = '',
  });
}

class MyListClass {
  List<String> myList;
  String x;

  MyListClass({List<String> list, this.x}) : myList = list ?? List<String>();
}
