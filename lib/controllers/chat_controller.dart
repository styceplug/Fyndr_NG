import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:fyndr_ng/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:fyndr_ng/data/repo/chat_repo.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/socket_service.dart';
import '../model/chat_model.dart';
import 'package:flutter/material.dart';

import 'package:record/record.dart';
import 'dart:io';

import '../model/user_model.dart';
import '../routes/routes.dart';

class ChatController extends GetxController {
  final ChatRepo chatRepo;
  final SocketService socketService;

  ChatController({required this.chatRepo, required this.socketService});

  final messageCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();
  AudioRecorder? _audioRecorder;

  AudioRecorder get audioRecorder {
    _audioRecorder ??= AudioRecorder();
    return _audioRecorder!;
  }

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();

  bool get isMessageEmpty => messageCtrl.text.trim().isEmpty;
  ChatModel? currentChat;
  List<MessageModel> messages = [];
  bool isLoading = false;
  bool isSending = false;
  bool isTyping = false;
  bool isRemoteUserTyping = false;
  bool isRecording = false;
  RxBool isOtherUserOnline = false.obs;
  String? otherUserLastSeen;
  String? currentUserId;
  String? _recordingPath;
  List<ChatModel> vendorChats = [];
  List<ChatModel> customerChats = [];
  RxList<Map<String, dynamic>> statuses = RxList<Map<String, dynamic>>([]);
  Timer? _statusPollTimer;
  Timer? _lastSeenTicker;
  DateTime _now = DateTime.now();
  DateTime get now => _now;
  String? _blockedBy;
  String? get blockedBy => _blockedBy;
  bool get isChatBlocked => _blockedBy != null && _blockedBy!.isNotEmpty;
  bool get iBlockedThisChat {
    if (_blockedBy == null || currentUserId == null) return false;
    return _blockedBy == currentUserId;
  }






  @override
  void onInit() {
    super.onInit();
    currentUserId = Get.find<AuthController>().userModel?.id;
    print("🔌 ChatController Init: Checking Socket...");
    if (!socketService.isConnected()) {
      print("🔌 Socket disconnected. Initializing now...");
      socketService.initSocket();
    }
    _setupSocketListeners();
    _startLastSeenTicker();
  }


  @override
  void onClose() {
    if (currentChat?.id != null) {
      socketService.leaveChat(currentChat!.id!);
      if (isTyping) {
        socketService.sendTyping(currentChat!.id!, false);
      }
    }
    _stopLastSeenTicker();
    messageCtrl.dispose();
    scrollCtrl.dispose();
    _audioRecorder?.dispose();
    _statusPollTimer?.cancel();
    super.onClose();
  }

  UserModel? get otherUser {
    if (currentChat == null || currentUserId == null) return null;

    final myId = _cleanId(currentUserId);
    final vendorId = _extractUserId(currentChat!.vendor);

    // Am I the vendor?
    if (myId == vendorId) {
      return currentChat!.customer; // Then talk to customer
    } else {
      return currentChat!.vendor; // Otherwise talk to vendor
    }
  }

  UserModel? get chatPartner {
    if (currentChat == null) return null;

    final role = Get.find<AuthController>().userModel?.currentRole; // "vendor" | "customer"

    if (role == 'vendor') {
      return currentChat!.customer; // vendor talks to customer
    }
    return currentChat!.vendor; // customer talks to vendor
  }

  String? get chatPartnerId => chatPartner?.id ?? chatPartner?.id;


  void _syncBlockedStateFromChat() {
    _blockedBy = currentChat?.blockedBy;
  }


  Future<void> blockCurrentChat() async {
    final chatId = currentChat?.id;
    if (chatId == null || chatId.isEmpty) {
      CustomSnackBar.failure(message: 'Unable to block this chat.');
      return;
    }

    loader.showLoader();
    update();

    final response = await chatRepo.blockChat(chatId);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body?['success'] == true) {
      final data = response.body?['data'];

      _blockedBy = data?['blockedBy']?.toString();
      if (currentChat != null) {
        currentChat!.blockedBy = _blockedBy;
      }

      update();
      CustomSnackBar.success(message: response.body?['message'] ?? 'Chat blocked');
      return;
    }

