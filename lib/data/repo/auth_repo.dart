import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';

class AuthRepo extends GetConnect {

  Future<Response> login(String number, String password) async {
    final body = {
      "number": number,
      "password": password,
    };
    return await post(AppConstants.POST_LOGIN, body);
  }

  Future<Response> registerCustomer(String name, String number, String password) async {
    final body = {
      "name": name,
      "number": number,
      "password": password,
    };
    return await post(AppConstants.POST_REGISTER_CUSTOMER, body);
  }

  Future<Response> verifyOtp(String number, String otp) async {
    final body = {
      "number": number,
      "otp": otp,
    };
    return await post(AppConstants.POST_VERIFY_OTP, body);
  }

  Future<Response> resendOtp(String number) async {
    final body = {
      "number": number,
    };
    return await post(AppConstants.POST_RESEND_OTP, body);
  }

  Future<Response> getUserProfile() async {
    return await get(AppConstants.GET_USER_PROFILE);
  }
}