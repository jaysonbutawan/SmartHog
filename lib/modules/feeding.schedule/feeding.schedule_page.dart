import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarthog/modules/feeding.schedule/widgets/new_schedule_modal.dart';
import 'widgets/section_card.dart';
import 'widgets/day_button.dart';
// Controller import
import 'feeding_schedule_controller.dart';

class FeedingSchedulePage extends StatelessWidget {
  const FeedingSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject and instantiate the state controller
    final FeedingScheduleController controller = Get.put(
      FeedingScheduleController(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0F3E1A),
            size: 28,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Feeding',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _buildOnlineBadge(),
          const SizedBox(width: 14),
          _buildAvatar(),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
          

            // CARD 3: Schedule Configuration
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SCHEDULE CONFIGURATION',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFF13B14F),
                          size: 28,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const NewScheduleModal(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '05:30 PM',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isScheduleActive.value,
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xFF13B14F),
                          inactiveTrackColor: Colors.grey.shade300,
                          onChanged: controller.toggleSchedule,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'May 24, 2026',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2EBE5), thickness: 1),
                  const SizedBox(height: 16),
                  const Text(
                    'Repeat every week on:',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Wrap day elements
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: controller.allDays.map((day) {
                        return DayButton(
                          day: day,
                          isSelected: controller.selectedDays.contains(day),
                          onTap: () => controller.toggleDay(day),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // App Bar layout piece helper extractions
  Widget _buildOnlineBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF13B14F),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'ONLINE',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
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
