import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/product_controller.dart';
import '../../model/product_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final ProductController controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    // Load products when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: "My Listings",
      ),
      body: GetBuilder<ProductController>(
        builder: (ctrl) {

          if (ctrl.userProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 60, color: AppColors.grey4),
                  SizedBox(height: 10),
                  Text("No products listed yet", style: TextStyle(color: AppColors.grey5)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: ctrl.getUserProducts,
            child: ListView.separated(
              padding: EdgeInsets.all(Dimensions.width20),
              itemCount: ctrl.userProducts.length,
              separatorBuilder: (_, __) => SizedBox(height: Dimensions.height15),
              itemBuilder: (context, index) {
                return _buildProductCard(ctrl.userProducts[index], ctrl);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, ProductController ctrl) {
    // 1. Safe Image URL Logic
    String imageUrl = "";
    if (product.images != null && product.images!.isNotEmpty) {
      String raw = product.images![0];
      imageUrl = raw.startsWith('http') ? raw : '${AppConstants.BASE_URL}$raw';
    }

    // 2. Format Price
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    String price = product.isFree == true
        ? "Free"
        : currencyFormatter.format(product.price ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
        border: Border.all(color: AppColors.grey2),
      ),
      child: Row(
        children: [
          // Image
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius15),
                bottomLeft: Radius.circular(Dimensions.radius15),
              ),
              color: AppColors.grey2,
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? Icon(Icons.image_not_supported, color: AppColors.grey4)
                : null,
          ),

          // Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? "Unknown Item",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.font16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      color: AppColors.color1,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font14,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Actions Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // EDIT BUTTON
                      InkWell(
                        onTap: () => _showEditSheet(context, product, ctrl),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.color3.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, size: 18, color: AppColors.color1),
                        ),
                      ),
                      SizedBox(width: 15),
                      // DELETE BUTTON
                      InkWell(
                        onTap: () => _confirmDelete(context, product.id!, ctrl),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.delete, size: 18, color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DELETE DIALOG ---
  void _confirmDelete(BuildContext context, String id, ProductController ctrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Listing"),
        content: Text("Are you sure you want to delete this product? This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ctrl.deleteProduct(id); // Call API
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- EDIT SHEET ---
  void _showEditSheet(BuildContext context, ProductModel product, ProductController ctrl) {
    final _nameCtrl = TextEditingController(text: product.name);
    final _priceCtrl = TextEditingController(text: product.price?.toString());
    final _descCtrl = TextEditingController(text: product.description);

    // Simple state for isFree toggle inside sheet
    bool isFree = product.isFree ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setSheetState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Edit Product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),

                    CustomTextField(controller: _nameCtrl, hintText: "Product Name"),
                    SizedBox(height: 15),

                    Row(
                      children: [
                        Checkbox(
                            value: isFree,
                            activeColor: AppColors.color1,
                            onChanged: (val) {
                              setSheetState(() => isFree = val!);
                            }
                        ),
                        Text("Give away for free"),
                      ],
                    ),

                    if (!isFree)
                      CustomTextField(
                          controller: _priceCtrl,
                          hintText: "Price",
                          keyboardType: TextInputType.number
                      ),

                    SizedBox(height: 15),
                    CustomTextField(
                        controller: _descCtrl,
                        hintText: "Description",
                        maxLines: 3
                    ),

                    SizedBox(height: 20),
                    CustomButton(
                      text: "Save Changes",
                      onPressed: () {
                        final body = {
                          "name": _nameCtrl.text.trim(),
                          "description": _descCtrl.text.trim(),
                          "isFree": isFree,
                          if (!isFree) "price": int.tryParse(_priceCtrl.text) ?? 0,
                        };
                        ctrl.updateProduct(product.id!, body);
                      },
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }
}
