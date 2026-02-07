import 'package:fyndr_ng/model/user_model.dart';
import 'package:fyndr_ng/utils/app_constants.dart';

class ProductModel {
  String? id;
  UserModel? user;
  String? name;
  bool? isFree;
  num? price;
  String? condition;
  String? description;
  List<String>? images;
  String? createdAt;
  ProductLocation? location;
  double? rawDistance;

  ProductModel({
    this.id,
    this.user,
    this.name,
    this.isFree,
    this.price,
    this.condition,
    this.description,
    this.images,
    this.createdAt,
    this.location,
    this.rawDistance,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    // --- User Parsing ---
    if (json['user'] != null) {
      if (json['user'] is Map<String, dynamic>) {
        user = UserModel.fromJson(json['user']);
      } else {
        user = UserModel(id: json['user'].toString());
      }
    }

    name = json['name'];
    isFree = json['isFree'];
    price = json['price'];
    condition = json['condition'];
    description = json['description'];

    // --- Image Parsing ---
    if (json['images'] != null) {
      images =
          List<String>.from(json['images']).map((img) {
            if (!img.startsWith('http')) {
              return '${AppConstants.BASE_URL}$img';
            }
            return img;
          }).toList();
    } else {
      images = [];
    }

    createdAt = json['createdAt'];

    // --- LOCATION & DISTANCE LOGIC ---
    if (json['location'] != null && json['location'] is Map<String, dynamic>) {
      location = ProductLocation.fromJson(json['location']);
    } else {
      location = ProductLocation();
    }

    if (json['distanceFromUser'] != null) {
      double distInMeters = (json['distanceFromUser'] as num).toDouble();

      // Store Raw Distance in KM
      rawDistance = distInMeters / 1000;

      // Store Formatted String for UI
      location!.distance = _formatDistance(distInMeters);
    }
  }

  // --- Helper to format meters to KM string ---
  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      double km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  String get title => name ?? 'Unknown Item';

  String get sellerName => user?.name ?? 'Unknown Seller';

  DateTime get postedDate {
    if (createdAt == null) return DateTime.now();
    return DateTime.tryParse(createdAt!) ?? DateTime.now();
  }
}

class ProductLocation {
  String? type;
  List<double>? coordinates;
  String? distance;

  ProductLocation({this.type, this.coordinates, this.distance});

  ProductLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];

    if (json['coordinates'] != null) {
      coordinates = List<double>.from(
        json['coordinates'].map((x) => x.toDouble()),
      );
    }

    if (json['distance'] != null) {
      distance = json['distance'].toString();
    }
  }
}
