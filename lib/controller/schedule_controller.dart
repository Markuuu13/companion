import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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

      final now = DateTime.now();

      for (var schedule in result) {
        final dateStr = schedule['deadlineDate'];
        final timeStr = schedule['deadlineTime'];

        if (dateStr != null && timeStr != null) {
          try {
            final hasSeconds = timeStr.split(':').length == 3;
            final fullDateTimeStr = "$dateStr $timeStr";

            final deadline = DateFormat(
              hasSeconds ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd HH:mm",
            ).parse(fullDateTimeStr);

            final isNotDone = schedule['status_id'] != 3;
            final isMissed = DateTime.now().isAfter(deadline);

            if (isMissed && isNotDone && schedule['status_id'] != 4) {
              await _scheduleService.updateScheduleStatus(
                scheduleId: schedule['schedule_id'],
                context: Get.context!,
                status: 4,
              );
            }
          } catch (e) {
            print("Error parsing datetime: $dateStr $timeStr -> $e");
          }
        }
      }
      final updatedList = await _scheduleService.scheduleToday(
        Get.context!,
        userId,
      );
      scheduleToday.assignAll(updatedList);
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

  int get missedCount => scheduleToday.where((e) => e['status_id'] == 4).length;
}
