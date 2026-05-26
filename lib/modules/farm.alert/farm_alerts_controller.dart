import 'package:get/get.dart';

enum AlertCategory { all, feeding, device }

class FarmAlert {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final AlertCategory category;
  final bool isUrgent; // true for red borders, false for orange/yellow borders

  FarmAlert({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.category,
    this.isUrgent = false,
  });
}

class FarmAlertsController extends GetxController {
  // Navigation index for the floating bottom bar
  final RxInt currentNavIndex = 3.obs; // Index 3 is Alerts

  // Active filter tab state
  final Rx<AlertCategory> activeFilter = AlertCategory.all.obs;

  // Observable source collection matching your mockup screens
  final RxList<FarmAlert> _alerts = <FarmAlert>[
    FarmAlert(
      id: '1',
      title: 'Feeder low on feed',
      subtitle: 'Pen 1',
      time: '10:30 AM',
      category: AlertCategory.feeding,
      isUrgent: false,
    ),
    FarmAlert(
      id: '2',
      title: 'Sensor Connection Failed',
      subtitle: 'IoT Gateway',
      time: '09:15 AM',
      category: AlertCategory.device,
      isUrgent: true,
    ),
  ].obs;

  // Filter computation logic run reactively
  List<FarmAlert> get filteredAlerts {
    if (activeFilter.value == AlertCategory.all) {
      return _alerts;
    }
    return _alerts.where((alert) => alert.category == activeFilter.value).toList();
  }

  void setFilter(AlertCategory category) {
    activeFilter.value = category;
  }

  // Action methods for button interactions
  void refillFeed(String alertId) {
    print('Executing feed refill system routine for alert: $alertId');
    _alerts.removeWhere((alert) => alert.id == alertId);
  }

  void resolveIssue(String alertId) {
    print('Marking issue $alertId as resolved.');
    _alerts.removeWhere((alert) => alert.id == alertId);
  }

  void checkDevice(String deviceName) {
    print('Opening hardware diagnostics channel for: $deviceName');
  }
}