import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Open date/time picker
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFBF00),
        foregroundColor: const Color(0xFF402D00),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: const Color(0xFFFFBF00).withValues(alpha: 0.25),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 20),
          SizedBox(width: 12),
          Text(
            'SLOT DATE AND TIME',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: 14,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
