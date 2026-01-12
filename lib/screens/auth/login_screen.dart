import 'package:country_code_picker/country_code_picker.dart'; // <--- Import this
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/snackbars.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String _dialCode = "+234"; // <--- Default Country Code

  @override
  void dispose() {
    numberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    String phoneInput = numberController.text.trim();
    String password = passwordController.text.trim();

    if (phoneInput.isEmpty) {
      CustomSnackBar.failure( message: "Enter phone number");
      return;
    }
    if (password.isEmpty) {
      CustomSnackBar.failure(message: "Enter password");
      return;
    }

    // Combine Code + Number (e.g., +2348012345678)
    // Note: You might need to remove the leading '0' from the phone number if the user typed "080..."
    if (phoneInput.startsWith('0')) {
      phoneInput = phoneInput.substring(1);
    }
    String fullPhoneNumber = "$_dialCode$phoneInput";

    print("📞 Logging in with: $fullPhoneNumber");

    authController.login(fullPhoneNumber, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height40,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height40 * 2),
              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: Dimensions.font26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'You can login back into your account using your phone number',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height40),

              // --- Phone Number Field with Country Picker ---
              CustomTextField(
                controller: numberController,
                hintText: "8012345678",
                keyboardType: TextInputType.number,
                maxLines: 1,
                // 1. Use a defined Container width to hold the picker
                prefixIcon: Container(
                  width: Dimensions.width10*11,
                  padding: EdgeInsets.only(left: Dimensions.width5),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded( // Allows picker to take available space
                        child: CountryCodePicker(
                          onChanged: (country) {
                            setState(() {
                              _dialCode = country.dialCode!;
                            });
                          },
                          initialSelection: 'NG',
                          favorite: const ['+234', 'NG', 'US', 'GB'],

                          // --- KEY PROPERTIES TO FIX OVERFLOW ---
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false, // Shows "+234"
                          hideMainText: false,              // Ensures text is visible
                          showFlagMain: true,               // Shows Flag
                          alignLeft: false,
                          padding: EdgeInsets.zero,

                          // --- STYLING ---
                          flagWidth: 20, // Smaller flag
                          textStyle: TextStyle(
                            fontSize: Dimensions.font14, // Smaller font
                            color: AppColors.grey4,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis, // Prevents crash if too long
                          ),

                          // Customizing the popup search dialog
                          dialogTextStyle: TextStyle(color: Colors.black),
                          searchDecoration: InputDecoration(
                            hintText: "Search country",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      // Divider
                      Container(
                        width: 1,
                        height: 20,
                        color: AppColors.grey3,
                        margin: EdgeInsets.only(right: 5),
                      ),
                    ],
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.cancel_outlined, color: AppColors.grey4),
                  onPressed: () => numberController.clear(),
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // --- Password Field ---
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                maxLines: 1,
                obscureText: !_isPasswordVisible,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(Dimensions.width15),
                  child: Image.asset(
                    AppConstants.getPngAsset('lock-icon'),
                    height: Dimensions.height20,
                    width: Dimensions.width20,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.grey4,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),

              SizedBox(height: Dimensions.height15),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.toNamed(AppRoutes.forgottenPassScreen),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: AppColors.color2,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.font14
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height30),
              CustomButton(
                text: 'Login',
                onPressed: _login,
              ),
              SizedBox(height: Dimensions.height20),
              Center(
                child: InkWell(
                  onTap: () => Get.offAllNamed(AppRoutes.getStartedScreen),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Back to Onboarding',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.color2,
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}