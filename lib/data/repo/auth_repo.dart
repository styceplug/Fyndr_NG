import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';

class AuthRepo extends GetConnect {

  final ApiClient apiClient;

  AuthRepo({required this.apiClient});


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


}