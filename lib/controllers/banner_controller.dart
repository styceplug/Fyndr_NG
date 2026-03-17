import 'package:get/get.dart';

import '../data/repo/banner_repo.dart';
import '../model/banner_model.dart';

class BannerController extends GetxController {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});

  RxList<BannerModel> _bannerList = <BannerModel>[].obs;
  List<BannerModel> get bannerList => _bannerList;



  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;




  Future<void> getBanners() async {
    _isLoading.value = true;
    Response response = await bannerRepo.getBanners();

    if (response.statusCode == 200) {
      _bannerList.clear();
      var list = response.body['data'] as List;
      _bannerList.addAll(list.map((e) => BannerModel.fromJson(e)).toList());
    } else {
      // Handle error
      print("Could not fetch banners");
    }
    _isLoading.value = false;
  }
}