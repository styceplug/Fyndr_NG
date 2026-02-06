import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' hide Response;

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class ProductRepo {
  final ApiClient apiClient;

  ProductRepo({required this.apiClient});




  Future<Response> getUserProducts({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
        '/api/v1/product/user/me?page=$page&limit=$limit'
    );
  }

  Future<Response> deleteProduct(String productId) async {
    return await apiClient.deleteData(
        '${AppConstants.BASE_URL}/api/v1/product/$productId'
    );
  }

  Future<Response> updateProduct(String productId, Map<String, dynamic> body) async {
    return await apiClient.putData(
        '${AppConstants.BASE_URL}/api/v1/product/$productId',
        body
    );
  }

  Future<Response> getProducts({int page = 1, String? userId}) async {
    String url = '${AppConstants.CREATE_PRODUCT}?page=$page&limit=20';
    if (userId != null) {
      url += '&user=$userId';
    }
    return await apiClient.getData(url);
  }


  Future<Response> createProduct({
    required String name,
    required bool isFree,
    required String? price,
    required String condition,
    required String state,
    required String lga,
    required String description,
    required List<XFile> images,
  }) async {
    // 1. Prepare Request
    final uri = Uri.parse(apiClient.baseUrl! + AppConstants.CREATE_PRODUCT);
    final request = http.MultipartRequest('POST', uri);

    // 3. Add Text Fields
    request.fields.addAll({
      'name': name,
      'isFree': isFree.toString(),
      'condition': condition,
      'state': state,
      'lga': lga,
      'description': description,
    });

    if (!isFree && price != null) {
      request.fields['price'] = price;
    }

    // 4. Add Images (Loop through list)
    for (var image in images) {
      // Determine MIME type (optional but recommended)
      MediaType contentType = MediaType('image', 'jpeg');
      if (image.path.toLowerCase().endsWith('.png')) {
        contentType = MediaType('image', 'png');
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'images', // Key name expected by backend
          await File(image.path).readAsBytes(),
          filename: image.name,
          contentType: contentType,
        ),
      );
    }

    // 5. Send via ApiClient wrapper
    return await apiClient.postMultipartData(AppConstants.CREATE_PRODUCT, request);
  }
}