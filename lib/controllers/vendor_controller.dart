import 'dart:io';

import 'package:fyndr_ng/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/api/api_client.dart';
import '../data/repo/auth_repo.dart';
import '../routes/routes.dart';
import '../utils/app_constants.dart';
import 'auth_controller.dart';

class VendorController extends GetxController {
  bool isExistingUser = false;


  final businessNameController = TextEditingController();
  final businessRegController = TextEditingController();
  final businessTypeController = TextEditingController();
  final yearEstablishedController = TextEditingController();

  final ownerNameController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final ownerEmailController = TextEditingController();
  final ownerPasswordController = TextEditingController();

  final streetController = TextEditingController();
  final cityStateController = TextEditingController();
  final lgaController = TextEditingController();
  Map<String, dynamic>? rawLocationData;


  // --- FILE STORAGE ---
  File? businessDoc;
  File? ownerIdDoc;
  File? locationDoc;

  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  // Services
  List<String> selectedServices = [];

  final Map<String, String> availableServices = {
    'real-estate': 'Real Estate',
    'plumbing': 'Plumbing',
    'home-maintenance': 'Home Maintenance',
  };

  @override
  void onInit() {
    super.onInit();
    // LOGGING INIT STATE
    print("🎬 VendorController Initialized");

    // Check arguments
    if (Get.arguments != null) {
      print("📦 Arguments received: ${Get.arguments}");
      if (Get.arguments['isExistingUser'] == true) {
        isExistingUser = true;
      }
    }

    // Check AuthController directly as a backup/verification
    try {
      bool authSaysLogged = Get.find<AuthController>().isLoggedIn();
      print("🔐 AuthController says isLoggedIn: $authSaysLogged");
    } catch (e) {
      print("⚠️ Could not check AuthController: $e");
    }

    print("👤 Final isExistingUser status: $isExistingUser");
  }

  // --- DEBUGGED PICK DOCUMENT ---
  Future<void> pickDocument(String type) async {
    print("📸 pickDocument called for: $type");

    try {
      print("⏳ Opening Image Picker...");

      final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50 // Compressing to avoid memory crash
      );

      if (image != null) {
        print("✅ Image selected: ${image.path}");

        File file = File(image.path);

        // Print file size for debugging
        int sizeInBytes = await file.length();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        print("📁 File size: ${sizeInMb.toStringAsFixed(2)} MB");

        if (type == 'business') businessDoc = file;
        else if (type == 'owner') ownerIdDoc = file;
        else if (type == 'location') locationDoc = file;

        update(); // Refresh UI
        print("🔄 UI Updated with new file");
      } else {
        print("❌ User cancelled image picker (returned null)");
      }
    } catch (e) {
      print("🔥 CRASH in pickDocument: $e");
      CustomSnackBar.failure(message: "Could not open gallery. Check permissions.");
    }
  }

  Future<void> submitVendorRegistration() async {
    print("🚀 Submit Vendor Registration Triggered");

    // 1. Validate Files
    if (businessDoc == null || ownerIdDoc == null || locationDoc == null) {
      print("⚠️ Validation Failed: Missing documents");
      CustomSnackBar.failure(message: "Missing Documents: Please upload all required documents.");
      return;
    }

    _isSubmitting = true;
    update();

    // 2. Prepare Text Body
    print("📝 Preparing Text Body...");

    Map<String, String> body = {
      'businessName': businessNameController.text,
      'businessRegNumber': businessRegController.text,
      'businessType': businessTypeController.text,
      'businessYearEstablished': yearEstablishedController.text,
      'businessLocation': '{"street":"${streetController.text}","state":"${cityStateController.text}","lga":"${lgaController.text}"}',
      'servicesOffered': selectedServices.toString(),
    };

    // Add Owner info only if NEW User
    if (!isExistingUser) {
      print("➕ Adding Owner Info (New User Mode)");
      body.addAll({
        'name': ownerNameController.text,
        'number': ownerPhoneController.text,
        'email': ownerEmailController.text,
        'password': ownerPasswordController.text,
      });
    } else {
      print("ℹ️ Skipping Owner Info (Existing User Mode)");
    }

    // Print the final body to check for nulls
    print("📦 FINAL BODY: $body");

    try {
      String endpoint = isExistingUser
          ? AppConstants.REGISTER_EXISTING_BUSINESS
          : AppConstants.REGISTER_NEW_BUSINESS;

      print("🔗 Calling Endpoint: $endpoint");
      print("📂 Uploading ${3} files...");

      await Get.find<AuthRepo>().registerVendor(
          endpoint,
          body,
          [
            MultipartBody('businessDocument', businessDoc!),
            MultipartBody('ownerIdentification', ownerIdDoc!),
            MultipartBody('locationDocument', locationDoc!),
          ]
      );

      print("✅ API Call Successful");
      Get.offAllNamed(AppRoutes.vendorVerificationInProgressScreen);

    } catch (e) {
      print("🔥 CRASH during API Call: $e");
      CustomSnackBar.failure(message: "Error : Registration failed. Try again.");
    } finally {
      _isSubmitting = false;
      update();
    }
  }

  void toggleService(String serviceKey) {
    if (selectedServices.contains(serviceKey)) {
      selectedServices.remove(serviceKey);
    } else {
      selectedServices.add(serviceKey);
    }
    update(); // Refresh UI to show green borders
  }

  bool validateForm() {
    // 1. Validate Business Info
    if (businessNameController.text.isEmpty ||
        businessTypeController.text.isEmpty ||
        yearEstablishedController.text.isEmpty) {
      CustomSnackBar.failure(message: "Error: Please fill all business details");
      return false;
    }

    // 2. Validate Services
    if (selectedServices.isEmpty) {
      CustomSnackBar.failure(message: "Error: Please select at least one service");
      return false;
    }

    // 3. Validate Owner Info (ONLY if New User)
    if (!isExistingUser) {
      if (ownerNameController.text.isEmpty ||
          ownerPhoneController.text.isEmpty ||
          ownerEmailController.text.isEmpty ||
          ownerPasswordController.text.isEmpty) {
        CustomSnackBar.failure(message: "Error: Please fill all owner details");
        return false;
      }
    }

    return true;
  }

  void proceedToVerification() {
    if (!validateForm()) return;

    Get.toNamed(AppRoutes.vendorGetVerifiedScreen);
  }
}