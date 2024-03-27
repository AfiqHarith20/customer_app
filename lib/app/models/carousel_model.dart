class CarouselModel{
  String? id;
  String? image;

  CarouselModel({
    this.id,
    this.image,
  });

  CarouselModel? carouselModel;

  CarouselModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    carouselModel = json['carouselModel'] != null ? CarouselModel.fromJson(json['carouselModel']) : CarouselModel();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;

    if (carouselModel != null) {
      data['carouselModel'] = carouselModel!.toJson();
    }
    return data;
  }
}