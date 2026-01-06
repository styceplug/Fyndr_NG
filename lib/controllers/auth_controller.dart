import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/widgets/snackbars.dart';
import 'package:get/get.dart';

import '../data/repo/auth_repo.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  final ApiClient apiClient;

  AuthController({required this.authRepo, required this.apiClient});

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<void> login(String number, String password) async {
    loader.showLoader();
    update();

    Response response = await authRepo.login(number, password);

    if (response.statusCode == 200) {
      var responseData = response.body['data'];
      _userModel = UserModel.fromJson(responseData['user']);
      String token = responseData['token'];

      print("Login Success: User ${_userModel!.name} logged in.");
      print(token);
      apiClient.updateHeader(token);
      if (userModel?.currentRole == 'customer') {
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        Get.offAllNamed(AppRoutes.vendorHomePage);
      }
    } else if (response.statusCode == 423) {
      print("Error: ${response.body['error']}");

      Get.toNamed(AppRoutes.phoneVerificationScreen);
    } else {
      print("Error: ${response.body['error']}");
      CustomSnackBar.failure(message: response.body['error'].toString());
    }

    loader.hideLoader();
    update();
  }

  Future<void> registerCustomer(String name, String number, String password) async {
    loader.showLoader();
    update();

    Response response = await authRepo.registerCustomer(name, number, password);

    if (response.statusCode == 201) {
      var responseData = response.body['data'];
      _userModel = UserModel.fromJson(responseData);

      print("Registration Successful: OTP sent to $number");
      Get.toNamed(
        AppRoutes.phoneVerificationScreen,
        arguments: {'number': number},
      );
    } else {

      String message;

      switch (response.statusCode) {
        case 409:
          message = "Account Exists: This phone number is already registered.";
          break;
        case 400:
          message = response.body['error'] ?? "Invalid Input";
          break;
        default:
          message = response.statusText ?? "Something went wrong";
      }

      CustomSnackBar.failure(message: message);
      print("Error: $message");
    }

    loader.hideLoader();
    update();
  }

  Future<void> verifyOtp(String number, String otp) async {
    loader.showLoader();
    update();

    Response response = await authRepo.verifyOtp(number, otp);

    if (response.statusCode == 200) {
      var responseData = response.body['data'];
      _userModel = UserModel.fromJson(responseData['user']);
      String token = responseData['token'];

      apiClient.updateHeader(token);

      print("Verification Success: User ${_userModel!.name} verified.");

      if (userModel?.currentRole == 'customer') {
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        Get.offAllNamed(AppRoutes.vendorHomePage);
      }
    } else {
      String errorMsg = response.body['error'] ?? "Verification failed";
      print("Error: $errorMsg");
      CustomSnackBar.failure(message: errorMsg);
    }

    loader.hideLoader();
    update();
  }

  Future<void> resendOtp(String number) async {
    loader.showLoader();
    update();

    Response response = await authRepo.resendOtp(number);

    if (response.statusCode == 200) {
      CustomSnackBar.success(message: "OTP has been resent to $number");
    } else {
      String errorMsg = response.body['error'] ?? "Failed to resend OTP";
      CustomSnackBar.failure(message: errorMsg);
    }

    loader.hideLoader();
    update();
  }
}
