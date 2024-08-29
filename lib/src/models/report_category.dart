class ReportCategory {
  int id;
  String name;
  String pic;

  ReportCategory({required this.id, required this.name, required this.pic});
  //  {
  //           "id": 1,
  //           "estab_name": "Comida en mal estado",
  //           "pic": "https://imgpre.bizne.com.mx/banners/64bb2899300c0_Captura de pantalla 2023-07-17 a la(s) 14.15.47.png"
  //       }

  static ReportCategory fromJson(Map<String, dynamic> json) => ReportCategory(
      id: json['id'], name: json['estab_name'], pic: json['pic']);
}
