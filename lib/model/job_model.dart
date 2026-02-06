import 'package:fyndr_ng/model/user_model.dart';
import 'package:image_picker/image_picker.dart';


class JobModel {
  String? id;
  UserModel? user;
  JobLocation? location;
  JobAddress? address;
  String? date;
  String? urgency;
  JobBudget? budget;
  String? category;
  List<String>? photos;
  List<String>? specialRequirements;
  String? description;
  JobStatus? status;
  String? subcategory;
  String? createdAt;
  List<String>? quotes;
  List<BookingProgress>? bookingProgress;


  JobModel({
    this.id,
    this.user,
    this.location,
    this.address,
    this.date,
    this.urgency,
    this.budget,
    this.category,
    this.photos,
    this.specialRequirements,
    this.description,
    this.status,
    this.subcategory,
    this.createdAt,
    this.quotes,
    this.bookingProgress
  });

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null; // <--- Parse User
    location = json['location'] != null ? JobLocation.fromJson(json['location']) : null;
    address = json['address'] != null ? JobAddress.fromJson(json['address']) : null;
    date = json['date'];
    urgency = json['urgency'];
    budget = json['budget'] != null ? JobBudget.fromJson(json['budget']) : null;
    category = json['category'];


    // Parse Lists safely
    if (json['photos'] != null) {
      photos = List<String>.from(json['photos']);
    } else {
      photos = [];
    }

    if (json['specialRequirements'] != null) {
      specialRequirements = List<String>.from(json['specialRequirements']);
    } else {
      specialRequirements = [];
    }

    description = json['description'];
    status = json['status'] != null ? JobStatus.fromJson(json['status']) : null;
    subcategory = (json['subcategory'] ?? json['subCategory'])?.toString();
    createdAt = json['createdAt'];
    if (json['quotes'] != null) {
      quotes = List<String>.from(json['quotes']);
    } else {
      quotes = [];
    }

