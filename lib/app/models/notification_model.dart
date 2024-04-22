class NotificationModel {
  String? title;
  String? date;
  String? category;
  String? desc;

  NotificationModel({
    this.title,
    this.date,
    this.category,
    this.desc,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
    category = json['category'];
    desc = json['desc'];
  }
}
