import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import '../../widgets/bouncing_dots_indicator.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    AppController appController = Get.find<AppController>();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      appController.initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: Dimensions.width20*4),
        child: Center(child: Image.asset(AppConstants.getPngAsset('logo'))),
      ),
    );
  }
}
