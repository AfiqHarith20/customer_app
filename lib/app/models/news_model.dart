import 'dart:convert';

class NewsModel {
  String? des;
  String? link;
  String? read;
  String? title;
  DateTime? pubDate;
  String? categories;

  NewsModel({
    this.des,
    this.link,
    this.read,
    this.title,
    this.pubDate,
    this.categories,
  });

  factory NewsModel.fromRawJson(String str) =>
      NewsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        des: json["des"],
        link: json["link"],
        read: json["read"],
        title: json["title"],
        pubDate:
            json["pubDate"] == null ? null : DateTime.parse(json["pubDate"]),
        categories: json["categories"],
      );

  Map<String, dynamic> toJson() => {
        "des": des,
        "link": link,
        "read": read,
        "title": title,
        "pubDate": pubDate?.toIso8601String(),
        "categories": categories,
      };
}
