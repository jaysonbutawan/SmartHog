import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'farm_alerts_controller.dart';

class FarmAlertsPage extends StatelessWidget {
  const FarmAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FarmAlertsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF13B14F), size: 28),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Farm Alerts',
          style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Chips Row Module
                  _buildFilterCategoryBar(controller),
                  const SizedBox(height: 24),

                  // Dynamic Alert Cards Group
                  Obx(() {
                    final alerts = controller.filteredAlerts;
                    if (alerts.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: Text(
                            'No alerts found in this category',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      );
                    }

                    // Separate components cleanly by structural classification
                    final feedingAlerts = alerts.where((a) => a.category == AlertCategory.feeding).toList();
                    final deviceAlerts = alerts.where((a) => a.category == AlertCategory.device).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (feedingAlerts.isNotEmpty) ...[
                          _buildSectionLabel('FEEDING ISSUES'),
                          const SizedBox(height: 12),
                          ...feedingAlerts.map((alert) => _buildAlertCard(alert, controller)),
                          const SizedBox(height: 20),
                        ],
                        if (deviceAlerts.isNotEmpty) ...[
                          _buildSectionLabel('DEVICE ISSUES'),
                          const SizedBox(height: 12),
                          ...deviceAlerts.map((alert) => _buildAlertCard(alert, controller)),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildFilterCategoryBar(FarmAlertsController controller) {
    return Obx(() => Row(
          children: [
            _buildFilterChip('All', AlertCategory.all, controller),
            const SizedBox(width: 8),
            _buildFilterChip('Feeding Issues', AlertCategory.feeding, controller),
            const SizedBox(width: 8),
            _buildFilterChip('Devices', AlertCategory.device, controller),
          ],
        ));
  }

  Widget _buildFilterChip(String label, AlertCategory category, FarmAlertsController controller) {
    final bool isSelected = controller.activeFilter.value == category;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 13),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF13B14F),
      backgroundColor: Colors.white,
      side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFE2EBE5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (val) => controller.setFilter(category),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.6),
    );
  }

  Widget _buildAlertCard(FarmAlert alert, FarmAlertsController controller) {
    final Color indicatorColor = alert.isUrgent ? const Color(0xFFE53935) : const Color(0xFFFFA000);
    final Color borderColor = alert.isUrgent ? const Color(0xFFFFCDD2) : const Color(0xFFFFE082);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4, right: 12),
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${alert.subtitle} • ${alert.time}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (alert.category == AlertCategory.feeding)
                ElevatedButton(
                  onPressed: () => controller.refillFeed(alert.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13B14F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Refill Feed', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              else ...[
                TextButton(
                  onPressed: () => controller.resolveIssue(alert.id),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF13B14F)),
                  child: const Text('Resolve', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => controller.checkDevice(alert.subtitle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Check Device', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }
}