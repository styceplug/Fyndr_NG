import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:get/get.dart';
import '../data/repo/auth_repo.dart';
import '../model/earning_model.dart';

enum EarningFilter { thisMonth, lastMonth, allTime }

class EarningController extends GetxController {
  final AuthRepo authRepo;

  EarningController({required this.authRepo});

  EarningModel? _earningModel;
  EarningModel? get earningModel => _earningModel;
  GlobalLoaderController loader = Get.find<GlobalLoaderController>();


  String? _error;
  String? get error => _error;

  EarningFilter _selectedFilter = EarningFilter.thisMonth;
  EarningFilter get selectedFilter => _selectedFilter;

  @override
  void onInit() {
    super.onInit();
    fetchEarningData();
  }

  void setFilter(EarningFilter filter) {
    _selectedFilter = filter;
    update();
  }

  num get displayEarnings {
    if (_earningModel == null) return 0;
    switch (_selectedFilter) {
      case EarningFilter.thisMonth:
        return _earningModel!.data.thisMonthEarnings;
      case EarningFilter.lastMonth:
        return _earningModel!.data.lastMonthEarnings;
      case EarningFilter.allTime:
        return _earningModel!.data.allTimeEarnings.total;
    }
  }

  int get displayJobsDone {
    if (_earningModel == null) return 0;

    return _earningModel!.data.allTimeEarnings.jobsDone;
  }

  /// Returns the average per job for the currently selected filter tab
  num get displayAveragePerJob {
    if (_earningModel == null) return 0;
    return _earningModel!.data.allTimeEarnings.averagePerJob;
  }

  Future<void> fetchEarningData() async {
    loader.showLoader();
    _error = null;
    update();

    try {
      final res = await authRepo.getEarningData();
      if (res.statusCode == 200) {
        _earningModel = EarningModel.fromJson(res.body);
      } else {
        _error = 'Failed to load earnings. Please try again.';
      }
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      print(e);
    } finally {
      loader.hideLoader();
      update();
    }
  }
}