    update();
  }

  Future<void> unblockCurrentChat() async {
    final chatId = currentChat?.id;
    if (chatId == null || chatId.isEmpty) {
      CustomSnackBar.failure(message: 'Unable to unblock this chat.');
      return;
    }

    loader.showLoader();
    update();

    final response = await chatRepo.unblockChat(chatId);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body?['success'] == true) {
      final data = response.body?['data'];

      _blockedBy = data?['blockedBy']?.toString();
      if (_blockedBy == 'null') _blockedBy = null;

      if (currentChat != null) {
        currentChat!.blockedBy = _blockedBy;
      }

      update();
      CustomSnackBar.success(
        message: response.body?['message'] ?? 'Chat unblocked',
      );
      return;
    }


    update();
  }



  void _startLastSeenTicker() {
    _lastSeenTicker?.cancel();
    _lastSeenTicker = Timer.periodic(const Duration(minutes: 1), (_) {
      update(['chat_status']);
    });
  }

  void _stopLastSeenTicker() {
    _lastSeenTicker?.cancel();
    _lastSeenTicker = null;
  }


  Future<void> accessExistingChat({
    required String chatId,
    required String productId,
    required String sellerId,
    required String userId,
    ChatModel? currentChat,
  }) async {
    loader.showLoader();
    update();

    try {
      // 1. Fetch the rich data from API
      await loadChatDetails(chatId);

      // 2. Only overwrite if loadChatDetails failed to populate currentChat
      if (this.currentChat == null && currentChat != null) {
        this.currentChat = currentChat;
      }

      markAsRead();

      // 3. Navigate
      Get.toNamed(
        AppRoutes.chatScreen,
        arguments: {
          "customer": userId,
          "vendor": sellerId,
          "product": productId,
          "chatId": chatId,
          "type": this.currentChat?.type ?? "product-chat",
        },
      )?.then((_) {
        getChatLists();
      });
    } catch (e) {
      print('❌ Error entering chat: $e');
      CustomSnackBar.failure(message: "Could not load chat");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  Future<void> getChatLists() async {
    loader.showLoader();
    update();

    try {
      // Fetch both simultaneously for speed
      var results = await Future.wait([
        chatRepo.getVendorChats(),
        chatRepo.getCustomerChats(),
      ]);

      Response vendorResponse = results[0];
      Response customerResponse = results[1];

      // 1. Process Vendor (Selling) Chats
      if (vendorResponse.statusCode == 200) {
        vendorChats = [];
        vendorResponse.body['data'].forEach((chat) {
          vendorChats.add(ChatModel.fromJson(chat));
        });
      }

      // 2. Process Customer (Buying) Chats
      if (customerResponse.statusCode == 200) {
        customerChats = [];
        customerResponse.body['data'].forEach((chat) {
          customerChats.add(ChatModel.fromJson(chat));
        });
      }
    } catch (e) {
      print("Error fetching chat lists: $e");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  String? get otherUserId {
    if (currentChat == null || currentUserId == null) {
      print('${currentChat}, ${currentUserId}');
      print('currentChat is null');
      return null;
    }
    final myId = _cleanId(currentUserId);

    // Extract IDs from chat object - handle both String and Map types
    final custId = _extractUserId(currentChat!.customer);
    final vendId = _extractUserId(currentChat!.vendor);

    print("🔍 My ID: $myId");
    print("🔍 Customer ID: $custId");
    print("🔍 Vendor ID: $vendId");

    // Return the ID that's NOT mine
    final otherId = (myId == custId) ? vendId : custId;
    print("🔍 Other User ID: $otherId");

    return otherId;
  }

  String _extractUserId(dynamic userObject) {
    if (userObject == null) return '';

    // If it's already a string, return it
    if (userObject is String) return userObject.trim();

    // If it's a Map (user object), extract the ID
    if (userObject is Map) {
      final id = userObject['id'] ?? userObject['_id'] ?? '';
      return id.toString().trim();
    }

    // If it's a UserModel object, use its id property
    if (userObject is UserModel) {
      return userObject.id ?? '';
    }

    return userObject.toString().trim();
  }

  String _cleanId(dynamic value) {
    if (value == null) return '';
    if (value is Map) return value['id'] ?? value['_id'] ?? '';
    return value.toString().trim();
  }

  void _setupSocketListeners() {
    // 1. Listen for New Messages
    socketService.socket.on('message:new', (data) {
      print('📩 New Socket Message: $data');

      // Handle both chatId and chat field
      String? messageChatId = data['chatId'] ?? data['chat'];

      if (messageChatId == currentChat?.id) {
        // Check if message is from another user to prevent duplicates
        String? senderId = _extractUserId(data['senderId'] ?? data['sender']);

        if (senderId != currentUserId) {
          final newMessage = MessageModel.fromJson(data);

          // Check if message already exists (prevent duplicates)
          bool exists = messages.any((msg) => msg.id == newMessage.id);
          if (!exists) {
            messages.add(newMessage);
            _scrollToBottom();
            markAsRead();
            update();
          }
        }
      }
    });

    // 2. Listen for Typing Updates
    socketService.socket.on('typing:update', (data) {
      print('⌨️ Typing Update: $data');

      if (data['chatId'] == currentChat?.id &&
          _extractUserId(data['userId']) != currentUserId) {
        isRemoteUserTyping = data['isTyping'] ?? false;
        update();
      }
    });

    // 3. Listen for New Chats Created
    socketService.socket.on('chat:created', (data) {
      print('💬 New Chat Created: $data');
      // Handle new chat notification if needed
    });

    // 4. Listen for Read Receipts
    socketService.socket.on('messages:read', (data) {
      print('✓✓ Messages Read: $data');
      // Update message read status if needed
      if (data['chatId'] == currentChat?.id) {
        // Mark messages as read in UI
        update();
      }
    });

    // 5. Handle Single User Status Update (Broadcast)
    socketService.socket.on('user:status', (data) {
      print('👤 User Status Event Received: $data');

      final userId = _extractUserId(data['userId']);
      final isOnline =
          data['isOnline'] == true || data['isOnline'].toString() == 'true';

      // Update the list (Source of Truth)
      int index = statuses.indexWhere((s) => s['userId'] == userId);
      if (index != -1) {
        statuses[index]['isOnline'] = isOnline;
        statuses.refresh();
      } else {
        statuses.add({'userId': userId, 'isOnline': isOnline});
      }

      // Update the specific chat boolean
      if (userId == otherUserId) {
        isOtherUserOnline.value = isOnline;
        if (data['lastSeen'] != null) {
          otherUserLastSeen = data['lastSeen'];
        }
      }
      update();
    });

    // 6. Handle Full List (Initial Join)
    socketService.socket.on('chat:participant-info', (data) {
      print('👥 Participant Info Received: $data');

      final participants = (data is Map && data['participants'] is List)
          ? List.from(data['participants'])
          : <dynamic>[];

      // ✅ If backend sent no participant list, DO NOT wipe your existing state
      if (participants.isEmpty) {
        print("⚠️ participant-info has empty participants, skipping clear()");
        return;
      }

      statuses.clear();

      for (final item in participants) {
        if (item is Map) {
          final userId = _extractUserId(item['userId'] ?? item['id']);
          final isOnline = item['isOnline'] == true || item['isOnline'].toString() == 'true';
          statuses.add({'userId': userId, 'isOnline': isOnline});

          if (userId == otherUserId) {
            isOtherUserOnline.value = isOnline;
            otherUserLastSeen = item['lastSeen']?.toString();
          }
        }
      }

      statuses.refresh();
      update(['chat_status']);
    });


    // 7. Connection Events
    socketService.socket.on('connect', (_) {
      print('✅ Socket Connected');
      if (currentUserId != null) {
        socketService.authenticate(currentUserId!);
      }
      // Re-join chat if we have one loaded
      if (currentChat?.id != null) {
        socketService.joinChat(currentChat!.id!);

        Future.delayed(const Duration(milliseconds: 500), () {
          final otherId = otherUserId;
          if (otherId != null) {
            socketService.requestUserStatus(otherId);
          }
        });
      }
    });

    socketService.socket.on('disconnect', (reason) {
      print('❌ Socket Disconnected: $reason');
      // Set other user as offline when we disconnect
      isOtherUserOnline.value = false;
      update();
    });

    socketService.socket.on('connect_error', (error) {
      print('⚠️ Socket Connection Error: $error');
    });

    socketService.socket.on('user:connected', (data) {
      print('👋 User Connected Event: $data');

      final connectedUserId = _extractUserId(data['userId']);
      final targetOtherId = otherUserId;

      if (connectedUserId.isNotEmpty &&
          targetOtherId != null &&
          connectedUserId == targetOtherId) {
        print("✅ Chat partner came online!");
        isOtherUserOnline.value = true;
        otherUserLastSeen = null;
        update();
      }
    });
    socketService.socket.on('user:disconnected', (data) {
      print('👋 User Disconnected Event: $data');

      final disconnectedUserId = _extractUserId(data['userId']);
      final targetOtherId = otherUserId;

      if (disconnectedUserId.isNotEmpty &&
          targetOtherId != null &&
          disconnectedUserId == targetOtherId) {
        print("❌ Chat partner went offline");
        isOtherUserOnline.value = false;
        otherUserLastSeen =
            data['lastSeen'] ?? DateTime.now().toIso8601String();
        update();
      }
    });
  }

  Future<void> initiateChat(
    String jobId,
    String customerId,
    String vendorId,
  ) async {
    isLoading = true;
    update();

    final body = {
      "customer": customerId,
      "vendor": vendorId,
      "service": jobId,
      "type": "job-chat",
    };

    try {
      final response = await chatRepo.initiateChat(jobId, body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        String chatId = response.body['data']['id'];
        await loadChatDetails(chatId);

        Get.toNamed(
          AppRoutes.chatScreen,
          arguments: {'chatId': chatId, 'type': 'job-chat'},
        );
      } else {
        CustomSnackBar.failure(
          message:
              response.body['message'] ??
              response.body['error'] ??
              "Could not start chat",
        );
      }
    } catch (e) {
      print('❌ Error initiating job chat: $e');
      CustomSnackBar.failure(message: "Network error, please try again");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> initiateProductChat({
    required String productId,
    required String sellerId,
    required String userId,
  }) async {
    // 1. Validation
    final currentUser = Get.find<AuthController>().userModel;
    if (currentUser == null) {
      CustomSnackBar.failure(message: "You must be logged in to chat");
      return;
    }

    if (currentUser.id == sellerId) {
      CustomSnackBar.failure(message: "You cannot chat with yourself");
      return;
    }

    loader.showLoader();
    update();

    final body = {
      "customer": userId,
      "vendor": sellerId,
      "product": productId,
      "type": "product-chat",
    };

    try {
      final response = await chatRepo.initiateProductChat(productId, body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        String chatId = response.body['data']['id'];

        // 4. Load & Navigate
        await loadChatDetails(chatId);

        Get.toNamed(
          AppRoutes.chatScreen,
          arguments: {'chatId': chatId, 'type': 'product-chat'},
        );
      } else {
        CustomSnackBar.failure(
          message:
              response.body['message'] ??
              response.body['error'] ??
              "Could not start chat",
        );
      }
    } catch (e) {
      print('❌ Error initiating product chat: $e');
      CustomSnackBar.failure(message: "Network error");
    } finally {
      loader.hideLoader();
      update();
    }
  }


  Future<void> loadChatDetails(String chatId) async {
    isLoading = true;
    update();

    try {
      final response = await chatRepo.getChatDetails(chatId);

      if (response.statusCode == 200) {
        currentChat = ChatModel.fromJson(response.body['data']);
        messages = currentChat?.messages ?? [];
        _syncBlockedStateFromChat();

        // 1. Connection Check
        if (!socketService.isConnected()) {
          socketService.initSocket();
          // The 'connect' listener will handle the request automatically
        } else {
          socketService.joinChat(chatId);

          Future.delayed(const Duration(milliseconds: 500), () {
            final otherId = otherUserId;
            if (otherId != null) {
              socketService.requestUserStatus(otherId);
            }
          });

          _startStatusPolling();
        }


        await markAsRead();
        update();
        _scrollToBottom();
      }
    } catch (e) {
      print('❌ Error loading chat: $e');
    } finally {
      isLoading = false;
      update();
    }
  }


  void _startStatusPolling() {
    _statusPollTimer?.cancel();
    _statusPollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final otherId = otherUserId;
      if (otherId != null && socketService.isConnected()) {
        socketService.requestUserStatus(otherId);
      }
    });
  }

  Future<void> markAsRead() async {
    if (currentChat?.id == null) return;

    // Optimistic Update: Reset local counts immediately so UI feels responsive
    currentChat!.customerUnreadCount = 0;
    currentChat!.vendorUnreadCount = 0;

    try {
      print("👀 Marking chat ${currentChat!.id} as read...");
      final response = await chatRepo.markAsRead(currentChat!.id!);

      if (response.statusCode == 200) {
        print("✅ Chat marked as read successfully");
      } else {
        print("⚠️ Mark as read failed: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error marking as read: $e');
    }
  }

  // ==================== SEND TEXT MESSAGE ====================

  Future<void> sendMessage() async {
    if (isChatBlocked) {
      CustomSnackBar.failure(
        message: iBlockedThisChat
            ? 'You blocked this chat. Unblock it to continue messaging.'
            : 'This chat has been blocked. Messaging is disabled.',
      );
      return;
    }

    String text = messageCtrl.text.trim();
    if (text.isEmpty || currentChat?.id == null) return;

    isSending = true;
    update();

    final body = {"text": text, "type": "text"};

    try {
      final response = await chatRepo.sendMessage(currentChat!.id!, body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        messageCtrl.clear();

        // Add message to local list
        final newMessage = MessageModel.fromJson(response.body['data']);
        messages.add(newMessage);

        // Stop typing indicator
        if (isTyping) {
          isTyping = false;
          socketService.sendTyping(currentChat!.id!, false);
        }

        _scrollToBottom();
      } else {
        print("❌ Send Error: ${response.body}");
        CustomSnackBar.failure(
          message: response.body['error'] ?? "Failed to send message",
        );
      }
    } catch (e) {
      print("❌ Send Exception: $e");
      CustomSnackBar.failure(message: "Network error, please try again");
    } finally {
      isSending = false;
      update();
    }
  }

  // ==================== TYPING INDICATOR ====================

  void handleTyping(String value) {
    if (currentChat?.id == null) return;

    update();

    if (value.isNotEmpty && !isTyping) {
      isTyping = true;
      socketService.sendTyping(currentChat!.id!, true);
    } else if (value.isEmpty && isTyping) {
      isTyping = false;
      socketService.sendTyping(currentChat!.id!, false);
    }
  }

  // ==================== AUDIO RECORDING ====================

  Future<void> toggleRecording() async {
    var status = await Permission.microphone.status;

    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      if (isRecording) {
        await stopRecordingAndSend();
      } else {
        await startRecording();
      }
    } else if (status.isPermanentlyDenied) {
      CustomSnackBar.failure(
        message: "Microphone blocked. Please enable in settings.",
      );
      await Future.delayed(const Duration(seconds: 2));
      openAppSettings();
    } else {
      CustomSnackBar.failure(message: "Microphone permission is required");
    }
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        _recordingPath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _recordingPath!,
        );

        isRecording = true;
        print("🎤 Recording started at: $_recordingPath");
        update();
      }
    } catch (e) {
      print("❌ Recording Error: $e");
      CustomSnackBar.failure(message: "Failed to start recording");
    }
  }

  Future<void> stopRecordingAndSend() async {
    try {
      final path = await audioRecorder.stop();

      isRecording = false;
      update();

      if (path != null && currentChat?.id != null) {
        print("🎤 Recording stopped. File saved at: $path");
        await sendAudioMessage(File(path));
      }
    } catch (e) {
      print("❌ Stop Recording Error: $e");
      if (isRecording) {
        CustomSnackBar.failure(message: "Failed to send audio");
      }
      isRecording = false;
      update();
    }
  }

  Future<void> sendAudioMessage(File audioFile) async {
    if (currentChat?.id == null) return;

    isSending = true;
    update();

    try {
      final response = await chatRepo.sendAudioMessage(
        currentChat!.id!,
        audioFile,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            print("Error decoding success body: $e");
          }
        }

        final newMessage = MessageModel.fromJson(body['data']);
        messages.add(newMessage);
        _scrollToBottom();

        // Delete local file after successful upload
        if (await audioFile.exists()) {
          await audioFile.delete();
        }
      } else {
        var errorBody = response.body;
        if (errorBody is String) {
          try {
            errorBody = jsonDecode(errorBody);
          } catch (e) {
            errorBody = {};
          }
        }

        print("❌ Audio Send Error: $errorBody");

        String errorMessage =
            (errorBody is Map && errorBody['error'] != null)
                ? errorBody['error']
                : "Failed to send audio message";

        CustomSnackBar.failure(message: errorMessage);
      }
    } catch (e) {
      print("❌ Audio Send Exception: $e");
      CustomSnackBar.failure(message: "Network error, please try again");
    } finally {
      isSending = false;
      update();
    }
  }

  // ==================== SCROLL TO BOTTOM ====================

  void _scrollToBottom() {
    if (scrollCtrl.hasClients) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (scrollCtrl.hasClients) {
          scrollCtrl.animateTo(
            scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  // ==================== REFRESH CHAT ====================

  Future<void> refreshChat() async {
    if (currentChat?.id != null) {
      await loadChatDetails(currentChat!.id!);
    }
  }
}
