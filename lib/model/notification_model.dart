import 'package:fyndr_ng/model/chat_model.dart';
import 'package:fyndr_ng/model/job_model.dart';
import 'package:fyndr_ng/model/product_model.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // chat, job, product, quote, announcement...
  final bool isRead;
  final DateTime createdAt;

  // IDs (fallbacks)
  final String? productId;
  final String? quoteId;
  final String? serviceId;
  final String? chatId;

  // Populated models
  final ProductModel? product;
  final QuoteModel? quote;
  final JobModel? service;
  final ChatModel? chat;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.productId,
    this.quoteId,
    this.serviceId,
    this.chatId,
    this.product,
    this.quote,
    this.service,
    this.chat,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    // helper: parse either object or string id
    T? parseModelOrNull<T>(
        dynamic value,
        T Function(Map<String, dynamic>) parser,
        ) {
      if (value is Map<String, dynamic>) return parser(value);
      return null;
    }

    String? parseId(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map) return (value['id'] ?? value['_id'])?.toString();
      return value.toString();
    }

    final chatModel = parseModelOrNull<ChatModel>(json['chat'], (m) => ChatModel.fromJson(m));
    final jobModel  = parseModelOrNull<JobModel>(json['service'], (m) => JobModel.fromJson(m));
    final prodModel = parseModelOrNull<ProductModel>(json['product'], (m) => ProductModel.fromJson(m));
    final quoteModel= parseModelOrNull<QuoteModel>(json['quote'], (m) => QuoteModel.fromJson(m));

    return AppNotification(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      isRead: json['isRead'] == true,
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),

      // IDs
      chatId: parseId(json['chat']) ?? chatModel?.id,
      serviceId: parseId(json['service']) ?? jobModel?.id,
      productId: parseId(json['product']) ?? prodModel?.id,
      quoteId: parseId(json['quote']) ?? quoteModel?.id,

      // Models
      chat: chatModel,
      service: jobModel,
      product: prodModel,
      quote: quoteModel,
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      productId: productId,
      quoteId: quoteId,
      serviceId: serviceId,
      chatId: chatId,
      product: product,
      quote: quote,
      service: service,
      chat: chat,
    );
  }
}


class NotificationPageData {
  final List<AppNotification> notifications;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;
  final int unreadCount;

  NotificationPageData({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
    required this.unreadCount,
  });

  factory NotificationPageData.fromJson(Map<String, dynamic> json) {
    final list = (json['notifications'] as List? ?? [])
        .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return NotificationPageData(
      notifications: list,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      hasMore: json['hasMore'] == true,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
