import 'package:fyndr_ng/model/product_model.dart';
import 'package:fyndr_ng/model/user_model.dart';


class ChatModel {
  String? id;
  String? type;

  // IDs (Strings)
  String? customerId;
  String? vendorId;
  String? productId;
  String? serviceId;
  String? lastMessageId;

  // Objects (Populated Models)
  UserModel? customer;
  UserModel? vendor;
  ProductModel? product;
  List<MessageModel>? messages;
  MessageModel? lastMessageData;

  // Counters
  int? customerUnreadCount;
  int? vendorUnreadCount;

  String? createdAt;

  ChatModel({
    this.id,
    this.type,
    this.customerId,
    this.vendorId,
    this.productId,
    this.serviceId,
    this.customer,
    this.vendor,
    this.product,
    this.lastMessageData,
    this.customerUnreadCount,
    this.vendorUnreadCount,
    this.createdAt,
    this.messages,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    type = json['type'];
    createdAt = json['createdAt'];

    // --- 1. Customer Handling ---
    if (json['customer'] != null) {
      if (json['customer'] is Map) {
        customer = UserModel.fromJson(json['customer']);
        customerId = customer?.id;
      } else {
        customerId = json['customer'].toString();
        customer = UserModel(id: customerId);
      }
    }

    // --- 2. Vendor Handling ---
    if (json['vendor'] != null) {
      if (json['vendor'] is Map) {
        vendor = UserModel.fromJson(json['vendor']);
        vendorId = vendor?.id;
      } else {
        vendorId = json['vendor'].toString();
        vendor = UserModel(id: vendorId);
      }
    }

    // --- 3. Product Handling (The likely crasher) ---
    if (json['product'] != null) {
      if (json['product'] is Map) {
        // Only parse if it's an object
        product = ProductModel.fromJson(json['product']);
        productId = product?.id;
      } else {
        // If it's a String ID, just store the ID
        productId = json['product'].toString();
        // Create dummy so UI doesn't break on null check
        product = ProductModel(id: productId, name: "Product Info");
      }
    }

    // --- 4. Last Message Handling ---
    if (json['lastMessage'] != null) {
      if (json['lastMessage'] is Map) {
        lastMessageData = MessageModel.fromJson(json['lastMessage']);
        lastMessageId = lastMessageData?.id;
      } else {
        lastMessageId = json['lastMessage'].toString();
      }
    }

    // --- 5. Messages List (CRITICAL FIX) ---
    if (json['messages'] != null) {
      messages = <MessageModel>[];
      json['messages'].forEach((v) {
        // 🚨 FIX: Check if 'v' is actually a Map before parsing
        // The API list view returns ["ID", "ID"], not objects.
        if (v is Map<String, dynamic>) {
          messages!.add(MessageModel.fromJson(v));
        }
      });
    }

    // --- 6. Unread Counts ---
    customerUnreadCount = json['customerUnreadCount'] ?? 0;
    vendorUnreadCount = json['vendorUnreadCount'] ?? 0;
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
