import 'package:flutter/src/widgets/framework.dart';
import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/controllers/banner_controller.dart';
import 'package:fyndr_ng/controllers/chat_controller.dart';
import 'package:fyndr_ng/controllers/dispute_controller.dart';
import 'package:fyndr_ng/controllers/earning_controller.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/controllers/leads_controller.dart';
import 'package:fyndr_ng/controllers/notification_controller.dart';
import 'package:fyndr_ng/controllers/product_controller.dart';
import 'package:fyndr_ng/controllers/vendor_controller.dart';
import 'package:fyndr_ng/data/repo/app_repo.dart';
import 'package:fyndr_ng/data/repo/auth_repo.dart';
import 'package:fyndr_ng/data/repo/banner_repo.dart';
import 'package:fyndr_ng/data/repo/chat_repo.dart';
import 'package:fyndr_ng/data/repo/job_repo.dart';
import 'package:fyndr_ng/data/repo/notification_repo.dart';
import 'package:fyndr_ng/data/repo/product_repo.dart';
import 'package:fyndr_ng/helpers/push_notification.dart';
import 'package:fyndr_ng/helpers/socket_service.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_checker.dart';
import '../data/api/api_client.dart';
import '../utils/app_constants.dart';
import 'global_loader_controller.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.put(sharedPreferences);

  //api clients
  Get.lazyPut(
    () => ApiClient(
      appBaseUrl: AppConstants.BASE_URL,
      sharedPreferences: Get.find(),
    ),
  );
  Get.lazyPut(() => ApiChecker());
  Get.lazyPut(() => SocketService(), fenix: true);

  // repos
  Get.lazyPut(
    () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(() => GlobalLoaderController());
  Get.lazyPut(
    () => JobRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
    fenix: true,
  );
  Get.lazyPut(
    () => AppRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(() => ChatRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => ProductRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => NotificationService(), fenix: true);
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()), fenix: true);

  //controllers
  Get.lazyPut(
    () => AuthController(authRepo: Get.find(), apiClient: Get.find()),
  );
  Get.lazyPut(
    () => JobController(jobRepo: Get.find(), apiClient: Get.find()),
    fenix: true,
  );
  Get.lazyPut(
    () => AppController(
      appRepo: Get.find(),
      apiClient: Get.find(),
      apiChecker: Get.find(),
    ),
  );
  Get.lazyPut(() => VendorController());
  Get.lazyPut(() => LeadController(jobRepo: Get.find()), fenix: true);
  Get.lazyPut(
    () => ChatController(chatRepo: Get.find(), socketService: Get.find()),
    fenix: true,
  );
  Get.lazyPut(() => ProductController(productRepo: Get.find()), fenix: true);
  Get.lazyPut(() => NotificationController(repo: Get.find()), fenix: true);
  Get.lazyPut(() => EarningController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => DisputeController(disputeRepo: Get.find()), fenix: true);
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()), fenix: true);
}
