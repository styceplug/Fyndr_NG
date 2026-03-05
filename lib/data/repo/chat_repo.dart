import 'dart:io';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:http/http.dart' as http;

import '../../model/dispute_model.dart';


class ChatRepo {
  final ApiClient apiClient;

  ChatRepo({required this.apiClient});




  // ==================== CREATE_DISPUTE ====================
  Future<Response> createDispute(CreateDisputeRequest payload) async {
    return await apiClient.postData(AppConstants.DISPUTES, payload.toJson());
  }


  // ==================== INITIATE CHAT ====================

  Future<Response> initiateChat(String jobId, Map<String, String> body) async {
    return await apiClient.postData('/api/v1/job/$jobId/chat', body);
  }

  Future<Response> initiateProductChat(String productId, Map<String, String> body) async {
    return await apiClient.postData('/api/v1/product/$productId/chat', body);
  }

  // ==================== GET CHAT DETAILS ====================

  Future<Response> getChatDetails(String chatId) async {
    return await apiClient.getData('/api/v1/chat/$chatId');
  }

  // ==================== GET CUSTOMER CHATS ====================

  Future<Response> getCustomerChats({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      '/api/v1/chat/customer?page=$page&limit=$limit',
    );
  }

  // ==================== GET VENDOR CHATS ====================

  Future<Response> getVendorChats({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      '/api/v1/chat/vendor?page=$page&limit=$limit',
    );
  }

  // ==================== MARK CHAT AS READ ====================

  Future<Response> markAsRead(String chatId) async {
    return await apiClient.getData('/api/v1/chat/$chatId/read');
  }

  // ==================== SEND TEXT MESSAGE ====================

  Future<Response> sendMessage(String chatId, Map<String, dynamic> body) async {
    return await apiClient.postData('/api/v1/chat/$chatId/message', body);
  }

  // ==================== SEND AUDIO MESSAGE ====================

  Future<Response> sendAudioMessage(String chatId, File audioFile) async {
    // Ensure the URL is correct
    String url = '${apiClient.appBaseUrl}/api/v1/chat/$chatId/message';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // 1. Add Headers (CRITICAL: Auth token is needed)
    request.headers.addAll({
      'Authorization': 'Bearer ${apiClient.token}', // Ensure you get the token from shared prefs or auth controller
      'Content-Type': 'multipart/form-data',
    });

    request.fields['type'] = 'audio';

    // 2. FIX: Explicitly set Content-Type to audio/mp4
    request.files.add(await http.MultipartFile.fromPath(
      'audio',
      audioFile.path,
      contentType: MediaType('audio', 'mp4'), // 👈 FIXES 415 ERROR
    ));

    return await apiClient.postMultipartData('/api/v1/chat/$chatId/message', request);
  }
}