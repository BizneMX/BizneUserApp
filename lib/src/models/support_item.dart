class SupportItemModel {
  final int id;
  final String pic;
  final String description;
  final int type;
  final String url;

  const SupportItemModel(
      {required this.id,
      required this.pic,
      required this.description,
      required this.type,
      required this.url});

  static SupportItemModel fromJson(Map<String, dynamic> json) {
    return SupportItemModel(
        id: json["id"],
        pic: json["pic"],
        description: json["description"],
        type: json["type"],
        url: json["url"]);
  }
}
