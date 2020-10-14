class SalonServiceListData {
  SalonServiceListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perService = 180,
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  double dist;
  double rating;
  int reviews;
  int perService;

  static List<SalonServiceListData> salonServiceList = <SalonServiceListData>[
    SalonServiceListData(
      imagePath: 'assets/hotel/hotel_1.png',
      titleTxt: 'Hair Cutting',
      subTxt: 'Type 01',
      dist: 2.0,
      reviews: 80,
      rating: 4.4,
      perService: 180,
    ),
    SalonServiceListData(
      imagePath: 'assets/hotel/hotel_2.png',
      titleTxt: 'Queen Hotel',
      subTxt: 'Wembley, London',
      dist: 4.0,
      reviews: 74,
      rating: 4.5,
      perService: 200,
    ),
    SalonServiceListData(
      imagePath: 'assets/hotel/hotel_3.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Wembley, London',
      dist: 3.0,
      reviews: 62,
      rating: 4.0,
      perService: 60,
    ),
    SalonServiceListData(
      imagePath: 'assets/hotel/hotel_4.png',
      titleTxt: 'Queen Hotel',
      subTxt: 'Wembley, London',
      dist: 7.0,
      reviews: 90,
      rating: 4.4,
      perService: 170,
    ),
    SalonServiceListData(
      imagePath: 'assets/hotel/hotel_5.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Wembley, London',
      dist: 2.0,
      reviews: 240,
      rating: 4.5,
      perService: 200,
    ),
  ];
}
