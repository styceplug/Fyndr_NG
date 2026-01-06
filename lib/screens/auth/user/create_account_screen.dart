import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/snackbars.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  AuthController authController = Get.find<AuthController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String? phoneErrorText;
  String? passErrorText;

  bool isFormFilled = false;
  bool passVisible = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(validateInputs);
    phoneController.addListener(validateInputs);
    passController.addListener(validateInputs);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";

    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasMinLength = value.length >= 8;

    if (!hasMinLength) return "Password must be at least 8 characters";
    if (!hasUppercase) return "Password must contain at least one Capital letter";
    if (!hasDigits) return "Password must contain at least one number";

    return null;
  }

  String? validatePhone(String value) {
    String cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanPhone.isEmpty) return "Phone number is required";

    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return "Enter a valid 10 or 11 digit number";
    }
    return null;
  }

  void validateInputs() {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String pass = passController.text.trim();

    bool isValid =
        name.isNotEmpty &&
            validatePhone(phone) == null &&
            validatePassword(pass) == null;

    if (isValid != isFormFilled) {
      setState(() {
        isFormFilled = isValid;
      });
    }
  }

  void createAccount() {
    setState(() {
      phoneErrorText = null;
      passErrorText = null;
    });

    String name = nameController.text.trim();
    String userEnteredPhone = phoneController.text.trim();
    String password = passController.text.trim();


    String? phoneResult = validatePhone(userEnteredPhone);
    if (phoneResult != null) {
      setState(() {
        phoneErrorText = phoneResult;
      });

    }


    String? passResult = validatePassword(password);
    if (passResult != null) {
      setState(() {
        passErrorText = passResult;
      });
    }


    if (phoneErrorText != null || passErrorText != null) {
      return;
    }


    if (userEnteredPhone.startsWith('0')) {
      userEnteredPhone = userEnteredPhone.substring(1);
    }
    String formattedPhone = "+234$userEnteredPhone";


    authController.registerCustomer(name, formattedPhone, password);
  }

  void togglePass() {
    setState(() {
      passVisible = !passVisible;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height134,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create an account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Dimensions.font10 * 3.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color1,
                ),
              ),
              Text(
                'You can login back into your account using your phone number',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Dimensions.font18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height40),
              CustomTextField(
                prefixIcon: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  child: Image.asset(
                    AppConstants.getPngAsset('person-icon'),
                    height: Dimensions.height10 * 2.5,
                    width: Dimensions.width10 * 2.5,
                  ),
                ),
                maxLines: 1,
                keyboardType: TextInputType.name,
                hintText: 'Full name',
                controller: nameController,
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                prefixIcon: Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: Dimensions.width15),
                      Image.asset(
                        AppConstants.getPngAsset('9ja-flag'),
                        height: Dimensions.height10 * 2.5,
                        width: Dimensions.width10 * 2.5,
                      ),
                      SizedBox(width: Dimensions.width15),
                      Text(
                        '+234',
                        style: TextStyle(
                          color: AppColors.grey4,
                          fontSize: Dimensions.font18,
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Image.asset(
                        AppConstants.getPngAsset('drop-icon'),
                        width: Dimensions.width15,
                      ),
                      SizedBox(width: Dimensions.width15),
                    ],
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    phoneController.clear();
                    setState(() {
                      phoneErrorText = null;
                    });
                  },
                  child: Icon(Icons.cancel_outlined, color: AppColors.grey4),
                ),
                maxLines: 1,
                keyboardType: TextInputType.number,
                hintText: 'Phone number',
                controller: phoneController,
                onChanged: (_) {
                  if (phoneErrorText != null) setState(() => phoneErrorText = null);
                  setState(() {
                    phoneErrorText = validatePhone(phoneController.text.trim());
                  });
                },
              ),
              if (phoneErrorText != null)
                Padding(
                  padding: EdgeInsets.only(top: 6, left: Dimensions.width15),
                  child: Text(
                    phoneErrorText!,
                    style: TextStyle(color: Colors.red, fontSize: Dimensions.font12),
                  ),
                ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                obscureText: passVisible,
                prefixIcon: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  child: Image.asset(
                    AppConstants.getPngAsset('lock-icon'),
                    height: Dimensions.height10 * 2.5,
                    width: Dimensions.width10 * 2.5,
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: togglePass,
                  child: passVisible? Icon(Icons.visibility, color: AppColors.grey4) : Icon(Icons.visibility_off, color: AppColors.grey4),
                ),
                maxLines: 1,
                hintText: 'Password',
                controller: passController,
                onChanged: (_) {
                  if (passErrorText != null) setState(() => passErrorText = null);
                  setState(() {
                    passErrorText = validatePassword(passController.text.trim());
                  });
                },
              ),
              if (passErrorText != null)
                Padding(
                  padding: EdgeInsets.only(top: 6, left: Dimensions.width15),
                  child: Text(
                    passErrorText!,
                    style: TextStyle(color: Colors.red, fontSize: Dimensions.font12),
                  ),
                ),
              SizedBox(height: Dimensions.height20),
              CustomButton(
                text: 'Create account',
                onPressed: createAccount,
                isDisabled: !isFormFilled,
              ),
              SizedBox(height: Dimensions.height15),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.loginScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    Text(
                      ' Log in',
                      style: TextStyle(
                        color: AppColors.color2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
