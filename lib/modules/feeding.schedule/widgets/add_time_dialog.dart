import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTimeDialog extends StatefulWidget {
  final Function(String hour, String minute, String period) onTimeSaved;

  const AddTimeDialog({super.key, required this.onTimeSaved});

  static void show(BuildContext context, Function(String hour, String minute, String period) onTimeSaved) {
    showDialog(
      context: context,
      builder: (_) => AddTimeDialog(onTimeSaved: onTimeSaved),
    );
  }

  @override
  State<AddTimeDialog> createState() => _AddTimeDialogState();
}

class _AddTimeDialogState extends State<AddTimeDialog> {
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  String _selectedPeriod = 'AM'; // Default period state

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ENTER TIME',
              style: TextStyle(
                color: Color(0xFF9474FF), // Styled accent color from your prompt image
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HOUR INPUT BLOCK
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimeTextField(
                        controller: _hourController,
                        hint: '',
                        maxVal: 12,
                      ),
                      const SizedBox(height: 6),
                      const Text('Hour', style: TextStyle(color: Colors.black38, fontSize: 13)),
                    ],
                  ),
                ),
                
                // COLON SEPARATOR
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text(
                    ':',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF6200EE)),
                  ),
                ),
                
                // MINUTE INPUT BLOCK
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimeTextField(
                        controller: _minuteController,
                        hint: '00',
                        maxVal: 59,
                      ),
                      const SizedBox(height: 6),
                      const Text('Minute', style: TextStyle(color: Colors.black38, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                
                // PERIOD TOGGLE BLOCK (AM/PM)
                Container(
                  height: 72,
                  width: 64,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0D7FF)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildPeriodSelectorItem('AM'),
                      Container(height: 1, color: const Color(0xFFE0D7FF)),
                      _buildPeriodSelectorItem('PM'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_hourController.text.isNotEmpty) {
                      widget.onTimeSaved(_hourController.text, _minuteController.text, _selectedPeriod);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13B14F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Text Form Construction Helper
  Widget _buildTimeTextField({required TextEditingController controller, required String hint, required int maxVal}) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6200EE), width: 1.5),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 2,
          maxLines: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (val) {
            final intValue = int.tryParse(val) ?? 0;
            if (intValue > maxVal) {
              controller.text = maxVal.toString();
              controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
            }
          },
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: Color(0xFF21005D)),
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  // AM/PM Toggle Segment construction helper
  Widget _buildPeriodSelectorItem(String targetPeriod) {
    final bool isCurrent = _selectedPeriod == targetPeriod;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = targetPeriod),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isCurrent ? const Color(0xFFE8E0FF) : Colors.transparent,
            borderRadius: targetPeriod == 'AM' 
                ? const BorderRadius.vertical(top: Radius.circular(11))
                : const BorderRadius.vertical(bottom: Radius.circular(11)),
          ),
          alignment: Alignment.center,
          child: Text(
            targetPeriod,
            style: TextStyle(
              fontSize: 15, 
              fontWeight: FontWeight.bold, 
              color: isCurrent ? const Color(0xFF6200EE) : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}