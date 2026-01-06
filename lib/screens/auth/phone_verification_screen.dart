import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/routes.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/snackbars.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final AuthController authController = Get.find<AuthController>();

  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  bool isOtpComplete = false;

  Timer? _timer;
  int _secondsRemaining = 60;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    otp1Controller.addListener(_validateOtp);
    otp2Controller.addListener(_validateOtp);
    otp3Controller.addListener(_validateOtp);
    otp4Controller.addListener(_validateOtp);

    _checkClipboardForOtp();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    super.dispose();
  }

  // ───────────────────────── TIMER ─────────────────────────

  void _startTimer() {
    canResend = false;
    _secondsRemaining = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  // ───────────────────────── OTP VALIDATION ─────────────────────────

  void _validateOtp() {
    bool valid =
        otp1Controller.text.length == 1 &&
            otp2Controller.text.length == 1 &&
            otp3Controller.text.length == 1 &&
            otp4Controller.text.length == 1;

    if (valid != isOtpComplete) {
      setState(() => isOtpComplete = valid);
    }
  }

  // ───────────────────────── AUTO PASTE OTP ─────────────────────────

  Future<void> _checkClipboardForOtp() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';

    if (RegExp(r'^\d{4}$').hasMatch(text)) {
      otp1Controller.text = text[0];
      otp2Controller.text = text[1];
      otp3Controller.text = text[2];
      otp4Controller.text = text[3];

      FocusScope.of(context).unfocus();
    }
  }

  // ───────────────────────── VERIFY OTP ─────────────────────────

  void verifyOtp() {
    if (!isOtpComplete) {
      CustomSnackBar.failure(message: 'Enter the 4-digit OTP');
      return;
    }

    final otp =
        '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}';

    authController.verifyOtp(Get.arguments['number'], otp);
  }

  // ───────────────────────── RESEND OTP ─────────────────────────

  void resendOtp() {
    if (!canResend) return;

    authController.resendOtp(Get.arguments['number']);
    _startTimer();

    CustomSnackBar.success(message: 'OTP sent again');
  }

  // ───────────────────────── OTP FIELD ─────────────────────────

  Widget _otpField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    FocusNode? previousFocus,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      decoration: const InputDecoration(counterText: ''),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      onChanged: (value) {
        if (value.isNotEmpty && nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else if (value.isEmpty && previousFocus != null) {
          FocusScope.of(context).requestFocus(previousFocus);
        }
      },
    );
  }

  // ───────────────────────── UI ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final number = Get.arguments['number'];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height100),

            Text(
              'Let’s verify your phone number',
              style: TextStyle(
                fontSize: Dimensions.font10 * 3.2,
                fontWeight: FontWeight.w700,
                color: AppColors.color1,
              ),
            ),

            SizedBox(height: Dimensions.height10),

            Text(
              'Enter the 4-digit code sent to $number',
              style: TextStyle(
                fontSize: Dimensions.font18,
                color: AppColors.color1,
              ),
            ),

            SizedBox(height: Dimensions.height40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _otpField(controller: otp1Controller, focusNode: focus1, nextFocus: focus2)),
                SizedBox(width: Dimensions.width20),
                Expanded(child: _otpField(controller: otp2Controller, focusNode: focus2, nextFocus: focus3, previousFocus: focus1)),
                SizedBox(width: Dimensions.width20),
                Expanded(child: _otpField(controller: otp3Controller, focusNode: focus3, nextFocus: focus4, previousFocus: focus2)),
                SizedBox(width: Dimensions.width20),
                Expanded(child: _otpField(controller: otp4Controller, focusNode: focus4, previousFocus: focus3)),
              ],
            ),

            SizedBox(height: Dimensions.height40),

            CustomButton(
              text: 'Verify',
              onPressed: verifyOtp,
              isDisabled: !isOtpComplete,
            ),

            SizedBox(height: Dimensions.height20),

            canResend
                ? GestureDetector(
              onTap: resendOtp,
              child: Text(
                'Resend code',
                style: TextStyle(
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : Text(
              'Resend in $_secondsRemaining s',
              style: TextStyle(color: AppColors.grey4),
            ),
          ],
        ),
      ),
    );
  }
}