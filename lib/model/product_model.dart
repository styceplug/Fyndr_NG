import 'package:fyndr_ng/model/user_model.dart';
import 'package:intl/intl.dart';

import '../utils/app_constants.dart';

class ProductModel {
  String? id;
  UserModel? user; // Changed from String to UserModel to hold seller details
  String? name;
  bool? isFree;
  num? price;
  String? condition;
  String? state;
  String? lga;
  String? description;
  List<String>? images;
  String? createdAt;

  ProductModel({
    this.id,
    this.user,
    this.name,
    this.isFree,
    this.price,
    this.condition,
    this.state,
    this.lga,
    this.description,
    this.images,
    this.createdAt,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // Handle case where user is just an ID string or a full object
    if (json['user'] != null) {
      if (json['user'] is Map<String, dynamic>) {
        user = UserModel.fromJson(json['user']);
      } else {
        // If API only returns ID, creates a dummy user with that ID
        user = UserModel(id: json['user'].toString());
      }
    }
    name = json['name'];
    isFree = json['isFree'];
    price = json['price'];
    condition = json['condition'];
    state = json['state'];
    lga = json['lga'];
    description = json['description'];
    if (json['images'] != null) {
      images = List<String>.from(json['images']).map((img) {
        // Automatically prepend base URL if missing
        if (!img.startsWith('http')) {
          return '${AppConstants.BASE_URL}$img';
        }
        return img;
      }).toList();
    } else {
      images = [];
    }
    createdAt = json['createdAt'];
  }

  // --- UI HELPERS ---
  String get title => name ?? 'Unknown Item';
  String get location => "$lga, $state";
  String get sellerName => user?.name ?? 'Unknown Seller';
  String get sellerPhone => user?.number ?? ''; // Assuming 'number' exists in UserModel

  DateTime get postedDate {
    if (createdAt == null) return DateTime.now();
    return DateTime.tryParse(createdAt!) ?? DateTime.now();
  }
}