import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo extends GetConnect {

  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});


  Future<Response> registerVendor(String uri, Map<String, String> body, List<MultipartBody> fileList) async {
    // 1. Create FormData using the text fields
    // GetX's FormData constructor automatically handles the text fields
    FormData formData = FormData(body);

    // 2. Loop through the file list and add them to the FormData
    for (MultipartBody item in fileList) {
      if (item.file.existsSync()) {
        // 'files' is a list of MapEntry in GetX FormData
        formData.files.add(MapEntry(
          item.key,
          MultipartFile(item.file.path, filename: item.file.path.split('/').last),
        ));
      }
    }

    // 3. Send using postData (which accepts dynamic body)
    // The ApiClient will detect FormData and set Content-Type: multipart/form-data automatically
    return await apiClient.postData(uri, formData);
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