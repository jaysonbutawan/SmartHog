import 'package:flutter/material.dart';
import 'package:smarthog/modules/feeding.schedule/feeding.schedule_page.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 0;
  //  final List<Widget> pages = [
  //   HomeScreen(),
  //   SearchScreen(),
  //   NotificationsScreen(),
  //   ProfileScreen(),
  // ];

  final List<Widget> _pages = const [
    Center(child: Text("Home Page")),
    FeedingSchedulePage(),
    Center(child: Text("Feeding History Page")),
    Center(child: Text("Alerts Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // The nav bar is placed inside the bottomNavigationBar slot
      bottomNavigationBar: CustomPillNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomPillNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomPillNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Custom colors from the input image
    const Color activeColor = Color(0xFF1E9C4F); // Green
    const Color inactiveColor = Color(0xFF818C99); // Blue/Grey
    const Color backgroundColor = Colors.white;

    return Container(
      // Padding to create the "floating" effect
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        // Strong rounded corners to create the pill shape
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Overview Tab
          _buildNavItem(
            icon: Icons.home_filled, // Use home icon instead of house shape for simplicity
            label: "Overview",
            index: 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          // 2. Schedule Tab
          _buildNavItem(
            icon: Icons.calendar_today_outlined,
            label: "Schedule",
            index: 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          // 3. Feeding History Tab
          _buildNavItem(
            icon: Icons.bar_chart_outlined,
            label: "Feeding His...", // Replicated truncation
            index: 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          // 4. Alerts Tab (with notification dot)
          _buildNavItem(
            icon: Icons.notifications_none_outlined,
            label: "Alerts",
            index: 3,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            hasBadge: true, // Specific parameter for the red dot
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
    bool hasBadge = false,
  }) {
    final bool isActive = currentIndex == index;
    final Color color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: color, size: 28),
              if (hasBadge)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
          // Underline indicator for the active item
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 30, // Fixed width underline
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}