import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../service/schedule_service.dart';

class ScheduleController extends GetxController {
  final ScheduleService _scheduleService = ScheduleService();
  final box = GetStorage();

  var scheduleToday = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodaySchedule();
  }

  Future<void> fetchTodaySchedule() async {
    isLoading.value = true;
    try {
      final userId = box.read('userid');
      final result = await _scheduleService.scheduleToday(Get.context!, userId);
      scheduleToday.assignAll(result);
    } catch (e) {
      print("Error fetching today's schedule: $e");
    } finally {
      isLoading.value = false;
    }
  }

  int get pendingCount =>
      scheduleToday.where((e) => e['status_id'] == 2).length;

  int get completedCount =>
      scheduleToday.where((e) => e['status_id'] == 3).length;

  int get missedCount => scheduleToday.where((e) => e['status_id'] == 1).length;
}
