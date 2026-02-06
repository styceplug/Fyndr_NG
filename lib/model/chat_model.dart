import 'package:fyndr_ng/model/user_model.dart';


class ChatModel {
  String? id;
  String? customer;
  String? vendor;
  String? service;
  String? product;
  String? type;

  UserModel? customerDetails;
  UserModel? vendorDetails;

  Map<String, dynamic>? serviceDetails;
  Map<String, dynamic>? productDetails;

  List<MessageModel>? messages;
  String? createdAt;

  ChatModel({
    this.id,
    this.customer,
    this.vendor,
    this.service,
    this.product,
    this.type,
    this.customerDetails,
    this.vendorDetails,
    this.messages,
    this.createdAt,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];

    // --- 1. Customer Handling ---
    if (json['customer'] is Map) {
      customer = json['customer']['id'] ?? json['customer']['_id'];
      customerDetails = UserModel.fromJson(json['customer']);
    } else {
      customer = json['customer'];
      if (json['customerDetails'] != null) {
        customerDetails = UserModel.fromJson(json['customerDetails']);
      }
    }

    // --- 2. Vendor Handling ---
    if (json['vendor'] is Map) {
      vendor = json['vendor']['id'] ?? json['vendor']['_id'];
      vendorDetails = UserModel.fromJson(json['vendor']);
    } else {
      vendor = json['vendor'];
      if (json['vendorDetails'] != null) {
        vendorDetails = UserModel.fromJson(json['vendorDetails']);
      }
    }

    // --- 3. FIX: Service (Job) Handling ---
    if (json['service'] is Map) {
      final serviceMap = json['service'];
      // Extract ID safely
      service = serviceMap['id'] ?? serviceMap['_id'];
      // Optional: Store details if you have a JobModel
      serviceDetails = serviceMap;
    } else {
      service = json['service'];
    }

    // --- 4. NEW: Product Handling ---
    if (json['product'] is Map) {
      final productMap = json['product'];
      product = productMap['id'] ?? productMap['_id'];
      productDetails = productMap;
    } else {
      product = json['product'];
    }

    // --- Messages ---
    if (json['messages'] != null) {
      messages = <MessageModel>[];
      json['messages'].forEach((v) {
        if (v is Map<String, dynamic>) {
          messages!.add(MessageModel.fromJson(v));
        }
      });
    }
    createdAt = json['createdAt'];
  }
}

class MessageModel {
  String? id;
  String? chat;
  String? sender;
  String? type; // 'text' or 'audio'
  String? text;
  AudioData? audio;
  String? createdAt;
  UserModel? senderDetails;

  MessageModel({
    this.id,
    this.chat,
    this.sender,
    this.type,
    this.text,
    this.audio,
    this.createdAt,
    this.senderDetails,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['messageId'];

    if (json['chat'] is Map) {
      final chatMap = json['chat'];
      chat = chatMap['id'] ?? chatMap['_id'];
    } else {
      chat = json['chat'] ?? json['chatId'];
    }


    if (json['sender'] is Map) {
      final senderMap = json['sender'];
      sender = senderMap['id'] ?? senderMap['_id'];
      senderDetails = UserModel.fromJson(senderMap);
    } else {
      sender = json['sender'] ?? json['senderId'];
    }


    type = json['type'];

    // Handle text content
    text = json['text'] ?? json['content'];

    // Handle audio data
    if (json['audio'] != null) {
      audio = AudioData.fromJson(json['audio']);
    } else if (json['audioUrl'] != null) {
      // Socket event format
      audio = AudioData(
        url: json['audioUrl'],
        size: json['audioSize'],
        length: json['audioDuration'],
      );
    }

    createdAt = json['createdAt'] ?? json['timestamp'];

    // Handle sender details if provided
    if (json['senderDetails'] != null) {
      senderDetails = UserModel.fromJson(json['senderDetails']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chat'] = chat;
    data['sender'] = sender;
    data['type'] = type;
    data['text'] = text;
    if (audio != null) {
      data['audio'] = audio!.toJson();
    }
    data['createdAt'] = createdAt;
    if (senderDetails != null) {
      data['senderDetails'] = senderDetails!.toJson();
    }
    return data;
  }

  bool get isAudio => type == 'audio';
  bool get isText => type == 'text';
}

class AudioData {
  String? url;
  int? size;
  int? length;

  AudioData({this.url, this.size, this.length});

  AudioData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    size = json['size'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'size': size,
      'length': length,
    };
  }

  String get formattedDuration {
    if (length == null) return '0:00';
    int minutes = length! ~/ 60;
    int seconds = length! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedSize {
    if (size == null) return '0 KB';
    double kb = size! / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    double mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}
