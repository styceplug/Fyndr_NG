import '../utils/app_constants.dart';

class UserModel {
  String? id;
  String? name;
  String? number;
  String? email;
  String? currentRole;
  bool? isActive;
  String? avatar;

  // Counts / stats
  int? chatUnreadCount;
  int? activeJobs;
  int? newLeads;
  num? totalEarnings;
  num? todayEarnings;
  int? completedJobs;

  // Status flags
  bool? isEmailValidated;
  bool? isProfileVerified;
  bool? isBusinessVerified;
  bool? isAvailable;
  bool? isFyndrRecommended;

  // Extra fields
  String? verificationStatus;
  String? ratings;
  List<dynamic>? allRatings;

  UserLocation? location;
  UserPreferences? preferences;

  String? createdAt;
  String? updatedAt;
  String? lastSeen;

  // Profile switching flags
  bool? hasVendorProfile;
  bool? hasCustomerProfile;

  // Nested objects
  BusinessDetails? businessDetails;
  BusinessDocs? businessDocs;

  NearbyJobsInfo? nearbyJobsInfo;
  List<DeviceTokenModel>? deviceTokens;

  UserModel({
    this.id,
    this.name,
    this.number,
    this.email,
    this.currentRole,
    this.isActive,
    this.avatar,

    this.chatUnreadCount,
    this.activeJobs,
    this.newLeads,
    this.totalEarnings,
    this.todayEarnings,

    this.isEmailValidated,
    this.isProfileVerified,
    this.isBusinessVerified,
    this.isAvailable,
    this.isFyndrRecommended,

    this.verificationStatus,
    this.ratings,
    this.allRatings,

    this.location,
    this.preferences,

    this.createdAt,
    this.updatedAt,
    this.lastSeen,

    this.hasVendorProfile,
    this.hasCustomerProfile,

    this.businessDetails,
    this.businessDocs,
    this.nearbyJobsInfo,
    this.deviceTokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      number: json['number'],
      email: json['email'],
      currentRole: json['currentRole'],
      isActive: json['isActive'],
      avatar: json['avatar'],

      chatUnreadCount: _toInt(json['chatUnreadCount']),
      activeJobs: _toInt(json['activeJobs']),
      newLeads: _toInt(json['newLeads']),
      totalEarnings: _toNum(json['totalEarnings']),
      todayEarnings: _toNum(json['todayEarnings']),

      isEmailValidated: json['isEmailValidated'] ?? false,
      isProfileVerified: json['isProfileVerified'] ?? false,
      isBusinessVerified: json['isBusinessVerified'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      isFyndrRecommended: json['isFyndrRecommended'] ?? false,

      verificationStatus: json['verificationStatus'],
      ratings: json['ratings']?.toString(),
      allRatings: (json['allRatings'] as List?)?.toList() ?? [],

      location:
      json['location'] != null ? UserLocation.fromJson(json['location']) : null,

      preferences:
      json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,

      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lastSeen: json['lastSeen'],

      hasVendorProfile: json['hasVendorProfile'] ?? false,
      hasCustomerProfile: json['hasCustomerProfile'] ?? false,

      businessDetails:
      json['businessDetails'] != null
          ? BusinessDetails.fromJson(json['businessDetails'])
          : null,

      businessDocs:
      json['businessDocs'] != null
          ? BusinessDocs.fromJson(json['businessDocs'])
          : null,

      deviceTokens: (json['deviceTokens'] as List?)
          ?.map((e) => DeviceTokenModel.fromJson(e))
          .toList() ??
          [],
      nearbyJobsInfo: json['nearbyJobsInfo'] != null
          ? NearbyJobsInfo.fromJson(json['nearbyJobsInfo'])
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
      'avatar': avatar,

      'chatUnreadCount': chatUnreadCount,
      'activeJobs': activeJobs,
      'newLeads': newLeads,
      'totalEarnings': totalEarnings,
      'todayEarnings': todayEarnings,

      'isEmailValidated': isEmailValidated,
      'isProfileVerified': isProfileVerified,
      'isBusinessVerified': isBusinessVerified,
      'isAvailable': isAvailable,
      'isFyndrRecommended': isFyndrRecommended,

      'verificationStatus': verificationStatus,
      'ratings': ratings,
      'allRatings': allRatings,

      'location': location?.toJson(),
      'preferences': preferences?.toJson(),

      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastSeen': lastSeen,

      'hasVendorProfile': hasVendorProfile,
      'hasCustomerProfile': hasCustomerProfile,

      'businessDetails': businessDetails?.toJson(),
      'businessDocs': businessDocs?.toJson(),
      'nearbyJobsInfo': nearbyJobsInfo?.toJson(),
      'deviceTokens': deviceTokens?.map((e) => e.toJson()).toList(),
    };
  }

  // ---------------- Helpers ----------------

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _toNum(dynamic v) {
    if (v == null) return 0;
    return num.tryParse(v.toString()) ?? 0;
  }

  bool get isProfileComplete {
    final bool hasName = name != null && name!.isNotEmpty;
    final bool hasEmail = email != null && email!.isNotEmpty;
    final bool hasPhone = number != null && number!.isNotEmpty;
    final bool hasAvatar = avatar != null && avatar!.isNotEmpty;

    final bool hasLocation =
    currentRole == 'vendor' ? _hasValidBusinessLocation() : _hasValidRootLocation();

    if (currentRole == 'vendor') {
      final bool hasBusinessName =
          businessDetails?.businessName != null &&
              businessDetails!.businessName!.isNotEmpty;

      final bool hasServices =
          businessDetails?.servicesOffered != null &&
              businessDetails!.servicesOffered!.isNotEmpty;

      return hasName && hasEmail && hasPhone && hasAvatar && hasLocation && hasBusinessName && hasServices;
    }

    return hasName && hasEmail && hasPhone && hasAvatar && hasLocation;
  }

  bool _hasValidBusinessLocation() {
    final loc = businessDetails?.businessLocation;
    if (loc == null) return false;

    final hasState = loc.state != null && loc.state!.isNotEmpty;
    final hasLga = loc.lga != null && loc.lga!.isNotEmpty;

    final coords = loc.coordinates;
    final hasCoords = coords != null &&
        coords.length == 2 &&
        !(coords[0] == 0 && coords[1] == 0);

    return hasState && hasLga && hasCoords;
  }

  bool _hasValidRootLocation() {
    final loc = location;
    if (loc == null) return false;

    final coords = loc.coordinates;
    return coords != null && coords.isNotEmpty;
  }

  String getAccountAge(String? dateString) {
    if (dateString == null) return "0 days";
    final createdDate = DateTime.parse(dateString);
    final now = DateTime.now();
    final diff = now.difference(createdDate);

    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return "$years ${years == 1 ? 'yr' : 'yrs'}";
    } else if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return "$months ${months == 1 ? 'mo' : 'mos'}";
    } else {
      return "${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'}";
    }
  }

  String? get profilePicture {
    if (avatar == null || avatar!.isEmpty) return null;
    if (avatar!.startsWith('http')) return avatar;
    return '${AppConstants.BASE_URL}$avatar';
  }
}

