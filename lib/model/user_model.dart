import '../utils/app_constants.dart';

class UserModel {
  String? id;
  String? name;
  String? number;
  String? email;
  String? currentRole;
  bool? isActive;
  String? avatar;

  // --- NEW STATUS FLAGS ---
  bool? isEmailValidated;
  bool? isProfileVerified;
  bool? isBusinessVerified;
  bool? isAvailable;
  bool? isFyndrRecommended;

  // --- MISSING FIELDS ADDED ---
  String? verificationStatus;
  String? ratings;

  UserLocation? location;
  UserPreferences? preferences;
  String? createdAt;

  // --- PROFILE SWITCHING FLAGS ---
  bool? hasVendorProfile;
  bool? hasCustomerProfile;

  // --- NESTED OBJECTS ---
  BusinessDetails? businessDetails;
  BusinessDocs? businessDocs;

  UserModel({
    this.id,
    this.name,
    this.number,
    this.email,
    this.currentRole,
    this.isActive,
    this.isEmailValidated,
    this.isProfileVerified,
    this.isBusinessVerified,
    this.isAvailable,
    this.isFyndrRecommended,
    this.verificationStatus, // New
    this.ratings,            // New
    this.location,
    this.preferences,
    this.createdAt,
    this.hasVendorProfile,
    this.hasCustomerProfile, // New
    this.businessDetails,
    this.businessDocs,
    this.avatar
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      email: json['email'],
      currentRole: json['currentRole'],
      isActive: json['isActive'],
      avatar: json['avatar'],

      // Parse flags
      isEmailValidated: json['isEmailValidated'] ?? false,
      isProfileVerified: json['isProfileVerified'] ?? false,
      isBusinessVerified: json['isBusinessVerified'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      isFyndrRecommended: json['isFyndrRecommended'] ?? false,

      // Parse missing fields
      verificationStatus: json['verificationStatus'],
      ratings: json['ratings']?.toString(), // Safely convert to string

      location: json['location'] != null
          ? UserLocation.fromJson(json['location'])
          : null,

      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,

      createdAt: json['createdAt'],

      // Handle both profile flags
      hasVendorProfile: json['hasVendorProfile'] ?? false,
      hasCustomerProfile: json['hasCustomerProfile'] ?? false,

      businessDetails: json['businessDetails'] != null
          ? BusinessDetails.fromJson(json['businessDetails'])
          : null,
      businessDocs: json['businessDocs'] != null
          ? BusinessDocs.fromJson(json['businessDocs'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'email': email,
      'currentRole': currentRole,
      'isActive': isActive,
      'isEmailValidated': isEmailValidated,
      'isProfileVerified': isProfileVerified,
      'isBusinessVerified': isBusinessVerified,
      'isAvailable': isAvailable,
      'isFyndrRecommended': isFyndrRecommended,
      'verificationStatus': verificationStatus,
      'ratings': ratings,
      'location': location?.toJson(),
      'preferences': preferences?.toJson(),
      'createdAt': createdAt,
      'hasVendorProfile': hasVendorProfile,
      'hasCustomerProfile': hasCustomerProfile,
      'businessDetails': businessDetails?.toJson(),
      'businessDocs': businessDocs?.toJson(),
    };
  }

  // ... (Keep your helper methods like isProfileComplete, getAccountAge, profilePicture)

  bool get isProfileComplete {
    bool hasName = name != null && name!.isNotEmpty;
    bool hasEmail = email != null && email!.isNotEmpty;
    // Note: For vendors, location might be inside businessDetails, not root location
    bool hasLocation = (location != null && location!.state != null) ||
        (businessDetails?.businessLocation?.state != null);

    return hasName && hasEmail && hasLocation;
  }

  String getAccountAge(String? dateString) {
    if (dateString == null) return "0 days";
    DateTime createdDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    Duration diff = now.difference(createdDate);

    if (diff.inDays > 365) {
      int years = (diff.inDays / 365).floor();
      return "$years ${years == 1 ? 'yr' : 'yrs'}";
    } else if (diff.inDays > 30) {
      int months = (diff.inDays / 30).floor();
      return "$months ${months == 1 ? 'mo' : 'mos'}";
    } else {
      return "${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'}";
    }
  }

  String? get profilePicture {
    if (avatar == null || avatar!.isEmpty) {
      return null;
    }
    if (avatar!.startsWith('http')) {
      return avatar;
    }
    return '${AppConstants.BASE_URL}$avatar';
  }
}

class BusinessDetails {
  UserLocation? businessLocation;
  String? businessName;
  String? businessRegNumber;
  String? businessWhatsappContact;
  String? businessType;
  String? businessYearEstablished;
  List<String>? servicesOffered;
  String? subcategory;

  BusinessDetails({
    this.businessLocation,
    this.businessName,
    this.businessRegNumber,
    this.businessWhatsappContact,
    this.businessType,
    this.businessYearEstablished,
    this.servicesOffered,
    this.subcategory,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      businessLocation: json['businessLocation'] != null
          ? UserLocation.fromJson(json['businessLocation'])
          : null,
      businessName: json['businessName'],
      businessRegNumber: json['businessRegNumber'],
      businessWhatsappContact: json['businessWhatsappContact'],
      businessType: json['businessType'],
      businessYearEstablished: json['businessYearEstablished'],
      servicesOffered: json['servicesOffered'] != null
          ? List<String>.from(json['servicesOffered'])
          : [],
      subcategory: json['subcategory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessLocation': businessLocation?.toJson(),
      'businessName': businessName,
      'businessRegNumber': businessRegNumber,
      'businessWhatsappContact': businessWhatsappContact,
      'businessType': businessType,
      'businessYearEstablished': businessYearEstablished,
      'servicesOffered': servicesOffered,
      'subCategory': subcategory,
    };
  }
}

class BusinessDocs {
  String? businessDocument;
  String? businessOwnerId;
  String? businessLocationDocument;

  BusinessDocs({
    this.businessDocument,
    this.businessOwnerId,
    this.businessLocationDocument,
  });

  factory BusinessDocs.fromJson(Map<String, dynamic> json) {
    return BusinessDocs(
      businessDocument: json['businessDocument'],
      businessOwnerId: json['businessOwnerId'],
      businessLocationDocument: json['businessLocationDocument'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessDocument': businessDocument,
      'businessOwnerId': businessOwnerId,
      'businessLocationDocument': businessLocationDocument,
    };
  }
}

class UserLocation {
  String? state;
  String? lga;
  List<double>? coordinates;

  UserLocation({this.state, this.lga, this.coordinates});

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      state: json['state'],
      lga: json['lga'],
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'state': state, 'lga': lga, 'coordinates': coordinates};
  }
}

class UserPreferences {
  Notifications? notifications;

  UserPreferences({this.notifications});

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notifications: json['notifications'] != null
          ? Notifications.fromJson(json['notifications'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'notifications': notifications?.toJson()};
  }
}

class Notifications {
  bool email;
  bool text;
  bool whatsapp;
  bool inApp;

  Notifications({
    this.email = false,
    this.text = false,
    this.whatsapp = false,
    this.inApp = false,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      email: json['email'] ?? false,
      text: json['text'] ?? false,
      whatsapp: json['whatsapp'] ?? false,
      inApp: json['inApp'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'text': text, 'whatsapp': whatsapp, 'inApp': inApp};
  }
}
