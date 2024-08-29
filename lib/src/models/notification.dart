class NotificationModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final String? pic;

  NotificationModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,this.pic});

  static NotificationModel fromJson(Map<String, dynamic> json) => NotificationModel(
      id: json['id'],
      title: json['notification_type'],
      description: json['description'],
      pic: json['pic'],
      date: json['sent_date']);
}