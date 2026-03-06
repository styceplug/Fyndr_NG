import 'package:fyndr_ng/model/job_model.dart';
import 'package:fyndr_ng/model/product_model.dart';
import 'package:fyndr_ng/model/user_model.dart';

class ChatModel {
  String? id;
  String? type;

  // IDs
  String? customerId;
  String? vendorId;
  String? productId;
  String? serviceId;
  String? lastMessageId;

  // Populated Models
  UserModel? customer;
  UserModel? vendor;
  ProductModel? product;
  JobModel? service; // Make sure you have this model
  List<MessageModel>? messages;
  MessageModel? lastMessageData;
  String? blockedBy;
  int? customerUnreadCount;
  int? vendorUnreadCount;
  String? createdAt;

  ChatModel({
    this.id, this.type, this.customerId, this.vendorId,
    this.productId, this.serviceId, this.customer, this.vendor,
    this.product, this.service, this.lastMessageData,
    this.customerUnreadCount, this.vendorUnreadCount,
    this.createdAt, this.messages, this.blockedBy,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    type = json['type'];
    createdAt = json['createdAt'];
    customerUnreadCount = json['customerUnreadCount'] ?? 0;
    vendorUnreadCount = json['vendorUnreadCount'] ?? 0;
    blockedBy = json['blockedBy']?.toString();
    if (blockedBy == 'null') blockedBy = null;


    void parseField<T>(
        dynamic data,
        Function(T) onModel,
        Function(String) onId
        ) {
      if (data == null) return;
      if (data is Map<String, dynamic>) {
        // It's a populated object
        if (T == UserModel) onModel(UserModel.fromJson(data) as T);
        if (T == ProductModel) onModel(ProductModel.fromJson(data) as T);
        if (T == JobModel) onModel(JobModel.fromJson(data) as T);
        if (T == MessageModel) onModel(MessageModel.fromJson(data) as T);

        // Also extract the ID from the map
        final extractedId = (data['id'] ?? data['_id'])?.toString();
        if (extractedId != null) onId(extractedId);
      } else {
        // It's just a String ID
        onId(data.toString());
      }
    }

    // --- Execute Parsing ---
    parseField<UserModel>(json['customer'], (m) => customer = m, (id) => customerId = id);
    parseField<UserModel>(json['vendor'], (m) => vendor = m, (id) => vendorId = id);
    parseField<ProductModel>(json['product'], (m) => product = m, (id) => productId = id);
    parseField<JobModel>(json['service'], (m) => service = m, (id) => serviceId = id);
    parseField<MessageModel>(json['lastMessage'], (m) => lastMessageData = m, (id) => lastMessageId = id);

    // --- Messages List Fix ---
    if (json['messages'] != null && json['messages'] is List) {
      messages = [];
      for (var v in json['messages']) {
        if (v is Map<String, dynamic>) {
          messages!.add(MessageModel.fromJson(v));
        } else if (v is String) {
          // Optional: If you want to keep track of IDs even if not populated
          messages!.add(MessageModel(id: v));
        }
      }
    }
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
    return {'url': url, 'size': size, 'length': length};
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
