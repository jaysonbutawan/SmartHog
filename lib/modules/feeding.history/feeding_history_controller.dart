import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FeedingLog {
  final DateTime date;
  final String time;
  final double amountKg;

  FeedingLog({required this.date, required this.time, required this.amountKg});
}

class FeedingHistoryController extends GetxController {
  // Navigation State
  final RxInt currentNavIndex = 2.obs; // Index 2 for Feeding History

  // Search and Filter States
  final RxString searchQuery = ''.obs;
  final Rxn<DateTime> selectedMonth = Rxn<DateTime>(); // null means "All"

  // Raw Sample Data Base populated from your mockup reference
  final List<FeedingLog> _rawLogs = [
    FeedingLog(date: DateTime(2025, 5, 24), time: '06:30 AM', amountKg: 25),
    FeedingLog(date: DateTime(2025, 5, 23), time: '06:00 PM', amountKg: 20),
    FeedingLog(date: DateTime(2025, 5, 23), time: '12:00 PM', amountKg: 20),
    FeedingLog(date: DateTime(2025, 5, 23), time: '06:30 AM', amountKg: 25),
    FeedingLog(date: DateTime(2025, 5, 22), time: '06:00 PM', amountKg: 20),
    FeedingLog(date: DateTime(2025, 5, 22), time: '12:00 PM', amountKg: 20),
    FeedingLog(date: DateTime(2025, 5, 22), time: '06:30 AM', amountKg: 25),
    FeedingLog(date: DateTime(2025, 5, 15), time: '09:00 AM', amountKg: 15),
    FeedingLog(date: DateTime(2025, 4, 18), time: '06:00 PM', amountKg: 22),
  ];

  // Dynamically extract distinct months present in the logs for the filter row
  List<DateTime> get availableMonths {
    final months = <DateTime>[];
    for (var log in _rawLogs) {
      final target = DateTime(log.date.year, log.date.month);
      if (!months.any((m) => m.year == target.year && m.month == target.month)) {
        months.add(target);
      }
    }
    months.sort((a, b) => b.compareTo(a)); // Newest months first
    return months;
  }

  // Computed and filtered list based on user selections
  List<FeedingLog> get filteredLogs {
    return _rawLogs.where((log) {
      // 1. Month Filtering
      if (selectedMonth.value != null) {
        if (log.date.year != selectedMonth.value!.year || log.date.month != selectedMonth.value!.month) {
          return false;
        }
      }

      // 2. Search Text Filtering
      if (searchQuery.value.isNotEmpty) {
        final dateString = DateFormat('MMM dd, yyyy').format(log.date).toLowerCase();
        final query = searchQuery.value.toLowerCase();
        final timeString = log.time.toLowerCase();
        final amountString = "${log.amountKg.toStringAsFixed(0)} kg".toLowerCase();

        return dateString.contains(query) || timeString.contains(query) || amountString.contains(query);
      }

      return true;
    }).toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void selectMonthFilter(DateTime? month) {
    if (selectedMonth.value == month) {
      selectedMonth.value = null; // Toggle off if clicked again
    } else {
      selectedMonth.value = month;
    }
  }

  void handleNavigation(int index) {
    currentNavIndex.value = index;
    // Map navigation routing steps here as needed
  }
}