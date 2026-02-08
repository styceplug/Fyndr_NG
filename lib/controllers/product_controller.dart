import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/api/api_checker.dart';
import '../data/repo/product_repo.dart';
import '../model/product_model.dart';
import '../widgets/snackbars.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo;

  ProductController({required this.productRepo});

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();
  List<XFile> _selectedImages = [];
  List<XFile> get selectedImages => _selectedImages;
  bool _isFree = false;
  bool get isFree => _isFree;
  String? _selectedLocationFilter;
  String? get selectedLocation => _selectedLocationFilter;
  String _selectedCondition = 'used';
  String get selectedCondition => _selectedCondition;
  final List<String> conditions = ['new', 'used', 'refurbished'];
  List<ProductModel> _productList = [];
  List<ProductModel> _filteredList = [];
  List<ProductModel> get products => _filteredList;
  List<ProductModel> userProducts = [];
  double? selectedDistanceFilter;



  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String city = place.locality ?? place.subAdministrativeArea ?? '';
        String state = place.administrativeArea ?? '';

        if (city.isEmpty && state.isEmpty) return "Unknown Location";
        if (city.isEmpty) return state;
        if (state.isEmpty) return city;

        return "$city, $state";
      }
    } catch (e) {
      print("Geocoding error: $e");
    }
    return "Unknown Location";
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> body) async {
    CustomSnackBar.processing(message: "Updating product...");

    try {
      Response response = await productRepo.updateProduct(productId, body);

      if (response.statusCode == 200) {
        Get.back(); // Close bottom sheet
        getUserProducts(); // Refresh list
        CustomSnackBar.success(message: "Product updated!");
      } else {
        CustomSnackBar.failure(message: response.body['message'] ?? "Update failed");
      }
    } catch (e) {
      CustomSnackBar.failure(message: "Network error");
    }
  }

  Future<void> deleteProduct(String productId) async {
    CustomSnackBar.processing(message: "Deleting product...");

    try {
      Response response = await productRepo.deleteProduct(productId);

      if (response.statusCode == 204 || response.statusCode == 200) {
        // Remove locally to update UI instantly
        userProducts.removeWhere((p) => p.id == productId);
        update();
        Get.back(); // Close dialog if open
        CustomSnackBar.success(message: "Product deleted successfully");
      } else {
        CustomSnackBar.failure(message: response.body['message'] ?? "Failed to delete");
      }
    } catch (e) {
      CustomSnackBar.failure(message: "Network error");
    }
  }

  Future<void> getUserProducts() async {
    loader.showLoader();
    update(); // Notify UI to show loader

    try {
      Response response = await productRepo.getUserProducts();

      if (response.statusCode == 200) {
        userProducts = [];
        List<dynamic> list = response.body['data'];

        for (var item in list) {
          userProducts.add(ProductModel.fromJson(item));
        }
      } else {
        print("Error fetching user products: ${response.body}");
      }
    } catch (e) {
      print("Exception user products: $e");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  Future<void> getProducts() async {
    update();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      Response response = await productRepo.getProducts(
        lat: position.latitude,
        lng: position.longitude,
        maxDistance: 637100000,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.body['data'];
        _productList = data.map((e) => ProductModel.fromJson(e)).toList();

        _filteredList = List.from(_productList);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Error getting products: $e");
    }
    update();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _restoreList();
    } else {
      _filteredList = _productList.where((p) {
        return (p.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (p.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    }
    update();
  }

  void filterByDistance(double? km) {
    selectedDistanceFilter = km;

    if (km == null) {
      _restoreList();
    } else {
      _filteredList = _productList.where((p) {
        return p.rawDistance != null && p.rawDistance! <= km;
      }).toList();
    }
    update();
  }

  void _restoreList() {
    if (_selectedLocationFilter != null) {
      // If search is cleared but filter is active, re-apply filter
      filterByDistance(selectedDistanceFilter);
    } else {
      _filteredList = List.from(_productList);
    }
  }

  void toggleIsFree(bool val) {
    _isFree = val;
    update();
  }

  void setCondition(String? val) {
    if (val != null) {
      _selectedCondition = val;
      update();
    }
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    // Pick multiple images
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

    if (images.isNotEmpty) {
      if (_selectedImages.length + images.length > 10) {
        CustomSnackBar.failure(message: "Max 10 images allowed");
        return;
      }
      _selectedImages.addAll(images);
      update();
    }
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
    update();
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required String price,
    required double lat,
    required double lng,
  }) async {
    if (_selectedImages.isEmpty) {
      CustomSnackBar.failure(message: "Please add at least one image");
      return;
    }

    loader.showLoader();
    update();

    try {
      Response response = await productRepo.createProduct(
        name: name,
        isFree: _isFree,
        price: _isFree ? null : price,
        condition: _selectedCondition,
        lat: lat,
        lng: lng,
        description: description,
        images: _selectedImages,
      );

      if (response.statusCode == 201) {
        // Success
        CustomSnackBar.success(message: "Product created successfully!");
        Get.back(); // Close screen
      } else {
        // Validation/Server Error
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Error creating product: $e");
      CustomSnackBar.failure(message: "An error occurred");
    } finally {
      loader.hideLoader();
      update();
    }
  }
}
