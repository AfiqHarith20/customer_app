class ContactUsModel {
  String? emailSubject;
  String? email;
  String? phoneNumber;
  String? address;

  ContactUsModel({this.emailSubject, this.email, this.phoneNumber, this.address});

  ContactUsModel.fromJson(Map<String, dynamic> json) {
    emailSubject = json['emailSubject'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emailSubject'] = emailSubject;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['Address'] = address;
    return data;
  }
}