class DeviceTokenModel {
  String? id;
  String? token;
  String? platform;
  String? createdAt;

  DeviceTokenModel({
    this.id,
    this.token,
    this.platform,
    this.createdAt,
  });

  factory DeviceTokenModel.fromJson(Map<String, dynamic> json) {
    return DeviceTokenModel(
      id: json['id'] ?? json['_id'],
      token: json['token'],
      platform: json['platform'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'platform': platform,
      'createdAt': createdAt,
    };
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
      businessLocation:
          json['businessLocation'] != null
              ? UserLocation.fromJson(json['businessLocation'])
              : null,
      businessName: json['businessName'],
      businessRegNumber: json['businessRegNumber'],
      businessWhatsappContact: json['businessWhatsappContact'],
      businessType: json['businessType'],
      businessYearEstablished: json['businessYearEstablished'],
      servicesOffered:
          json['servicesOffered'] != null
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
      coordinates:
          (json['coordinates'] as List?)
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
      notifications:
          json['notifications'] != null
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

class NearbyJobsInfo {
  final String? category;
  final bool hasJobsNearby;
  final int nearbyJobCount;

  NearbyJobsInfo({
    this.category,
    required this.hasJobsNearby,
    required this.nearbyJobCount,
  });

  factory NearbyJobsInfo.fromJson(Map<String, dynamic> json) {
    return NearbyJobsInfo(
      category: json['category'],
      hasJobsNearby: json['hasJobsNearby'] ?? false,
      nearbyJobCount: json['nearbyJobCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'hasJobsNearby': hasJobsNearby,
    'nearbyJobCount': nearbyJobCount,
  };
}
