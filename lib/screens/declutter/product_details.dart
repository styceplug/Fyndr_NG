import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/product_controller.dart';
import '../../../model/product_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

import 'package:intl/intl.dart';

import '../../../widgets/snackbars.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product})
    : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  String _address = "Loading location...";

  AppController appController = Get.find<AppController>();

  void _loadAddress() async {
    double? lat = widget.product.lat;
    double? lng = widget.product.lng;

    if (lat == null && widget.product.location?.coordinates != null) {
      // Assuming [lng, lat] format
      lng = widget.product.location!.coordinates![0];
      lat = widget.product.location!.coordinates![1];
    }

    if (lat != null && lng != null) {
      // 2. Call the controller function
      String foundAddress = await Get.find<ProductController>()
          .getAddressFromCoordinates(lat, lng);

      if (mounted) {
        setState(() {
          _address = foundAddress;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _address = "Location unavailable";
        });
      }
    }
  }

  @override
  void initState() {
    _loadAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: 'N',
      decimalDigits: 0,
    );

    final chatController = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. IMAGE HEADER (With PageView for multiple images) ---
                  Stack(
                    children: [
                      Container(
                        height: Dimensions.height100 * 3.5,
                        width: double.infinity,
                        color: AppColors.grey3,
                        child:
                            (widget.product.images != null &&
                                    widget.product.images!.isNotEmpty)
                                ? PageView.builder(
                                  itemCount: widget.product.images!.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentImageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      widget.product.images![index],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                          ),
                                    );
                                  },
                                )
                                : const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                      ),

                      // Back Button
                      Positioned(
                        top: Dimensions.height50,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Get.back(),
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.snackbar(
                                  'Report Received',
                                  'Thanks for raising awareness. Our team will review this product shortly.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.black87,
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(Dimensions.height20),
                                  duration: const Duration(seconds: 3),
                                );
                              },
                              child: Text(
                                'Report',
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Image Indicator (Dots)
                      if (widget.product.images != null &&
                          widget.product.images!.length > 1)
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.product.images!.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _currentImageIndex == index
                                          ? AppColors
                                              .color1 // Active color
                                          : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(Dimensions.width20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER INFO ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style: TextStyle(
                                  fontSize: Dimensions.font20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              (widget.product.isFree ?? false)
                                  ? "FREE"
                                  : currencyFormatter.format(
                                    widget.product.price ?? 0,
                                  ),
                              style: TextStyle(
                                fontSize: Dimensions.font20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.color2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),

                        // --- BADGES ---
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (widget.product.condition != null)
                                _buildInfoBadge(
                                  Iconsax.verify,
                                  widget.product.condition!.capitalizeFirst ??
                                      '',
                                ),
                              SizedBox(width: Dimensions.width15),

                              _buildInfoBadge(
                                Iconsax.location,
                                widget.product.location?.distance ?? 'Nearby',
                              ),
                              SizedBox(width: Dimensions.width15),
                              _buildInfoBadge(Iconsax.map, _address),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // --- DESCRIPTION ---
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                        Text(
                          widget.product.description ??
                              'No description provided.',
                          style: TextStyle(
                            fontSize: Dimensions.font14,
                            color: AppColors.grey5,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        const Divider(color: AppColors.grey3),
                        SizedBox(height: Dimensions.height10),

                        // --- SELLER INFO ---
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.grey3,
                              backgroundImage:
                                  (widget.product.user?.profilePicture != null)
                                      ? NetworkImage(
                                        widget.product.user!.profilePicture!,
                                      )
                                      : null,
                              child:
                                  (widget.product.user?.profilePicture == null)
                                      ? const Icon(
                                        Icons.person,
                                        color: AppColors.grey5,
                                      )
                                      : null,
                            ),
                            SizedBox(width: Dimensions.width10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Posted by",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey4,
                                  ),
                                ),
                                Text(
                                  widget.product.sellerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              DateFormat.yMMMd().format(
                                widget.product.postedDate,
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey4,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BOTTOM CTA ---
          Container(
            padding: EdgeInsets.all(Dimensions.width20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: Dimensions.height50,
              child: GetBuilder<ChatController>(
                builder: (controller) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // 👇 Debug Prints
                      print("Product ID: ${widget.product.id}");
                      print("Seller ID: ${widget.product.user?.id}");

                      if (widget.product.id != null &&
                          widget.product.user?.id != null) {
                        appController.requireLogin(
                          title: "Sign in to make enquiries",
                          message: "You need an account to contact seller",
                          onAllowed:
                              () => controller.initiateProductChat(
                                productId: widget.product.id!,
                                sellerId: widget.product.user!.id!,
                                userId:
                                    Get.find<AuthController>().userModel!.id!,
                              ),
                        );
                      } else {
                        CustomSnackBar.failure(
                          message: "Invalid product data: Seller ID missing",
                        );
                      }
                    },
                    child:
                        controller.isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              "Make Enquiries",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.grey1,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.black),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
