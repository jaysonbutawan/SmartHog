import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../feeding_schedule_controller.dart';
import 'day_button.dart';
import 'add_time_dialog.dart';
import 'section_card.dart';
import 'feed_type_card.dart';
import 'pen_button.dart';
class NewScheduleModal extends StatelessWidget {
  const NewScheduleModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewScheduleModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedingScheduleController>();
    final allDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Content Block
            const Text(
              'New Schedule',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Configure your feeding routine',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
              // CARD 1: Select Pen
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. SELECT PEN',
                    style: TextStyle(
                      color: Color(0xFF0C4626),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => Row(
                      children: [
                        PenButton(
                          label: 'Pen 1',
                          isSelected: controller.selectedPen.value == 'Pen 1',
                          onTap: () => controller.changePen('Pen 1'),
                        ),
                        const SizedBox(width: 12),
                        PenButton(
                          label: 'Pen 2',
                          isSelected: controller.selectedPen.value == 'Pen 2',
                          onTap: () => controller.changePen('Pen 2'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CARD 2: Select Feed Type
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2. SELECT FEED TYPE',
                    style: TextStyle(
                      color: Color(0xFF0C4626),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: FeedTypeCard(
                            title: 'Pre-Starter',
                            subtitle: 'Newborn',
                            isSelected:
                                controller.selectedFeedType.value ==
                                'Pre-Starter',
                            onTap: () =>
                                controller.changeFeedType('Pre-Starter'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: FeedTypeCard(
                            title: 'Starter',
                            subtitle: 'Young',
                            isSelected:
                                controller.selectedFeedType.value == 'Starter',
                            onTap: () => controller.changeFeedType('Starter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE2EBE5), thickness: 1),
            const SizedBox(height: 16),

            // Section 1: Time Slots
            _buildSectionHeader('TIME SLOTS'),
            const SizedBox(height: 12),
            Row(
              children: [
          OutlinedButton.icon(
      onPressed: () {
        // Trigger the exact input design frame
        AddTimeDialog.show(context, (hour, minute, period) {
          controller.addTimeSlot(hour, minute, period);
        });
      },
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Add Time'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF13B14F),
        side: const BorderSide(color: Color(0xFF13B14F), width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 24),

            // Section 2: Start Date (Fixed Placeholder)
            _buildSectionHeader('START DATE'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.startDate.value,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (picked != null) controller.updateStartDate(picked);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6FAF6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0EBE3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        DateFormat(
                          'MMMM dd, yyyy',
                        ).format(controller.startDate.value),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF13B14F),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section 3: Quantity Slider Counter (Fixed Placeholder)
            _buildSectionHeader('QUANTITY (KG)'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAF6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0EBE3)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.decrementQuantity,
                    icon: const Icon(Icons.remove, color: Colors.grey),
                  ),
                  Expanded(
                    child: Center(
                      child: Obx(
                        () => Text(
                          '${controller.quantityKg.value} KG',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF13B14F),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(13),
                      ),
                    ),
                    child: IconButton(
                      onPressed: controller.incrementQuantity,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 4: Repeat On
            _buildSectionHeader('REPEAT ON'),
            const SizedBox(height: 14),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 12,
                children: allDays.map((day) {
                  final isSelected = controller.modalSelectedDays.contains(day);
                  return DayButton(
                    day: day,
                    isSelected: isSelected,
                    onTap: () => controller.toggleModalDay(day),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),

            // Action Buttons Footer Row
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.saveNewSchedule(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13B14F),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: 0.6,
      ),
    );
  }
}
