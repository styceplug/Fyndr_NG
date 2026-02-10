import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fyndr_ng/utils/app_constants.dart';

class SocketService {
  late IO.Socket socket;
  bool _isInitialized = false;



  void requestUserStatus(String userId) {
    if (!_isInitialized) {
      print('⚠️ Socket not initialized. Call initSocket() first.');
      return;
    }

    print('🔍 Requesting status for user: $userId');
    socket.emit('request:user:status', {'userId': userId});
  }


  // ==================== INITIALIZE SOCKET ====================

  void initSocket() {
    if (_isInitialized) {
      print('⚠️ Socket already initialized');
      return;
    }

    String baseUrl = AppConstants.BASE_URL;

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    socket.onConnect((_) {
      print('✅ Socket Connected: ${socket.id}');
      _isInitialized = true;
    });

    socket.onDisconnect((_) {
      print('❌ Socket Disconnected');
    });

    socket.onConnectError((error) {
      print('⚠️ Socket Connection Error: $error');
    });

    socket.onError((error) {
      print('⚠️ Socket Error: $error');
    });

    socket.connect();
  }

  // ==================== AUTHENTICATE ====================

  void authenticate(String userId) {
    if (!_isInitialized) {
      print('⚠️ Socket not initialized. Call initSocket() first.');
      return;
    }

    print('🔐 Authenticating user: $userId');
    socket.emit('authenticate', userId);
  }

  // ==================== JOIN CHAT ====================

  void joinChat(String chatId) {
    if (!_isInitialized) {
      print('⚠️ Socket not initialized. Call initSocket() first.');
      return;
    }

    print('👋 Joining chat: $chatId');
    socket.emit('join:chat', chatId);
  }

  // ==================== LEAVE CHAT ====================

  void leaveChat(String chatId) {
    if (!_isInitialized) {
      print('⚠️ Socket not initialized. Call initSocket() first.');
      return;
    }

    print('👋 Leaving chat: $chatId');
    socket.emit('leave:chat', chatId);
  }

  // ==================== SEND TYPING INDICATOR ====================

  void sendTyping(String chatId, bool isTyping) {
    if (!_isInitialized) {
      print('⚠️ Socket not initialized. Call initSocket() first.');
      return;
    }

    if (isTyping) {
      print('⌨️ User started typing in chat: $chatId');
      socket.emit('typing:start', {'chatId': chatId});
    } else {
      print('⌨️ User stopped typing in chat: $chatId');
      socket.emit('typing:stop', {'chatId': chatId});
    }
  }

  // ==================== DISCONNECT ====================

  void disconnect() {
    if (_isInitialized) {
      socket.disconnect();
      _isInitialized = false;
      print('🔌 Socket disconnected manually');
    }
  }

  // ==================== RECONNECT ====================

  void reconnect() {
    if (!_isInitialized) {
      initSocket();
    } else {
      socket.connect();
    }
  }

  // ==================== CHECK CONNECTION STATUS ====================

  bool isConnected() {
    return _isInitialized && socket.connected;
  }
}