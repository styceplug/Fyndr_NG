import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/chat_controller.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/controllers/product_controller.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:fyndr_ng/model/product_model.dart';
import 'package:fyndr_ng/screens/home/pages/browse_screen.dart';
import 'package:get/get.dart';
import '../data/repo/notification_repo.dart';

import '../model/notification_model.dart';
import '../routes/routes.dart';
import '../screens/declutter/product_details.dart';
import 'auth_controller.dart';

class NotificationController extends GetxController {
  final NotificationRepo repo;

  NotificationController({required this.repo});

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();

  final notifications = <AppNotification>[].obs;
  final isLoadingMore = false.obs;
  final page = 1.obs;
  final limit = 20;
  final hasMore = true.obs;

  final unreadCount = 0.obs;

  static const allTypes = <String>{
    'announcement',
    'promotion',
    'update',
    'product',
    'job',
    'chat',
    'quote',
  };

  static const jobTypes = <String>{'product', 'job', 'quote'};
  static const messageTypes = <String>{'chat'};



  List<AppNotification> get allTab =>
      notifications.where((n) => allTypes.contains(n.type)).toList();

  List<AppNotification> get jobsTab =>
      notifications.where((n) => jobTypes.contains(n.type)).toList();

  List<AppNotification> get messagesTab =>
      notifications.where((n) => messageTypes.contains(n.type)).toList();

  Future<void> fetchInitial() async {
    try {
      loader.showLoader();
      page.value = 1;
      hasMore.value = true;
      notifications.clear();

      final res = await repo.getNotifications(page: 1, limit: limit);
      if (res.statusCode == 200 && res.body?['success'] == true) {
        final data = NotificationPageData.fromJson(
          Map<String, dynamic>.from(res.body['data']),
        );
        notifications.assignAll(data.notifications);
        unreadCount.value = data.unreadCount;
        hasMore.value = data.hasMore;
      }
    } finally {
      loader.hideLoader();
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    try {
      loader.showLoader();
      final next = page.value + 1;

      final res = await repo.getNotifications(page: next, limit: limit);
      if (res.statusCode == 200 && res.body?['success'] == true) {
        final data = NotificationPageData.fromJson(
          Map<String, dynamic>.from(res.body['data']),
        );
        notifications.addAll(data.notifications);
        unreadCount.value = data.unreadCount;
        hasMore.value = data.hasMore;
        page.value = next;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshUnreadCount() async {
    final res = await repo.getUnreadCounts();
    if (res.statusCode == 200 && res.body?['success'] == true) {
      unreadCount.value = res.body['data']['unreadCount'] ?? 0;
      print("Unread Count: ${unreadCount.value}");
      update();
    }
  }

  Future<void> markAllAsRead() async {
    final res = await repo.markAllRead();
    if (res.statusCode == 200 && res.body?['success'] == true) {
      notifications.value =
          notifications.map((n) => n.copyWith(isRead: true)).toList();
      unreadCount.value = 0;
    }
  }

  void markAsReadLocally(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx == -1) return;

    final current = notifications[idx];
    if (current.isRead) return;

    notifications[idx] = current.copyWith(isRead: true);
    if (unreadCount.value > 0) unreadCount.value -= 1;
  }

  Future<void> handleTap(AppNotification n) async {
    print("🔔 Notification Tapped: ${n.type}");
    markAsReadLocally(n.id);

    switch (n.type) {
      case 'chat':
        final chat = n.chat;
        final chatId = chat?.id ?? n.chatId;

        if (chatId == null) {
          print("❌ Error: chatId is null");
          return;
        }

        final auth = Get.find<AuthController>().userModel;
        if (auth == null) {
          print("❌ Error: Auth user is null");
          return;
        }
        final myId = auth.id!;

        // Use the improved helper
        String? rawCustId = _extractId(chat?.customerId ?? chat?.customer);
        String? rawVendId = _extractId(chat?.vendorId ?? chat?.vendor);

        final sellerId = (myId == rawCustId) ? rawVendId : rawCustId;

        if (sellerId == null) {
          print("❌ Error: sellerId is null (myId: $myId, cust: $rawCustId, vend: $rawVendId)");
          return;
        }

        final chatType = chat?.type ?? 'product-chat';

        // Determine targetId (Product or Service)
        String? targetId;
        if (chatType == 'job-chat') {
          targetId = n.serviceId ?? chat?.serviceId ?? _extractId(chat?.service);
        } else {
          targetId = n.productId ?? chat?.productId ?? _extractId(chat?.product);
        }

        if (targetId == null) {
          print("❌ Error: targetId still null. Chat Object: ${chat?.id}, ProductID Field: ${chat?.productId}");
          return;
        }

        print("🚀 Accessing Chat: $chatId with Seller: $sellerId");

        await Get.find<ChatController>().accessExistingChat(
          chatId: chatId,
          productId: targetId,
          sellerId: sellerId,
          userId: myId,
          currentChat: chat,
        );
        break;

      case 'job':
        final jobId = n.service?.id ?? n.serviceId;
        if (jobId == null) return;

        Get.toNamed(AppRoutes.jobDetailsScreen, arguments: {'jobId': jobId});
        break;

      case 'quote':
        final quoteId = n.quote?.id ?? n.quoteId;
        if (quoteId == null) return;

        await Get.find<JobController>().getQuoteDetails(quoteId);
        break;

      case 'product':
        if (n.product != null) {
          Get.to(() => ProductDetailsScreen(product: n.product!));
        } else if (n.productId != null) {
          final product = ProductModel();
          Get.to(() => ProductDetailsScreen(product: product));
        }
        break;

      default:
        Get.toNamed(
          AppRoutes.notificationScreen,
          arguments: {'notification': n},
        );
        break;
    }
  }

  String? _extractId(dynamic data) {
    if (data == null) return null;
    if (data is String) return data; // If it's already a string, just return it
    if (data is Map) return (data['id'] ?? data['_id'])?.toString();
    // If it's a model (like UserModel), try to access the id property
    try { return data.id; } catch (_) {}
    return null;
  }

}
