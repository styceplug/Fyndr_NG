class BannerModel {
  String? id;
  String? image;
  String? createdAt;

  BannerModel({this.id, this.image, this.createdAt});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    image = json['image'];
    createdAt = json['createdAt'];
  }
}