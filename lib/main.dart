import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:get/get.dart';
import 'helpers/dependencies.dart' as dep;
import 'helpers/global_loader_controller.dart';
import 'helpers/push_notification.dart';
import 'helpers/version_service.dart';
import 'widgets/app_loading_overlay.dart';

@pragma('vm:entry-point')




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await VersionService.init();
  await dep.init();


  // Always register loader controller
  Get.put(GlobalLoaderController(), permanent: true);

  HardwareKeyboard.instance.clearState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (_){
      return GetMaterialApp(
        theme: ThemeData(
          fontFamily: 'Sora',
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.white,

        ),

        debugShowCheckedModeBanner: false,
        title: 'Fyndr NG',

        getPages: AppRoutes.routes,
        initialRoute: AppRoutes.homeScreen,
        builder: (context, child) {
          final loaderController =
          Get.find<GlobalLoaderController>();
          return Obx(() {
            return Stack(
              children: [
                child!,
                if (loaderController.isLoading.value)
                  const AppLoadingOverlay(),
              ],
            );
          });
        },
      );
    });

  }
}
