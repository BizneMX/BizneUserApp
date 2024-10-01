class Establishment {
  int id;
  String name;
  String? pic;
  double distance;
  String? imagePin;
  bool closed;
  String discount;
  String? menu;
  String phone;
  String lat;
  String lng;
  bool fonda;
  String? schedule;
  int matrixId;
  int idControl;
  double calification;
  bool basicMenu;
  String address;
  bool favorite;
  String? logoPic;
  String? menuPic;
  bool allowBookings;

  Establishment(
      {required this.id,
      required this.name,
      this.pic,
      required this.distance,
      this.imagePin,
      required this.closed,
      required this.discount,
      required this.menu,
      required this.phone,
      required this.lat,
      required this.lng,
      required this.fonda,
      required this.schedule,
      required this.matrixId,
      required this.idControl,
      required this.calification,
      required this.basicMenu,
      required this.address,
      required this.favorite,
      this.logoPic,
      this.menuPic,
      required this.allowBookings});

  static Establishment fromJson(Map<String, dynamic> json) {
    return Establishment(
        id: json["id"],
        name: json["name"],
        pic: json["pic"],
        distance: json["distance"],
        imagePin: json["imagePin"],
        closed: json["closed"],
        discount: json["discount"],
        menu: json["menu"],
        phone: json["phone"],
        lat: json["lat"],
        lng: json["lng"],
        fonda: json["fonda"],
        schedule: json["schedule"],
        matrixId: json["matrix_id"],
        idControl: json["id_control"],
        calification: double.parse(json["calification"].toString()),
        basicMenu: json["basic_menu"],
        address: json["address"],
        logoPic: json["logo_pic"],
        menuPic: json["menu_pic"],
        favorite: json["favorite"],
        allowBookings: json['allow_bookings'] ?? false);
  }
}
