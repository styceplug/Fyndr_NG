import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/screens/in_app/web_view_screen.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // --- DEPENDENCIES ---
  final AuthController authController = Get.find<AuthController>();

  // --- CONTROLLERS ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // --- REGEX CACHE (Performance Optimization) ---
  static final RegExp _digitsRegex = RegExp(r'[^0-9]');
  static final RegExp _upperCaseRegex = RegExp(r'[A-Z]');
  static final RegExp _numberRegex = RegExp(r'[0-9]');
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  // --- STATE VARIABLES ---
  String? phoneErrorText;
  String? passErrorText;
  String passwordStrengthText = "";

  bool isFormFilled = false;
  bool isPassHidden = true;
  bool isAgreed = false;
  String _dialCode = "+234";
  String _countryCode = "NG";

  // Password Checklist State
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasNumber = false;

  @override
  void initState() {
    super.initState();
    // Attach listeners once. No need for onChanged in UI.
    nameController.addListener(_onInputChanged);
    phoneController.addListener(_onInputChanged);
    passController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }

  // ---------------- LOGIC & VALIDATION ----------------

  void _onInputChanged() {
    // 1. Clear specific errors when user types (UX improvement)
    if (phoneErrorText != null && phoneController.text.isNotEmpty) {
      setState(() => phoneErrorText = null);
    }
    if (passErrorText != null && passController.text.isNotEmpty) {
      setState(() => passErrorText = null);
    }

    // 2. Update Password Analysis
    final pass = passController.text;
    setState(() {
      hasMinLength = pass.length >= 8;
      hasUppercase = pass.contains(_upperCaseRegex);
      hasNumber = pass.contains(_numberRegex);
    });

    _calculatePasswordStrength(pass);

    // 3. Check Overall Form Validity
    final isValid =
        nameController.text.trim().isNotEmpty &&
        _validatePhoneLogic(phoneController.text) == null &&
        _validatePasswordLogic(pass) == null &&
        isAgreed;

    if (isFormFilled != isValid) {
      setState(() => isFormFilled = isValid);
    }
  }

  String? _validatePhoneLogic(String value) {
    final clean = value.replaceAll(_digitsRegex, '');
    if (clean.isEmpty) return "Phone number is required";

    switch (_countryCode) {
      case "NG":
        if (clean.length != 10 && clean.length != 11)
          return "Enter valid 10-11 digit number";
        break;
      case "US":
        if (clean.length != 10) return "Enter valid 10 digit US number";
        break;
      case "GB":
        if (clean.length < 9 || clean.length > 11)
          return "Enter valid UK number";
        break;
      default:
        if (clean.length < 6) return "Enter valid phone number";
    }
    return null;
  }

  String? _validatePasswordLogic(String value) {
    if (value.isEmpty) return "Password is required";
    if (!hasMinLength) return "Minimum of 8 characters required";
    if (!hasUppercase) return "Must contain at least one capital letter";
    if (!hasNumber) return "Must contain at least one number";
    return null;
  }

  void _calculatePasswordStrength(String value) {
    // Only calculate strength if basic requirements are met
    if (_validatePasswordLogic(value) != null) {
      if (passwordStrengthText.isNotEmpty)
        setState(() => passwordStrengthText = "");
      return;
    }

    int score = 0;
    if (value.length >= 12) score++;
    if (value.contains(_specialCharRegex)) score++;

    final newStrength = (score == 0) ? "Moderate password" : "Strong password";
    if (passwordStrengthText != newStrength) {
      setState(() => passwordStrengthText = newStrength);
    }
  }

  void createAccount() {
    // Final Validation on Submit
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passController.text.trim();

    final phoneError = _validatePhoneLogic(phone);
    final passError = _validatePasswordLogic(password);

    if (phoneError != null || passError != null) {
      setState(() {
        phoneErrorText = phoneError;
        passErrorText = passError;
      });
      return;
    }

    // Format Phone (Remove leading zero)
    String cleanPhone = phone.replaceAll(_digitsRegex, '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    final formattedPhone = '$_dialCode$cleanPhone';

    authController.registerCustomer(name, formattedPhone, password);
  }

  // ---------------- UI BUILD ----------------

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
                'Create an account',
                style: TextStyle(
                  fontSize: Dimensions.font28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'You can login back into your account using your phone number',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height40),

              // --- FULL NAME ---
              CustomTextField(
                controller: nameController,
                hintText: 'Full name',
                keyboardType: TextInputType.name,
                prefixIcon: _buildIconPrefix('person-icon'),
              ),
              SizedBox(height: Dimensions.height20),

              // --- PHONE INPUT ---
              CustomTextField(
                controller: phoneController,
                hintText: 'Phone number',
                keyboardType: TextInputType.number,
                // Prefix: Country Picker
                prefixIcon: Container(
                  width: Dimensions.width10 * 12, // Adjusted width
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: CountryCodePicker(
                          initialSelection: 'NG',
                          favorite: const ['+234', 'NG', 'US', 'GB'],
                          onChanged: (country) {
                            setState(() {
                              _dialCode = country.dialCode!;
                              _countryCode = country.code!;
                            });
                            // Re-validate immediately upon changing country
                            _onInputChanged();
                          },
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          padding: EdgeInsets.zero,
                          flagWidth: 20,
                          textStyle: TextStyle(
                            fontSize: Dimensions.font14,
                            color: AppColors.grey4,
                            fontWeight: FontWeight.bold,
                          ),
                          dialogTextStyle: TextStyle(color: Colors.black),
                          searchDecoration: InputDecoration(
                            hintText: "Search",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
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
                  onPressed: () {
                    phoneController.clear();
                    // Listener will handle clearing error state
                  },
                ),
              ),
              if (phoneErrorText != null) _buildErrorText(phoneErrorText!),

              SizedBox(height: Dimensions.height20),

              // --- PASSWORD INPUT ---
              CustomTextField(
                maxLines: 1,
                controller: passController,
                obscureText: isPassHidden,
                hintText: 'Password',
                prefixIcon: _buildIconPrefix('lock-icon'),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPassHidden ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey4,
                  ),
                  onPressed: () => setState(() => isPassHidden = !isPassHidden),
                ),
              ),

              // --- PASSWORD FEEDBACK SECTION ---
              if (passController.text.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(top: 10, left: Dimensions.width15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PasswordCheckItem(
                        label: "At least 8 characters",
                        isValid: hasMinLength,
                      ),
                      _PasswordCheckItem(
                        label: "One capital letter (A-Z)",
                        isValid: hasUppercase,
                      ),
                      _PasswordCheckItem(
                        label: "One number (0-9)",
                        isValid: hasNumber,
                      ),
                    ],
                  ),
                ),

                if (passErrorText != null) _buildErrorText(passErrorText!),

                if (passwordStrengthText.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 6, left: Dimensions.width15),
                    child: Text(
                      passwordStrengthText,
                      style: TextStyle(
                        fontSize: Dimensions.font12,
                        fontWeight: FontWeight.w600,
                        color:
                            passwordStrengthText.contains("Strong")
                                ? Colors.green
                                : Colors.orange,
                      ),
                    ),
                  ),
              ],

              SizedBox(height: Dimensions.height20),

              // --- AGREEMENT CHECKBOX ---
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: isAgreed,
                      activeColor: AppColors.color2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (bool? value) {
                        setState(() {
                          isAgreed = value ?? false;
                        });
                        _onInputChanged(); // Trigger validation check
                      },
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.grey3,
                          fontSize: Dimensions.font14,
                        ),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: InkWell(
                              onTap:
                                  () => Get.to(
                                    () => InAppWebViewScreen(
                                      url:
                                          'https://fyndr.ng/fyndr-terms-and-conditions/',
                                      title: 'Terms and Conditions',
                                    ),
                                  ),
                              child: Text(
                                'Terms of Service',
                                style: TextStyle(
                                  color: AppColors.color2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: InkWell(
                              onTap:
                                  () => Get.to(
                                    () => InAppWebViewScreen(
                                      url: 'https://fyndr.ng/privacy-policy/',
                                      title: 'Privacy Policy',
                                    ),
                                  ),
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.color2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height20),

              // --- SUBMIT BUTTON ---
              CustomButton(
                text: 'Create account',
                onPressed: createAccount,
                isDisabled: !isFormFilled,
              ),

              SizedBox(height: Dimensions.height15),

              // --- LOGIN LINK ---
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.loginScreen),
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
              SizedBox(height: Dimensions.height10 * 9),

              CustomButton(
                text: 'Proceed as Guest',
                isDisabled: isFormFilled,
                onPressed: () {
                  Get.offAllNamed(AppRoutes.homeScreen);
                },
              ),
              if (isFormFilled) ...[
                SizedBox(height: Dimensions.height5),
                Align(
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    'Clear form to proceed as Guest',
                    style: TextStyle(
                      fontSize: Dimensions.font12,
                      fontWeight: FontWeight.w300,
                      color: Colors.red
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildIconPrefix(String assetName) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height10,
      ),
      child: Image.asset(
        AppConstants.getPngAsset(assetName),
        height: Dimensions.height20,
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: EdgeInsets.only(top: 6, left: Dimensions.width15),
      child: Text(
        error,
        style: TextStyle(color: Colors.red, fontSize: Dimensions.font12),
      ),
    );
  }
}

// Extracted Widget for better performance and readability
class _PasswordCheckItem extends StatelessWidget {
  final String label;
  final bool isValid;

  const _PasswordCheckItem({
    Key? key,
    required this.label,
    required this.isValid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font12,
              color: isValid ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
