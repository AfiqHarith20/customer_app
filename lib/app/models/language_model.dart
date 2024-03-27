class LanguageModel {
  String? code;

  bool? active;
  String? name;
  String? id;

  LanguageModel({this.code, this.active, this.name, this.id});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];

    active = json['active'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['code'] = code;
    data['active'] = active;
    data['name'] = name;
    data['id'] = id;

    return data;
  }
}
