class UserModel {
  String? id;
  String? name;
  String? number;
  String? email;
  String? currentRole;
  bool? isActive;

  // --- NEW STATUS FLAGS ---
  bool? isEmailValidated;
  bool? isProfileVerified;
  bool? isBusinessVerified;
  bool? isAvailable;
  bool? isFyndrRecommended;

  UserLocation? location;
  UserPreferences? preferences;
  String? createdAt;
  bool? hasVendorProfile;

  // --- NEW NESTED OBJECTS ---
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
    this.location,
    this.preferences,
    this.createdAt,
    this.hasVendorProfile,
    this.businessDetails,
    this.businessDocs,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      email: json['email'],
      currentRole: json['currentRole'],
      isActive: json['isActive'],

      // Parse new flags (using default false just in case)
      isEmailValidated: json['isEmailValidated'] ?? false,
      isProfileVerified: json['isProfileVerified'] ?? false,
      isBusinessVerified: json['isBusinessVerified'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      isFyndrRecommended: json['isFyndrRecommended'] ?? false,

      location: json['location'] != null
          ? UserLocation.fromJson(json['location'])
          : null,

      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,

      createdAt: json['createdAt'],
      hasVendorProfile: json['hasVendorProfile'] ?? false,

      // Parse new objects
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
      'location': location?.toJson(),
      'preferences': preferences?.toJson(),
      'createdAt': createdAt,
      'hasVendorProfile': hasVendorProfile,
      'businessDetails': businessDetails?.toJson(),
      'businessDocs': businessDocs?.toJson(),
    };
  }

  bool get isProfileComplete {
    bool hasName = name != null && name!.isNotEmpty;
    bool hasEmail = email != null && email!.isNotEmpty;
    bool hasLocation = location != null &&
        location!.state != null &&
        location!.state!.isNotEmpty;

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

}

class BusinessDetails {
  UserLocation? businessLocation;
  String? businessName;
  String? businessRegNumber;
  String? businessWhatsappContact;
  String? businessType;
  String? businessYearEstablished;
  List<String>? servicesOffered;
  String? subCategory;

  BusinessDetails({
    this.businessLocation,
    this.businessName,
    this.businessRegNumber,
    this.businessWhatsappContact,
    this.businessType,
    this.businessYearEstablished,
    this.servicesOffered,
    this.subCategory,
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
      subCategory: json['subCategory'],
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
      'subCategory': subCategory,
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
