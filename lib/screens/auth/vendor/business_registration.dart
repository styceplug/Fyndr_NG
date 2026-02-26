import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';

import '../../../controllers/vendor_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/country_state_dropdown.dart';
import '../../in_app/web_view_screen.dart';

class BusinessRegistration extends StatefulWidget {
  const BusinessRegistration({super.key});

  @override
  State<BusinessRegistration> createState() => _BusinessRegistrationState();
}

class _BusinessRegistrationState extends State<BusinessRegistration> {
  final VendorController controller = Get.put(VendorController());
  String? selectedState;
  String? selectedLga;
  String _dialCode = "+234";
  bool isPassHidden = true;
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasNumber = false;
  String? passErrorText;
  String passwordStrengthText = "";
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  late TextEditingController locationDisplayController;

  void _onPasswordChanged() {
    final value = controller.ownerPasswordController.text;

    setState(() {
      hasMinLength = value.length >= 8;
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasNumber = value.contains(RegExp(r'[0-9]'));

      if (passErrorText != null) passErrorText = null;
    });

    _calculatePasswordStrength(value);
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

  @override
  void initState() {
    super.initState();
    locationDisplayController = TextEditingController();
    controller.ownerPasswordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    controller.ownerPasswordController.removeListener(_onPasswordChanged);
    locationDisplayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: 'Business Registration',
      ),
      body: GetBuilder<VendorController>(
        builder: (ctrl) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            height: Dimensions.screenHeight,
            width: Dimensions.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    AppConstants.getPngAsset('approved'),
                    height: Dimensions.height12 * 10,
                  ),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    'Register your business',
                    style: TextStyle(
                      fontSize: Dimensions.font22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.color1,
                    ),
                  ),
                  Text(
                    'Join verified service providers on Fynder',
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey5,
                    ),
                  ),

                  // --- BUSINESS INFORMATION ---
                  SizedBox(height: Dimensions.height20),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      'Business Information',
                      style: TextStyle(
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  CustomTextField(
                    controller: ctrl.businessNameController,
                    hintText: 'Business name',
                    fillColor: AppColors.grey3.withOpacity(0.3),
                  ),
                  SizedBox(height: Dimensions.height20),
                  CustomTextField(
                    controller: ctrl.businessRegController,
                    hintText: 'Business Reg. Number (Optional)',
                    fillColor: AppColors.grey3.withOpacity(0.3),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: Dimensions.height20),
                  CustomTextField(
                    controller: ctrl.businessTypeController,
                    hintText: 'Business type (e.g. LLC)',
                    fillColor: AppColors.grey3.withOpacity(0.3),
                  ),
                  SizedBox(height: Dimensions.height20),
                  CustomTextField(
                    controller: ctrl.yearEstablishedController,
                    hintText: 'Year Established',
                    keyboardType: TextInputType.number,
                    fillColor: AppColors.grey3.withOpacity(0.3),
                  ),

                  // --- OWNER INFORMATION (CONDITIONAL) ---
                  // Only show this block if the user is NEW (not existing)
                  if (!ctrl.isExistingUser) ...[
                    SizedBox(height: Dimensions.height20),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        'Owner Information',
                        style: TextStyle(
                          fontSize: Dimensions.font18,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    CustomTextField(
                      controller: ctrl.ownerNameController,
                      hintText: 'Full name',
                      fillColor: AppColors.grey3.withOpacity(0.3),
                    ),
                    SizedBox(height: Dimensions.height20),
                    CustomTextField(
                      controller: ctrl.ownerPhoneController,
                      hintText: "8012345678",
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      // 1. Use a defined Container width to hold the picker
                      prefixIcon: Container(
                        width: Dimensions.width10 * 11,
                        padding: EdgeInsets.only(left: Dimensions.width5),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              // Allows picker to take available space
                              child: CountryCodePicker(
                                onChanged: (country) {
                                  setState(() {
                                    _dialCode = country.dialCode!;
                                    ctrl.setCountryCode(country.dialCode!);
                                  });
                                },
                                initialSelection: 'NG',
                                favorite: const ['+234', 'NG', 'US', 'GB'],

                                // --- KEY PROPERTIES TO FIX OVERFLOW ---
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                // Shows "+234"
                                hideMainText: false,
                                // Ensures text is visible
                                showFlagMain: true,
                                // Shows Flag
                                alignLeft: false,
                                padding: EdgeInsets.zero,

                                // --- STYLING ---
                                flagWidth: 20,
                                // Smaller flag
                                textStyle: TextStyle(
                                  fontSize: Dimensions.font14, // Smaller font
                                  color: AppColors.grey4,
                                  fontWeight: FontWeight.bold,
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Prevents crash if too long
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
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: AppColors.grey4,
                        ),
                        onPressed: () => ctrl.ownerPhoneController.clear(),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    CustomTextField(
                      controller: ctrl.ownerEmailController,
                      hintText: 'Email address',
                      fillColor: AppColors.grey3.withOpacity(0.3),
                    ),
                    SizedBox(height: Dimensions.height20),
                    CustomTextField(
                      maxLines: 1,
                      controller: ctrl.ownerPasswordController,
                      obscureText: isPassHidden,
                      hintText: 'Password',
                      prefixIcon: _buildIconPrefix('lock-icon'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPassHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.grey4,
                        ),
                        onPressed:
                            () => setState(() => isPassHidden = !isPassHidden),
                      ),
                    ),

                    // --- PASSWORD FEEDBACK SECTION ---
                    if (ctrl.ownerPasswordController.text.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: Dimensions.width15,
                        ),
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

                      if (passErrorText != null)
                        _buildErrorText(passErrorText!),
                    ],
                  ],

                  // --- SERVICES OFFERED ---
                  SizedBox(height: Dimensions.height20),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      'Service Offered (Select all that apply)',
                      style: TextStyle(
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  // Wrap in Wrap or ScrollView if needed, or keep Row if just 3
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Pass the Controller to the widget to check selection
                        _buildServiceCard(ctrl, 'real-estate', 'Real Estate'),
                        SizedBox(width: 10),
                        _buildServiceCard(ctrl, 'cleaning', 'Cleaning Service'),
                        SizedBox(width: 10),
                        _buildServiceCard(
                          ctrl,
                          'home-maintenance',
                          'Home Maintenance',
                        ),
                      ],
                    ),
                  ),

                  if (ctrl.selectedServices.contains('home-maintenance')) ...[
                    SizedBox(height: Dimensions.height20),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        'Select Maintenance Specialty',
                        style: TextStyle(
                          fontSize: Dimensions.font18,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey3.withOpacity(0.3),
                        // Matches your CustomTextField
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius10,
                        ), // Matches your dimensions
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: ctrl.selectedSubCategory,
                          hint: Text(
                            "Select specialty",
                            style: TextStyle(
                              color: AppColors.grey4,
                              fontSize: Dimensions.font14,
                            ),
                          ),
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.grey4,
                          ),
                          dropdownColor: Colors.white,
                          // Or your app background color
                          items:
                              ctrl.maintenanceSubCategories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: Dimensions.font14,
                                      color: AppColors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            ctrl.setSubCategory(newValue);
                          },
                        ),
                      ),
                    ),
                  ],

                  // --- BUSINESS LOCATION ---
                  SizedBox(height: Dimensions.height20),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      'Business Location',
                      style: TextStyle(
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  CustomTextField(
                    controller: ctrl.streetController,
                    hintText: 'Street address',
                    fillColor: AppColors.grey3.withOpacity(0.3),
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: _openLocationPicker,
                    child: AbsorbPointer(
                      // Prevents keyboard from opening
                      child: CustomTextField(
                        controller: locationDisplayController,
                        hintText: "Tap to select location",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width10,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.grey4,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.grey4,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height40),

                  CustomButton(
                    text: 'Continue to verification',
                    onPressed: () {
                      ctrl.proceedToVerification();
                    },
                  ),

                  SizedBox(height: Dimensions.height20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: AppColors.grey3),
                      children: [
                        const TextSpan(text: 'By Proceeding, you agree to our '),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () => Get.to(() => InAppWebViewScreen(
                              url: 'https://fyndr.ng/fyndr-terms-and-conditions/',
                              title: 'Terms and Conditions',
                            )),
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
                          child: InkWell(
                            onTap: () => Get.to(() => InAppWebViewScreen(
                              url: 'https://fyndr.ng/privacy-policy/',
                              title: 'Privacy Policy',
                            )),
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
                  SizedBox(height: Dimensions.height20),

                  // Show "Already have account" only if we are in New User mode
                  if (!ctrl.isExistingUser) ...[
                    SizedBox(height: Dimensions.height20),
                    InkWell(
                      onTap: () {
                        Get.offAllNamed(AppRoutes.loginScreen);
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
                  SizedBox(height: Dimensions.height100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => LocationPickerModal(
            enableState: selectedState,
            enableLga: selectedLga,
            onConfirm: (newState, newLga) {
              setState(() {
                selectedState = newState;
                selectedLga = newLga;
                locationDisplayController.text = "$newState, $newLga";
                controller.cityStateController.text = newState;
                controller.lgaController.text = newLga;
              });
            },
          ),
    );
  }

  Widget _buildServiceCard(
    VendorController ctrl,
    String serviceKey,
    String title,
  ) {
    // Check if this specific service key is in the selected list
    bool isSelected = ctrl.selectedServices.contains(serviceKey);

    return InkWell(
      onTap: () {
        ctrl.toggleService(serviceKey);
      },
      borderRadius: BorderRadius.circular(Dimensions.radius10),
      child: Container(
        height: Dimensions.height10 * 12,
        width: Dimensions.width10 * 12,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.color1.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          border: Border.all(
            // Green border if selected, Grey if not
            color: isSelected ? AppColors.color1 : AppColors.grey3,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: EdgeInsets.all(Dimensions.width10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppConstants.getPngAsset(serviceKey),
              height: 40,
              width: 40,
            ),
            SizedBox(height: 10),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.color1 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
