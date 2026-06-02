import 'package:get/get.dart';
import '../farm/farm_summary_service.dart';
import '../farm/farm_summary.dart';


class ScheduleModalController extends GetxController {
  final FarmSummaryService farmService;

  ScheduleModalController(this.farmService);

  var farms = <FarmSummary>[].obs;
  var selectedFarmId = RxnInt();
  
  // 1. Add status trackers
  var isLoading = false.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFarms();
  }

  Future<void> loadFarms() async {
    try {
      // 2. Set statuses when starting
      isLoading.value = true;
      isError.value = false;

      final res = await farmService.getFarms();

      // Use assignAll for RxLists instead of .value = 
      farms.assignAll(res.data);

      if (farms.isNotEmpty) {
        selectedFarmId.value = farms.first.id;
      }
    } catch (e) {
      // 3. Capture the error status if it fails
      isError.value = true;
      print('Error loading farms: $e'); 
    } finally {
      // 4. Always turn off loading at the end
      isLoading.value = false;
    }
  }

  void selectFarm(int id) {
    selectedFarmId.value = id;
  }
}