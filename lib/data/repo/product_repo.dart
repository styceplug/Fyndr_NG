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

  Future<Response> getProducts({
    required double lat,
    required double lng,
    double maxDistance = 50000 // Default to 50km radius
  }) async {
    // Construct the URL with query parameters
    // Assuming AppConstants.ALL_PRODUCTS_URI is "/api/v1/product"
    String uri = '${AppConstants.GET_PRODUCT}?page=1&limit=20&lat=$lat&lng=$lng&maxDistance=$maxDistance';

    return await apiClient.getData(uri);
  }


  Future<Response> createProduct({
    required String name,
    required bool isFree,
    required String? price,
    required String condition,
    required double lat, // Keeping as double
    required double lng, // Keeping as double
    required String description,
    required List<XFile> images,
  }) async {
    final uri = Uri.parse(apiClient.baseUrl! + AppConstants.CREATE_PRODUCT);
    final request = http.MultipartRequest('POST', uri);

    // 1. Send NORMAL TEXT fields
    request.fields['name'] = name;
    request.fields['condition'] = condition;
    request.fields['description'] = description;

    // 2. SEND NUMBERS/BOOLEANS AS "JSON PARTS"
    // This tells the backend: "Do not treat this as a text string, treat it as a JSON value (Number/Boolean)"

    // Send Latitude
    request.files.add(
      http.MultipartFile.fromString(
        'lat',
        lat.toString(), // We send the characters "37.5", but...
        contentType: MediaType('application', 'json'), // ...this tells backend it's a Number
      ),
    );

    // Send Longitude
    request.files.add(
      http.MultipartFile.fromString(
        'lng',
        lng.toString(),
        contentType: MediaType('application', 'json'),
      ),
    );

    // Send Boolean
    request.files.add(
      http.MultipartFile.fromString(
        'isFree',
        isFree.toString(),
        contentType: MediaType('application', 'json'),
      ),
    );

    // Send Price (if exists)
    if (!isFree && price != null) {
      request.files.add(
        http.MultipartFile.fromString(
          'price',
          price,
          contentType: MediaType('application', 'json'),
        ),
      );
    }

    // 3. Add Images
    for (var image in images) {
      MediaType contentType = MediaType('image', 'jpeg');
      if (image.path.toLowerCase().endsWith('.png')) {
        contentType = MediaType('image', 'png');
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'images',
          await File(image.path).readAsBytes(),
          filename: image.name,
          contentType: contentType,
        ),
      );
    }

    return await apiClient.postMultipartData(AppConstants.CREATE_PRODUCT, request);
  }
}