import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/notification_controller.dart';
import '../../../model/user_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../in_app/web_view_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  AuthController authController = Get.find<AuthController>();
  AppController appController = Get.find<AppController>();
  NotificationController notificationController = Get.find<NotificationController>();


  UserModel? get user => authController.userModel;

  @override
  void initState() {
    notificationController.refreshUnreadCount();
    super.initState();
  }

  void deleteAccountPrompt() async {
    Get.dialog(
      AlertDialog(
        title: Text("Delete Account"),
        content: Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.deleteAccount();
            },
            child: Text(
              "Yes, Delete",
              style: TextStyle(
                color: AppColors.color1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height10 * 8,
          Dimensions.width20,
          Dimensions.bottomNavIconHeight + Dimensions.height50,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                    child: GetBuilder<NotificationController>(
                      builder: (notificationController) {
                        return Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.width10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.color5,
                              ),
                              child: Image.asset(
                                AppConstants.getPngAsset('bell-icon'),
                                height: Dimensions.height30,
                                width: Dimensions.width30,
                              ),
                            ),
                            if (notificationController.unreadCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    notificationController.unreadCount > 99
                                        ? '99+'
                                        : '${notificationController.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                ],
              ),
              SizedBox(height: Dimensions.height20),
              GetBuilder<AuthController>(builder: (authCtrl) {

                String? avatarUrl = user?.avatar;
                if (avatarUrl != null && avatarUrl.isNotEmpty && !avatarUrl.startsWith('http')) {
                  avatarUrl = '${AppConstants.BASE_URL}$avatarUrl';
                }

                double ratingValue = double.tryParse(user?.ratings ?? '0.0') ?? 0.0;

                return GestureDetector(
                  onTap: () {
                    authCtrl.pickAndUploadAvatar();
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.color4,
                              shape: BoxShape.circle, // Circular profile pic is standard
                              border: Border.all(color: AppColors.color1, width: 2),
                              image: (avatarUrl != null && avatarUrl.isNotEmpty)
                                  ? DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: (user?.avatar == null || user!.avatar!.isEmpty)
                                ? Center(
                              child: Image.asset(
                                AppConstants.getPngAsset('head-icon'),
                                height: 50,
                                width: 50,
                              ),
                            )
                                : null,
                          ),

                          // Camera Icon Badge
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.color1,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height5),
                      Text(user?.businessDetails?.businessName ?? '', style: TextStyle(fontSize: Dimensions.font20)),
                      SizedBox(height: Dimensions.height5),
                      IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10,
                            vertical: Dimensions.height5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.color3,
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.location,
                                color: Colors.white,
                                size: Dimensions.iconSize16 * 0.9,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                '${user?.businessDetails?.businessLocation?.state}, ${user?.businessDetails?.businessLocation?.lga}',
                                style: TextStyle(
                                  fontSize: Dimensions.font12 * 0.9,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Generate 5 stars dynamically
                          ...List.generate(5, (index) {
                            return Icon(
                              // If the rating is greater than the current index, fill the star
                              // e.g., if rating is 3.5:
                              // index 0 (1st star) < 3.5 -> Filled
                              // index 3 (4th star) > 3.5 -> Empty (or half if you want advanced logic)
                              index < ratingValue.floor() ? Iconsax.star1 : Iconsax.star, // Filled vs Outline
                              color: index < ratingValue.floor() ? AppColors.color4 : AppColors.grey3,
                              size: Dimensions.iconSize20, // Optional: ensure consistent size
                            );
                          }),

                          SizedBox(width: Dimensions.width5),

                          // Display the value
                          Text(
                            ratingValue.toStringAsFixed(1), // Ensures "4.0" instead of "4"
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.font16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),


              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DataCard('0', 'Jobs Done'),
                    DataCard('0', 'On-time'),
                    DataCard(user?.getAccountAge(user?.createdAt) ?? '', 'Member'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  children: [
                    OptionCard('edit-profile', 'Edit Profile'),
                    Divider(color: AppColors.grey2),
                    OptionCard('switch-icon', 'Switch Account',onTap: (){
                      authController.handleSwitchAccountTap();
                    }),
                    Divider(color: AppColors.grey2),
                    OptionCard('delete-2', 'Delete Account',onTap: (){
                      deleteAccountPrompt();
                    }),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  children: [
                    OptionCard('bell-icon', 'Notifications'),
                    Divider(color: AppColors.grey2),
                    OptionCard('pin-icon', 'Location Services'),
                    Divider(color: AppColors.grey2),
                    OptionCard('payment-icon', 'Payment Method'),
                    Divider(color: AppColors.grey2),
                    OptionCard('log-out', 'Logout',onTap: (){
                      appController.clearSharedData();
                    }),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'SUPPORT',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  children: [
                    OptionCard(
                      'help-icon',
                      'Service Provider Guide',
                      onTap: () {
                        Get.to(() => InAppWebViewScreen(
                          url: 'https://fyndr.ng/service-provider-guide/',
                          title: 'Service Provider Guide',
                        ));
                      },
                    ),
                    Divider(color: AppColors.grey2),
                    OptionCard(
                      'terms',
                      'Terms and condition',
                      onTap: () {
                        Get.to(
                              () => InAppWebViewScreen(
                            url: 'https://fyndr.ng/fyndr-terms-and-conditions/',
                            title: 'Terms and Conditions',
                          ),
                        );
                      },
                    ),
                    Divider(color: AppColors.grey2),
                    OptionCard(
                      'terms',
                      'Privacy Policy',
                      onTap: () {
                        Get.to(
                              () => InAppWebViewScreen(
                            url: 'https://fyndr.ng/privacy-policy/',
                            title: 'Privacy Policy',
                          ),
                        );
                      },
                    ),

                    Divider(color: AppColors.grey2),
                    OptionCard(
                      'terms',
                      'Refund Cancellation Policy',
                      onTap: () {
                        Get.to(
                              () => InAppWebViewScreen(
                            url:
                            'https://fyndr.ng/fyndr-refund-cancellation-policy/',
                            title: 'Refund Cancellation Policy',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height50,)

            ],
          ),
        ),
      ),
    );
  }

  Widget DataCard(String value, String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey2),
        borderRadius: BorderRadius.circular(Dimensions.radius10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.height5),
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font13,
              fontWeight: FontWeight.w300,
              color: AppColors.grey4,
            ),
          ),
        ],
      ),
    );
  }

  Widget OptionCard(String image, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height5,top: Dimensions.height5),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              AppConstants.getPngAsset(image),
              height: Dimensions.height10 * 2.5,
              width: Dimensions.width10 * 2.5,
            ),
            SizedBox(width: Dimensions.width10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
