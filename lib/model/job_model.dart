import 'package:image_picker/image_picker.dart';


class JobModel {
  String? id;
  String? category;
  String? urgency;
  String? date;
  String? description;
  String? createdAt;
  JobLocation? location;
  JobAddress? address;
  JobStatus? status;
  JobBudget? budget;    // <--- NEW
  List<String>? photos; // <--- NEW

  JobModel({
    this.id,
    this.category,
    this.urgency,
    this.date,
    this.description,
    this.createdAt,
    this.location,
    this.address,
    this.status,
    this.budget,
    this.photos,
  });

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    urgency = json['urgency'];
    date = json['date'];
    description = json['description'];
    createdAt = json['createdAt'];
    location = json['location'] != null ? JobLocation.fromJson(json['location']) : null;
    address = json['address'] != null ? JobAddress.fromJson(json['address']) : null;
    status = json['status'] != null ? JobStatus.fromJson(json['status']) : null;
    budget = json['budget'] != null ? JobBudget.fromJson(json['budget']) : null; // <--- NEW

    // Parse photos list
    if (json['photos'] != null) {
      photos = List<String>.from(json['photos']);
    }
  }
}

class JobBudget {
  int? min;
  int? max;
  int? preference;

  JobBudget({this.min, this.max, this.preference});

  JobBudget.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    preference = json['preference'];
  }
}

class JobLocation {
  String? state;
  String? lga;

  JobLocation({this.state, this.lga});

  JobLocation.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    lga = json['lga'];
  }
}

class JobAddress {
  String? street;
  String? houseNumber;

  JobAddress({this.street, this.houseNumber});

  JobAddress.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    houseNumber = json['houseNumber'];
  }
}

class JobStatus {
  bool? isOpen;
  bool? isInProgress;
  bool? isCompleted;
  bool? isCancelled;

  JobStatus({this.isOpen, this.isInProgress, this.isCompleted, this.isCancelled});

  JobStatus.fromJson(Map<String, dynamic> json) {
    isOpen = json['isOpen'];
    isInProgress = json['isInProgress'];
    isCompleted = json['isCompleted'];
    isCancelled = json['isCancelled'];
  }
}

class QuoteModel {
  String? id;
  int? amount;
  String? description;
  String? merchantName;
  String? createdAt;

  QuoteModel({this.id, this.amount, this.description, this.merchantName, this.createdAt});

  QuoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    description = json['description'];
    merchantName = json['merchantName'];
    createdAt = json['createdAt'];
  }
}

class ServiceRequestData {
  final String serviceType;
  final String displayLocation; // For UI
  final String displayDate;     // For UI
  final String urgency;
  final String displayBudget;   // For UI
  final String description;

  // RAW DATA FOR API
  final String? houseNumber;
  final String? street;
  final String? city; // LGA
  final String? state;
  final double? lat;
  final double? lng;
  final String rawDate; // YYYY-MM-DD
  final String rawTime; // HH:MM
  final String minBudget;
  final String maxBudget;

  final List<XFile>? images;

  ServiceRequestData({
    required this.serviceType,
    required this.displayLocation,
    required this.displayDate,
    required this.urgency,
    required this.displayBudget,
    required this.description,
    // Optional params for API
    this.houseNumber,
    this.street,
    this.city,
    this.state,
    this.lat,
    this.lng,
    required this.rawDate,
    required this.rawTime,
    required this.minBudget,
    required this.maxBudget,
    this.images,
  });
}