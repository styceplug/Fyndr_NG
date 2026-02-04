import 'package:flutter/material.dart';
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

class BrowseScreen extends StatelessWidget {
  // Use Get.put to initialize if not already done in binding
  final ProductController controller = Get.put(
    ProductController(productRepo: Get.find()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height50,
          Dimensions.width20,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Text(
              'Declutter',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: Dimensions.height20),

            // --- TABS ---
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'Browse',
                      style: TextStyle(
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.color2,
                      ),
                    ),
                    Container(height: 2, width: 20, color: AppColors.color2),
                  ],
                ),
                SizedBox(width: Dimensions.width20),
                InkWell(
                  onTap: () => Get.toNamed(AppRoutes.sellItemScreen),
                  child: Text(
                    'Sell item',
                    style: TextStyle(
                      fontSize: Dimensions.font18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey4,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            // --- SEARCH & FILTER ---
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    onChanged: (val) => controller.searchProducts(val),
                    prefixIcon: Icon(Icons.search, color: AppColors.grey4),
                    // Simplified icon
                    hintText: 'Search items...',
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                InkWell(
                  onTap: () => _showFilterModal(context),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.color1,
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Icon(Iconsax.setting_4, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            // --- PRODUCT GRID ---
            Expanded(
              child: GetBuilder<ProductController>(
                builder: (ctrl) {
                  if (ctrl.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          Text("No items found"),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => await ctrl.getProducts(),
                    child: GridView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: Dimensions.width15,
                        mainAxisSpacing: Dimensions.height15,
                      ),
                      itemCount: ctrl.products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(ctrl.products[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    // Determine image provider safely
    ImageProvider imageProvider;
    if (product.images != null && product.images!.isNotEmpty) {
      imageProvider = NetworkImage(product.images!.first);
    } else {
      imageProvider = AssetImage(
        AppConstants.getPngAsset('placeholder'),
      ); // Fallback
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: 'N',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.radius15),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
                child: Stack(
                  children: [
                    if (product.condition != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.condition!.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 12,
                              color: AppColors.grey4,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                product.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.grey4,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      (product.isFree ?? false)
                          ? "FREE"
                          : currencyFormatter.format(product.price ?? 0),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.font15,
                        color: AppColors.color2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return GetBuilder<ProductController>(
          builder: (ctrl) {
            return Container(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter By Location",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children:
                        [
                          "Abaji",
                          "Abuja Municipal (AMAC)",
                          "Bwari",
                          "Gwagwalada",
                          "Kuje",
                          "Kwali",
                          "Lagos",
                          "Ikeja",
                        ].map((loc) {
                          return ChoiceChip(
                            label: Text(loc),
                            selected: ctrl.selectedLocation == loc,
                            onSelected: (bool selected) {
                              ctrl.filterByLocation(selected ? loc : null);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product})
    : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: 'N',
      decimalDigits: 0,
    );

    // Access the controller
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
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
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
                              _buildInfoBadge(
                                Iconsax.location,
                                widget.product.location,
                              ),
                              SizedBox(width: Dimensions.width15),
                              if (widget.product.condition != null)
                                _buildInfoBadge(
                                  Iconsax.verify,
                                  widget.product.condition!.capitalizeFirst ?? '',
                                ),
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
                    onPressed:
                        controller.isLoading
                            ? null // Disable button while loading
                            : () {
                              if (widget.product.id != null &&
                                  widget.product.user?.id != null) {
                                controller.initiateProductChat(
                                  productId: widget.product.id!,
                                  sellerId: widget.product.user!.id!,
                                  userId:
                                      Get.find<AuthController>().userModel!.id!,
                                );
                              } else {
                                CustomSnackBar.failure(
                                  message: "Invalid product data",
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
