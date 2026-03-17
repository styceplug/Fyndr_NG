import 'package:get/get.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class BannerRepo {
  final ApiClient apiClient;

  BannerRepo({required this.apiClient});


  Future<Response> getBanners() async {
    return await apiClient.getData(AppConstants.GET_BANNER_IMAGES);
  }

}
