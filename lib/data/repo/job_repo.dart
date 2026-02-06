import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class JobRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  JobRepo({required this.apiClient, required this.sharedPreferences});



  Future<Response> getMerchantAcceptedJobs({int page = 1, int limit = 20}) async {
    return await apiClient.getData(
        '/api/v1/job/merchant/accepted?page=$page&limit=$limit'
    );
  }

  Future<Response> getMerchantQuotes(int page) async {
    return await apiClient.getData('/api/v1/quote/merchant?page=$page&limit=10');
  }

  Future<Response> acceptQuote(String quoteId) async {
    return await apiClient.postData(AppConstants.ACCEPT_QUOTE(quoteId), {});
  }

  Future<Response> rejectQuote(String quoteId, Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.DECLINE_QUOTE(quoteId), body);
  }

  Future<Response> counterQuote(String quoteId, Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.COUNTER_QUOTE(quoteId), body);
  }

  Future<Response> getQuoteDetails(String quoteId) async {
    return await apiClient.getData(AppConstants.GET_QUOTE_DETAILS(quoteId));
  }


  Future<Response> submitQuoteMultipart({
    required Map<String, String> fields,
    required List<XFile> images,
  }) async {
    try {
      final uri = Uri.parse(apiClient.appBaseUrl + AppConstants.POST_JOB_QUOTE);
      print('📤 Submitting quote to: $uri');

      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${apiClient.token}",
      });
      print('🔑 Authorization token: ${apiClient.token?.substring(0, 20)}...');

      // Add fields
      request.fields.addAll(fields);
      print('📋 Request fields:');
      fields.forEach((key, value) {
        print('   $key: $value');
      });

      // Add images with proper content type
      final selected = images.length > 10 ? images.take(10).toList() : images;
      print('🖼️ Adding ${selected.length} images');

      for (int i = 0; i < selected.length; i++) {
        final img = selected[i];
        print('   Image ${i + 1}: ${img.path}');

        // Determine content type from file extension
        String? mimeType = _getMimeType(img.path);
        print('   MIME type: $mimeType');

        final multipartFile = await http.MultipartFile.fromPath(
          'images',
          img.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );

        request.files.add(multipartFile);
      }

      print('🚀 Sending request...');
      final streamed = await request.send();

      print('📥 Response status: ${streamed.statusCode}');
      print('📥 Response reason: ${streamed.reasonPhrase}');

      final bodyString = await streamed.stream.bytesToString();
      print('📥 Response body: $bodyString');

      final decoded = bodyString.isNotEmpty ? jsonDecode(bodyString) : {};

      return Response(
        body: decoded,
        statusCode: streamed.statusCode,
        statusText: streamed.reasonPhrase,
      );
    } catch (e, stackTrace) {
      print('❌ Error submitting quote: $e');
      print('❌ Stack trace: $stackTrace');
      return Response(
        body: {"success": false, "message": e.toString()},
        statusCode: 500,
      );
    }
  }

  String? _getMimeType(String path) {
    final extension = path.toLowerCase().split('.').last;

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg'; // Default to jpeg
    }
  }

  Future<Response> getMerchantLeads(int page, {int limit = 25}) async {
    return await apiClient.getData('${AppConstants.GET_MERCHANT_LEADS}?page=$page&limit=$limit');
  }

  Future<Response> getJobDetails(String jobId) async {
    return await apiClient.getData(AppConstants.GET_JOB_DETAILS(jobId));
  }

  Future<Response> getJobQuotes(String jobId) async {
    return await apiClient.getData(AppConstants.GET_JOB_QUOTES(jobId));
  }

  Future<Response> getUserJobs() async {
    return await apiClient.getData(AppConstants.GET_USER_JOBS);
  }

  Future<Response> createJob(Map<String, dynamic> jobData) async {
    return await apiClient.postData(AppConstants.POST_NEW_JOB, jobData);
  }

  Future<Response> createJobWithImages(http.MultipartRequest request) async {
    return await apiClient.postMultipartData(AppConstants.POST_NEW_JOB, request);
  }

}
