import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/country_state_dropdown.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/snackbars.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  late TextEditingController nameController;
  late TextEditingController emailController;

  // These store the selected location values
  String? selectedState;
  String? selectedLga;

  // Controller just for displaying the text "Lagos, Ikeja"
  late TextEditingController locationDisplayController;

  @override
  void initState() {
    super.initState();
    final user = authController.userModel;

    nameController = TextEditingController(text: user?.name ?? "");
    emailController = TextEditingController(text: user?.email ?? "");

    selectedState = user?.location?.state;
    selectedLga = user?.location?.lga;

    // Format initial display text
    String initialLoc = "";
    if (selectedState != null && selectedLga != null) {
      initialLoc = "$selectedState, $selectedLga";
    }
    locationDisplayController = TextEditingController(text: initialLoc);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    locationDisplayController.dispose();
    super.dispose();
  }

  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPickerModal(
        enableState: selectedState,
        enableLga: selectedLga,
        onConfirm: (newState, newLga) {
          setState(() {
            selectedState = newState;
            selectedLga = newLga;
            locationDisplayController.text = "$newState, $newLga";
          });
        },
      ),
    );
  }

  void _updateProfile() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty || selectedState == null || selectedLga == null) {
      CustomSnackBar.failure(message: "All fields are required");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      CustomSnackBar.failure(message: "Please enter a valid email");
      return;
    }

    authController.updateProfile(name, email, selectedState!, selectedLga!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.color1),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: AppColors.color1,
            fontSize: Dimensions.font20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          children: [
            // --- Name ---
            CustomTextField(
              controller: nameController,
              hintText: "Full Name",
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10),
                child: Icon(Icons.person_outline, color: AppColors.grey4),
              ),
            ),
            SizedBox(height: Dimensions.height20),

            // --- Email ---
            CustomTextField(
              controller: emailController,
              hintText: "Email Address",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10),
                child: Icon(Icons.email_outlined, color: AppColors.grey4),
              ),
            ),
            SizedBox(height: Dimensions.height20),

            // --- Location (Triggers Modal) ---
            GestureDetector(
              onTap: _openLocationPicker,
              child: AbsorbPointer( // Prevents keyboard from opening
                child: CustomTextField(
                  controller: locationDisplayController,
                  hintText: "Tap to select location",
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10),
                    child: Icon(Icons.location_on_outlined, color: AppColors.grey4),
                  ),
                  suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.grey4),
                ),
              ),
            ),

            SizedBox(height: Dimensions.height40),

            // --- Save Button ---
            GetBuilder<AuthController>(builder: (controller) {
              return CustomButton(
                text: "Save Changes",
                onPressed: _updateProfile,
              );
            }),
          ],
        ),
      ),
    );
  }
}