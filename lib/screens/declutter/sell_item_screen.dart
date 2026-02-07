import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/country_state_dropdown.dart';
import '../../widgets/snackbars.dart';

class SellItemScreen extends StatefulWidget {
  const SellItemScreen({super.key});

  @override
  State<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationDisplayController =
      TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _isFetchingLocation = false;
  String _locationText = "Tap to get current location";

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _locationDisplayController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isFetchingLocation = true);

    try {
      // 1. Check Permissions (Basic check, refine as needed)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          CustomSnackBar.failure(message: "Location permission denied");
          return;
        }
      }

      // 2. Get Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationText =
            "Lat: ${_latitude!.toStringAsFixed(4)}, Lng: ${_longitude!.toStringAsFixed(4)}";
        _locationDisplayController.text = _locationText;
      });

      CustomSnackBar.success(message: "Location acquired!");
    } catch (e) {
      CustomSnackBar.failure(message: "Failed to get location");
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: 'Sell Item',
        actionIcon: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.myProductsScreen);
          },
          child: Text('My Products', style: TextStyle(color: AppColors.color1)),
        ),
      ),
      body: GetBuilder<ProductController>(
        init: ProductController(productRepo: Get.find()),
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height20,
              Dimensions.width20,
              Dimensions.bottomNavIconHeight + Dimensions.height50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. IMAGES SECTION ---
                Text(
                  'Product Images (Max 10)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: Dimensions.height10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Add Button
                      GestureDetector(
                        onTap: () => controller.pickImages(),
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppColors.grey1,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.grey4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, color: AppColors.grey4),
                              SizedBox(height: 5),
                              Text(
                                "Add",
                                style: TextStyle(color: AppColors.grey4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Selected Images List
                      ...List.generate(controller.selectedImages.length, (
                        index,
                      ) {
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                    File(controller.selectedImages[index].path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 10,
                              child: GestureDetector(
                                onTap: () => controller.removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height20),

                // --- 2. BASIC INFO ---
                _buildLabel('Product Name'),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'e.g. iPhone 13 Pro Max',
                ),
                SizedBox(height: Dimensions.height20),

                _buildLabel('Description'),
                CustomTextField(
                  controller: _descController,
                  hintText: 'Describe the condition, features, faults...',
                  maxLines: 4,
                ),
                SizedBox(height: Dimensions.height20),

                // --- 3. PRICING & CONDITION ---
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Condition'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey4),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius10,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedCondition,
                                isExpanded: true,
                                items:
                                    controller.conditions.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.capitalizeFirst!),
                                      );
                                    }).toList(),
                                onChanged:
                                    (val) => controller.setCondition(val),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Dimensions.width15),

                    // Is Free Switch
                    Column(
                      children: [
                        _buildLabel('Free Item?'),
                        Switch(
                          value: controller.isFree,
                          activeColor: AppColors.color2,
                          onChanged: (val) => controller.toggleIsFree(val),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height20),

                // Price Field (Conditional)
                if (!controller.isFree) ...[
                  _buildLabel('Price (N)'),
                  CustomTextField(
                    controller: _priceController,
                    hintText: '0.00',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: Dimensions.height20),
                ],

                // --- 4. LOCATION (UPDATED) ---
                _buildLabel('Location'),
                GestureDetector(
                  onTap: _getCurrentLocation, // Fetch GPS on tap
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey4),
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      color: AppColors.grey1.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.my_location, color: AppColors.color1),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _locationText,
                            style: TextStyle(
                              color:
                                  _latitude != null
                                      ? Colors.black
                                      : AppColors.grey4,
                            ),
                          ),
                        ),
                        if (_isFetchingLocation)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.height40),

                // --- 5. SUBMIT BUTTON ---
                CustomButton(
                  text: 'Create Product',
                  onPressed: () {
                    // Basic Form Validation
                    if (_nameController.text.isEmpty ||
                        _descController.text.isEmpty) {
                      CustomSnackBar.failure(message: "Please fill all fields");
                      return;
                    }

                    if (_latitude == null || _longitude == null) {
                      CustomSnackBar.failure(message: "Please detect your location first");
                      return;
                    }

                    if (!controller.isFree && _priceController.text.isEmpty) {
                      CustomSnackBar.failure(message: "Please enter a price");
                      return;
                    }

                    controller.createProduct(
                      name: _nameController.text.trim(),
                      description: _descController.text.trim(),
                      price: _priceController.text.trim(),
                      lat: _latitude!,
                      lng: _longitude!,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height5),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
