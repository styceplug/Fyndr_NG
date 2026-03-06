import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../routes/routes.dart';


class ApiChecker {
  static void checkApi(
      Response response, {
        bool promptLoginOnUnauthorized = true,
        String? loginTitle,
        String? loginMessage,
      }) {
    final url = response.request?.url;
    print('🧩 ApiChecker → ${response.statusCode} [$url]');

    final appCtrl = Get.find<AppController>();
    final bool hasToken = appCtrl.isLoggedIn;

    String _tryExtractMessage() {
      final body = response.body;
      if (body is Map) {
        if (body['message'] != null) return body['message'].toString();
        if (body['error'] != null) return body['error'].toString();
      }
      return response.statusText ?? "Request failed";
    }

    switch (response.statusCode) {
      case 401:

        if (hasToken) {
          print('🚫 401 with token → session expired, clearing auth');
          appCtrl.clearSharedData();
          Get.offAllNamed(AppRoutes.getStartedScreen);
          return;
        }

        print('🚫 401 without token → guest, do not redirect');
        if (promptLoginOnUnauthorized) {
          AuthPrompt.show(
            title: loginTitle ?? "Sign in to continue",
            message: loginMessage ?? "This feature requires an account. Please sign in to proceed.",
          );
        }
        return;

      case 400:
      // Validation errors (show body message if you want)
        print('⚠️ 400 Bad request: ${_tryExtractMessage()}');
        return;

      case 403:
        print('🔒 403 Forbidden: ${_tryExtractMessage()}');
        return;

      case 404:
        print('❓ 404 Not found: ${_tryExtractMessage()}');
        return;

      case 408:
      case 504:
        print('⏱ Timeout: ${_tryExtractMessage()}');
        return;

      case 500:
        print('💥 Server error: ${_tryExtractMessage()}');
        return;

      case 0:
      case 1:
        print('📡 No internet / Connection refused');
        Get.offAllNamed(AppRoutes.noInternetScreen);
        return;

      default:
      // Your old "code == 99" style
        if (response.body is Map && response.body['code'] == '99') {
          print('❌ App-level error: ${response.body['message']}');
          return;
        }

        if (response.hasError) {
          print('⚠️ Unknown Error: ${_tryExtractMessage()}');
          return;
        }

        print('✅ Passed ApiChecker.');
        return;
    }
  }
}

class AuthPrompt {
  static bool _showing = false;

  static Future<void> show({
    String title = "Sign in required",
    String message = "Please sign in to continue.",
  }) async {
    if (_showing) return;
    _showing = true;

    await Get.dialog(
      WillPopScope(
        onWillPop: () async => true,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // optional icon circle
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_outline, size: 22),
                ),
                const SizedBox(height: 12),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // close dialog
                      Get.toNamed(AppRoutes.getStartedScreen); // or login route
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text("Sign in"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );

    _showing = false;
  }
}