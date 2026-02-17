import 'dart:convert';
import 'dart:io';

import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../data/api/api_checker.dart';
import '../data/repo/auth_repo.dart';
import '../helpers/push_notification.dart';
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

  Future<void> toggleUserAvailability(bool newValue) async {
    // 1. Get current status to revert if API fails
    bool previousStatus = userModel?.isAvailable ?? true;

    if (userModel != null) {
      userModel?.isAvailable = newValue;
      update();
    }

    // 3. Call API
    try {
      Response response = await authRepo.updateAvailability(newValue);

      if (response.statusCode == 200) {
        CustomSnackBar.success(
          message: newValue ? "Account is now Active" : "Account Paused",
        );
      } else {
        // 4. Failure: Revert UI
        _revertAvailability(previousStatus);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      // 5. Error: Revert UI
      _revertAvailability(previousStatus);
      print("Error toggling availability: $e");
      CustomSnackBar.failure(message: "Connection error");
    }
  }

  void _revertAvailability(bool status) {
    if (userModel != null) {
      userModel?.isAvailable = status;
      update();
    }
  }

  void handleSwitchAccountTap() {
    final user = userModel;
    if (user == null) return;

    if (user.currentRole == 'vendor') {
      // If I am Vendor, I DEFINITELY have a customer profile (base account)
      Get.toNamed(AppRoutes.switchScreen);
    } else {
      // I am Customer. Do I have a vendor profile?
      if (user.hasVendorProfile == true) {
        // Yes -> Go to Switch Screen
        Get.toNamed(AppRoutes.switchScreen);
      } else {
        // No -> Go to Become Vendor Screen (Passing flag to hide owner info)
        Get.toNamed(
          AppRoutes.becomeVendorScreen,
          arguments: {'isExistingUser': true},
        );
      }
    }
  }

  Future<void> attemptRoleSwitch() async {
    // 1. Show Global Loader
    Get.find<GlobalLoaderController>().showLoader();
    update();

    try {
      // 2. Call API
      Response response = await authRepo.switchUserRole();

      if (response.statusCode == 200) {
        // --- SUCCESS CASE ---
        var data = response.body['data'];
        String newRole = data['currentRole'];

        // Update Local Model
        if (_userModel != null) {
          _userModel!.currentRole = newRole;
          // Optionally update local storage if you cache the user object
        }

        // Navigate based on NEW role
        if (newRole == "vendor") {
          print("✅ Switched to Vendor Mode");
          CustomSnackBar.success(
            message: "Welcome back to your Vendor Dashboard",
          );
          appController.changeCurrentAppPage(0);
          await getUserProfile();
          Get.offAllNamed(AppRoutes.vendorHomePage);
        } else {
          print("✅ Switched to Customer Mode");
          CustomSnackBar.success(message: "Switched to Customer Profile");
          appController.changeCurrentAppPage(0);
          await getUserProfile();
          Get.offAllNamed(AppRoutes.homeScreen);
        }
      } else if (response.statusCode == 400) {
        // --- INCOMPLETE VENDOR PROFILE CASE ---
        print("⚠️ Cannot switch: Vendor profile incomplete.");

        // Close loader before navigating
        Get.find<GlobalLoaderController>().hideLoader();

        CustomSnackBar.processing(
          message: "Setup Required: Please complete your vendor registration.",
        );

        appController.changeCurrentAppPage(0);
        // Redirect to Vendor Onboarding Flow (Existing User Mode)
        Get.toNamed(
          AppRoutes.becomeVendorScreen,
          arguments: {'isExistingUser': true},
        );
      } else {
        // --- OTHER ERRORS ---
        CustomSnackBar.failure(
          message: response.statusText ?? "Failed to switch role",
        );
      }
    } catch (e) {
      print("❌ Switch Role Error: $e");
      CustomSnackBar.failure(message: "An error occurred");
    } finally {
      // Hide loader if we haven't navigated away in the 400 case
      Get.find<GlobalLoaderController>().hideLoader();
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
        String errorMsg =
            body['message'] ?? body['error'] ?? "Failed to upload avatar";
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

  Future<void> updateProfile(
    String name,
    String email,
    String state,
    String lga,
  ) async {
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
          arguments: {"number": number},
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

      // Navigate first
      if (userModel?.currentRole == 'customer') {
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        Get.offAllNamed(AppRoutes.vendorHomePage);
      }

      // ✅ Call once (not twice)
      // Future.delayed(const Duration(seconds: 2), () {
      //   NotificationService().initializeAndSyncToken(
      //     upsertDeviceToken: ({required token, required platform}) async {
      //       await appController.saveDeviceToken(token);
      //     },
      //   );
      // });

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
