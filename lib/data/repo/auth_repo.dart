import 'dart:io';
import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AuthRepo extends GetConnect {

  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});



  Future<Response> updateAvailability(bool isAvailable) async {
    return await apiClient.putData(
      AppConstants.UPDATE_AVAILABILITY,
      {'isAvailable': isAvailable},
    );
  }

  Future<Response> registerVendor(
      String uri,
      Map<String, String> body,
      List<MultipartBody> fileList,
      ) async {
    final formData = FormData(body);

    for (final item in fileList) {
      if (!item.file.existsSync()) continue;

      final filePath = item.file.path;
      final fileName = p.basename(filePath);

      // Detect MIME type
      final mimeType = lookupMimeType(filePath) ?? 'image/jpeg';

      formData.files.add(
        MapEntry(
          item.key,
          MultipartFile(
            filePath,
            filename: fileName,
            contentType: mimeType, // ✅ STRING (this fixes 415)
          ),
        ),
      );
    }

    return await apiClient.postData(uri, formData);
  }


  Future<Response> updateAvatar(File imageFile) async {
    String url = '${apiClient.appBaseUrl}/api/v1/user/avatar';

    var request = http.MultipartRequest('PUT', Uri.parse(url));

    request.headers.addAll({
      'Authorization': 'Bearer ${apiClient.token}',
      'Content-Type': 'multipart/form-data',
    });

    // 👇 FIX: Add contentType
    request.files.add(await http.MultipartFile.fromPath(
      'avatar',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    return await apiClient.postMultipartData('/api/v1/user/avatar', request);
  }


  Future<Response> switchUserRole() async {
    return await apiClient.putData(AppConstants.SWITCH_ROLE_URI, {});
  }

  Future<Response> login(String number, String password) async {
    final body = {
      "number": number,
      "password": password,
    };
    return await apiClient.postData(AppConstants.POST_LOGIN, body);
  }

  Future<Response> registerCustomer(String name, String number, String password) async {
    final body = {
      "name": name,
      "number": number,
      "password": password,
    };
    return await apiClient.postData(AppConstants.POST_REGISTER_CUSTOMER, body);
  }

  Future<Response> verifyOtp(String number, String otp) async {
    final body = {
      "number": number,
      "otp": otp,
    };
    return await apiClient.postData(AppConstants.POST_VERIFY_OTP, body);
  }

  Future<Response> resendOtp(String number) async {
    final body = {
      "number": number,
    };
    return await apiClient.postData(AppConstants.POST_RESEND_OTP, body);
  }

  Future<Response> getUserProfile() async {
    return await apiClient.getData(AppConstants.GET_USER_PROFILE);
  }

  Future<Response> updateProfile({
    required String name,
    required String email,
    required String state,
    required String lga,
  }) async {
    final body = {
      "name": name,
      "email": email,
      "location": {
        "state": state,
        "lga": lga,
        "type": "Point",
        "coordinates": [0.00, 0.00]
      }
    };
    return await apiClient.putData(AppConstants.PUT_UPDATE_PROFILE, body);
  }


  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.authToken);
  }



}