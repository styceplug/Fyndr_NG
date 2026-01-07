class UserModel {
  String? id;
  String? name;
  String? number;
  String? email;
  String? currentRole;
  bool? isActive;
  UserLocation? location;
  UserPreferences? preferences;

  UserModel({
    this.id,
    this.name,
    this.number,
    this.email,
    this.currentRole,
    this.isActive,
    this.location,
    this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      email: json['email'],
      currentRole: json['currentRole'],
      isActive: json['isActive'],
      location:
          json['location'] != null
              ? UserLocation.fromJson(json['location'])
              : null,
      preferences:
          json['preferences'] != null
              ? UserPreferences.fromJson(json['preferences'])
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
      'location': location?.toJson(),
      'preferences': preferences?.toJson(),
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
