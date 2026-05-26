import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'feeding_history_controller.dart';

class FeedingHistoryPage extends StatelessWidget {
  const FeedingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedingHistoryController());

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
          'Feeding History',
          style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildOnlineBadge(),
          const SizedBox(width: 14),
          _buildAvatar(),
          const SizedBox(width: 16),
        ],
      ),
      // Stack lets us float the custom bottom navigation bar on top
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Search Field
                  _buildSearchBar(controller),
                  const SizedBox(height: 16),

                  // 2. Month Filters Horizontal Row Component
                  _buildMonthFilterRow(controller),
                  const SizedBox(height: 16),

                  // 3. Dynamic Data Log Grid Table Card
                  _buildHistoryTableCard(controller),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildSearchBar(FeedingHistoryController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: controller.updateSearch,
        decoration: const InputDecoration(
          icon: Icon(Icons.grid_on_outlined, color: Color(0xFF13B14F)),
          hintText: 'Search feeding logs...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMonthFilterRow(FeedingHistoryController controller) {
    return SizedBox(
      height: 38,
      child: Obx(() {
        final months = controller.availableMonths;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: months.length,
          itemBuilder: (context, index) {
            final monthDate = months[index];
            final label = DateFormat('MMMM yyyy').format(monthDate);
            final isSelected = controller.selectedMonth.value?.year == monthDate.year &&
                controller.selectedMonth.value?.month == monthDate.month;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.amber.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF13B14F),
                backgroundColor: Colors.white,
                side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFE2EBE5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onSelected: (_) => controller.selectMonthFilter(monthDate),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildHistoryTableCard(FeedingHistoryController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2EBE5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Obx(() {
          final logs = controller.filteredLogs;

          return Table(
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1.0),
              2: FlexColumnWidth(0.8),
            },
            children: [
              // Header Row Setup
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFEAF5EE)),
                children: [
                  _buildTableCell('DATE', isHeader: true),
                  _buildTableCell('TIME', isHeader: true),
                  _buildTableCell('AMOUNT', isHeader: true, alignRight: true),
                ],
              ),
              // Body Logs Generation Mapping
              ...logs.map((log) {
                return TableRow(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFF0F4F1), width: 1)),
                  ),
                  children: [
                    _buildTableCell(DateFormat('MMM dd, yyyy').format(log.date)),
                    _buildTableCell(log.time, isTime: true),
                    _buildTableCell('${log.amountKg.toStringAsFixed(0)} kg', isAmount: true, alignRight: true),
                  ],
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, bool isTime = false, bool isAmount = false, bool alignRight = false}) {
    TextStyle style = const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500);
    
    if (isHeader) {
      style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF2C4A35), letterSpacing: 0.5);
    } else if (isTime) {
      style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black);
    } else if (isAmount) {
      style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black87);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.end : TextAlign.start,
        style: style,
      ),
    );
  }

  // Top App Bar Decorators
  Widget _buildOnlineBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF13B14F), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('ONLINE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return const Center(
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFF13B14F),
        child: Icon(Icons.person, color: Colors.white, size: 22),
      ),
    );
  }
}