import 'dart:convert';
import 'dart:io';

import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../data/repo/auth_repo.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  final ApiClient apiClient;

  AuthController({required this.authRepo, required this.apiClient});

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();
  late AppController appController = Get.find<AppController>();
  UserModel? _userModel;
  final ImagePicker _picker = ImagePicker();
  UserModel? get userModel => _userModel;




  Future<void> attemptRoleSwitch() async {
    loader.showLoader();
    update();

    try {
      Response response = await authRepo.switchUserRole();

      if (response.statusCode == 200) {

        String newRole = response.body['data']['currentRole'];

        if (_userModel != null) {
          _userModel!.currentRole = newRole;
        }

        // 3. Dynamic Navigation based on the NEW role
        if (newRole == "vendor") {
          print("✅ Switched to Vendor Mode");
          CustomSnackBar.success(message: "Welcome back to your Vendor Dashboard");
          Get.offAllNamed(AppRoutes.vendorHomeScreen);

        } else {
          print("✅ Switched to Customer Mode");
          CustomSnackBar.success(message: "Switched to Customer Profile");
          Get.offAllNamed(AppRoutes.homeScreen); // Customer Home
        }

      } else if (response.statusCode == 400) {


        print("⚠️ Cannot switch: Vendor profile incomplete.");
        CustomSnackBar.processing(
            message: "Setup Required: Please complete your vendor registration first."
        );
        Get.offAllNamed(AppRoutes.getStartedScreen);

      } else {
        // --- OTHER ERRORS ---
        CustomSnackBar.failure(message: response.statusText ?? "Failed to switch role");
        Get.back();
      }

    } catch (e) {
      print("❌ Switch Role Error: $e");
      CustomSnackBar.failure(message: "An error occurred");
      Get.back();
    } finally {
     loader.hideLoader();
      update();
    }
  }



  Future<void> pickAndUploadAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) return;

      loader.showLoader();
      update();

      Response response = await authRepo.updateAvatar(File(image.path));

      // 👇 FIX: Decode body safely before using it
      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (e) {
          body = {};
        }
      }

      if (response.statusCode == 200) {
        // Now safe to access ['data']
        String newAvatarUrl = body['data']['avatar'];

        if (userModel != null) {
          userModel!.avatar = newAvatarUrl;
          _userModel = UserModel.fromJson(body['data']);

        }

        CustomSnackBar.success(message: "Profile picture updated!");
      } else {
        // Now safe to access ['message'] or ['error']
        String errorMsg = body['message'] ?? body['error'] ?? "Failed to upload avatar";
        CustomSnackBar.failure(message: errorMsg);
      }
    } catch (e) {
      print("Avatar Upload Error: $e");
      CustomSnackBar.failure(message: "Something went wrong");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  Future<void> updateProfile(String name, String email, String state, String lga) async {
    loader.showLoader();
    update();

    Response response = await authRepo.updateProfile(
      name: name,
      email: email,
      state: state,
      lga: lga,
    );

    if (response.statusCode == 200) {
      var responseData = response.body['data'];
      _userModel = UserModel.fromJson(responseData);

      // Refresh the UI
      CustomSnackBar.success(message: "Profile updated successfully");
      getUserProfile();
      appController.changeCurrentAppPage(0);
      // Get.back();
    } else {
      String message = response.body['error'] ?? "Failed to update profile";
      if (response.statusCode == 409) {
        message = "This email is already in use.";
      }
      CustomSnackBar.failure(message: message);
    }

    loader.hideLoader();
    update();
  }

  Future<void> login(String number, String password) async {
    loader.showLoader();
    update();

    try {
      final response = await authRepo.login(number, password);

      // ✅ SUCCESS
      if (response.statusCode == 200) {
        final data = response.body['data'];
        final userJson = data['user'];
        final token = data['token'];

        _userModel = UserModel.fromJson(userJson);
        apiClient.updateHeader(token);

        // Save token if you do persistent login, then:
        await getUserProfile();

        // Role-based route
        _routeByRole(_userModel?.currentRole);
        return;
      }

      // ✅ OTP REQUIRED (inactive user, OTP sent)
      final code = response.body['code'];
      final error = response.body['error']?.toString() ?? "Login failed";

      if (code == "INACTIVE_USER") {

        Get.toNamed(
          AppRoutes.phoneVerificationScreen,
          arguments: {
            "number": number,
          },
        );
        return;
      }


      CustomSnackBar.failure(message: error);
    } catch (e) {
      CustomSnackBar.failure(message: "Connection error. Please try again.");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  void _routeByRole(String? role) {
    final r = (role ?? "customer").toLowerCase();

    if (r == "vendor") {
      Get.offAllNamed(AppRoutes.vendorHomePage);
    } else {
      Get.offAllNamed(AppRoutes.homeScreen);
    }
  }

  Future<void> registerCustomer(
    String name,
    String number,
    String password,
  ) async {
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
          message = "Account Exists: please login instead";
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

      Get.offAllNamed(AppRoutes.verifiedScreen);

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

  Future<void> getUserProfile() async {
    update();
    Response response = await authRepo.getUserProfile();
    if (response.statusCode == 200) {
      var responseData = response.body['data'];
      _userModel = UserModel.fromJson(responseData);
      print("Profile Acquired: ${_userModel!.name}");

      if (userModel?.currentRole == 'customer')
        Get.offAllNamed(AppRoutes.homeScreen);
      else
        Get.offAllNamed(AppRoutes.vendorHomePage);
    } else {
      if (response.statusCode == 401) {
        Get.offAllNamed(AppRoutes.getStartedScreen);
      }
      print("Failed to get profile: ${response.statusText}");
    }
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }


}