    if (json['bookingProgress'] != null) {
      bookingProgress = <BookingProgress>[];
      json['bookingProgress'].forEach((v) {
        bookingProgress!.add(BookingProgress.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson(); // <--- Convert User to JSON
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['date'] = date;
    data['urgency'] = urgency;
    if (budget != null) {
      data['budget'] = budget!.toJson();
    }
    data['category'] = category;
    data['photos'] = photos;
    data['specialRequirements'] = specialRequirements;
    data['description'] = description;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['subCategory'] = subcategory; // Match JSON key casing
    data['createdAt'] = createdAt;
    return data;
  }
}


class BookingProgress {
  String? id;
  String? status;
  String? notes;
  String? timestamp;

  BookingProgress({this.id, this.status, this.notes, this.timestamp});

  BookingProgress.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    status = json['status'];
    notes = json['notes'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['notes'] = notes;
    data['timestamp'] = timestamp;
    return data;
  }
}


class JobBudget {
  num? min;
  num? max;
  num? preference;

  JobBudget({this.min, this.max, this.preference});

  JobBudget.fromJson(Map<String, dynamic> json) {
    min = (json['min'] as num?)?.toInt();
    max = (json['max'] as num?)?.toInt();
    preference = (json['preference'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'preference': preference,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'isOpen': isOpen,
      'isInProgress': isInProgress,
      'isCompleted': isCompleted,
      'isCancelled': isCancelled,
    };
  }
}

class JobLocation {
  String? state;
  String? lga;
  String? type;
  List<num>? coordinates;

  JobLocation({this.state, this.lga, this.type, this.coordinates});

  JobLocation.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    lga = json['lga'];
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = List<num>.from(json['coordinates']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'lga': lga,
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class JobAddress {
  String? street;
  String? houseNumber;
  String? additionalDirections;

  JobAddress({this.street, this.houseNumber, this.additionalDirections});

  JobAddress.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    houseNumber = json['houseNumber'];
    additionalDirections = json['additionalDirections'];
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'houseNumber': houseNumber,
      'additionalDirections': additionalDirections,
    };
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

  final String? subcategory;

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
    this.subcategory,
  });
}

class SubmitQuoteBody {
  final String jobId;
  final int amount;
  final DateTime estimatedCompletionTime;
  final String availability;
  final String message;
  final List<String> addons;
  final List<XFile> images;

  SubmitQuoteBody({
    required this.jobId,
    required this.amount,
    required this.estimatedCompletionTime,
    required this.availability,
    required this.message,
    required this.addons,
    required this.images,
  });

  static String _mapAddonToApiValue(String displayName) {
    switch (displayName) {
      case 'Full Inspection':
        return 'full-inspection';
      case 'Leak repair':
        return 'leak-repair';
      case 'Parts':
        return 'parts';
      case '30 days warranty':
        return 'warranty';
      default:
        return displayName.toLowerCase().replaceAll(' ', '-');
    }
  }


  Map<String, String> toFields() {

    List<String> apiAddons = addons.map((addon) => _mapAddonToApiValue(addon)).toList();

    String formattedAddons = apiAddons.isEmpty
        ? "[]"
        : apiAddons.toString();


    return {
      "job": jobId,
      "amount": amount.toString(),
      "estimatedCompletionTime": estimatedCompletionTime.toUtc().toIso8601String(),
      "availability": availability,
      "message": message,
      "addons": formattedAddons,
    };
  }
}

class QuoteModel {
  String? id;
  JobModel? job;
  UserModel? user;
  UserModel? merchant;
  double? amount;
  double? previousAmount; // Added
  String? sender;         // Added (customer/merchant)
  String? responseReason; // Added
  String? responseAdditionalComment; // Added
  String? estimatedCompletionTime;
  String? availability;
  List<String>? addons;
  String? message;
  List<String>? photos;
  String? status;
  Map<String, dynamic>? declined;
  Map<String, dynamic>? countered;
  String? createdAt;

  QuoteModel({
    this.id,
    this.job,
    this.user,
    this.merchant,
    this.amount,
    this.previousAmount,
    this.sender,
    this.responseReason,
    this.responseAdditionalComment,
    this.estimatedCompletionTime,
    this.availability,
    this.addons,
    this.message,
    this.photos,
    this.status,
    this.declined,
    this.countered,
    this.createdAt,
  });

  QuoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    // Parse nested JobModel
    job = json['job'] != null ? JobModel.fromJson(json['job']) : null;

    // Parse User (Customer)
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;

    // Parse Merchant (Vendor) - Uses UserModel since it contains businessDetails
    merchant = json['merchant'] != null ? UserModel.fromJson(json['merchant']) : null;

    // Safely handle numeric amount (converts int to double if needed)
    amount = (json['amount'] as num?)?.toDouble();

    previousAmount = (json['previousAmount'] as num?)?.toDouble(); // Parse previous

    sender = json['sender']; // Parse sender
    responseReason = json['responseReason']; // Parse reason
    responseAdditionalComment = json['responseAdditionalComment'];

    estimatedCompletionTime = json['estimatedCompletionTime'];
    availability = json['availability'];

    // Safely parse Lists
    addons = json['addons'] != null ? List<String>.from(json['addons']) : [];
    message = json['message'];
    photos = json['photos'] != null ? List<String>.from(json['photos']) : [];

    status = json['status'];
    declined = json['declined'];
    countered = json['countered'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    if (job != null) {
      data['job'] = job!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (merchant != null) {
      data['merchant'] = merchant!.toJson();
    }

    data['amount'] = amount;
    data['previousAmount'] = previousAmount;
    data['sender'] = sender;
    data['responseReason'] = responseReason;
    data['estimatedCompletionTime'] = estimatedCompletionTime;
    data['availability'] = availability;
    data['addons'] = addons;
    data['message'] = message;
    data['photos'] = photos;
    data['status'] = status;
    data['declined'] = declined;
    data['countered'] = countered;
    data['createdAt'] = createdAt;

    return data;
  }
}
