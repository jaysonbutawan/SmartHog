import 'package:get/get.dart';

class FeedingScheduleController extends GetxController {
  final RxString selectedPen = 'Pen 1'.obs;
  final RxString selectedFeedType = 'Starter'.obs;
  final RxBool isScheduleActive = true.obs;
  
  final RxList<String> selectedDays = <String>['Mon', 'Tue', 'Wed', 'Thu'].obs;
  final List<String> allDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Actions / State Mutations
  void changePen(String penName) {
    selectedPen.value = penName;
  }

  void changeFeedType(String feedType) {
    selectedFeedType.value = feedType;
  }

  void toggleSchedule(bool value) {
    isScheduleActive.value = value;
  }

  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  // Example placeholder for saving/sending data to Laravel API later
  void saveSchedule() {
    final payload = {
      'pen': selectedPen.value,
      'feed_type': selectedFeedType.value,
      'is_active': isScheduleActive.value,
      'days': selectedDays.toList(),
    };
    print("Sending configuration to Laravel: $payload");
  }

  final RxList<String> modalSelectedDays = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].obs;
  final Rx<DateTime> startDate = DateTime(2025, 5, 24).obs;
  final RxDouble quantityKg = 5.0.obs; // Default starting weight

  // Presets Toggles State (3 sample preset switches from your UI mockup)
  final RxList<bool> presets = <bool>[true, true, true].obs;

  // Setters
  void toggleModalDay(String day) {
    if (modalSelectedDays.contains(day)) {
      modalSelectedDays.remove(day);
    } else {
      modalSelectedDays.add(day);
    }
  }

  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  void incrementQuantity() {
    quantityKg.value = double.parse((quantityKg.value + 0.5).toStringAsFixed(1));
  }

  void decrementQuantity() {
    if (quantityKg.value > 0.5) {
      quantityKg.value = double.parse((quantityKg.value - 0.5).toStringAsFixed(1));
    }
  }

  void togglePreset(int index, bool value) {
    presets[index] = value;
  }
  
  // Simulated submission handler
  void saveNewSchedule() {
    print("Saving Schedule: Date -> ${startDate.value}, Quantity -> ${quantityKg.value}kg");
    Get.back(); // Closes sheet safely
  }

  final RxList<String> addedTimeSlots = <String>[].obs;

  void addTimeSlot(String hour, String minute, String period) {
    // Sanitize single digit hours/minutes
    String formattedHour = hour.padLeft(2, '0');
    String formattedMinute = minute.isEmpty ? '00' : minute.padLeft(2, '0');
    
    String finalTime = "$formattedHour:$formattedMinute $period";
    addedTimeSlots.add(finalTime);
  }

  void removeTimeSlot(int index) {
    addedTimeSlots.removeAt(index);
  }
}