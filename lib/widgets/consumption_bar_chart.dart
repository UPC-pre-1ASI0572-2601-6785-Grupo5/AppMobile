import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ConsumptionBarChart extends StatelessWidget {
  const ConsumptionBarChart({Key? key}) : super(key: key);

  static const _days = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
  static const _heights = [0.42, 0.52, 0.48, 0.58, 1.0, 0.38, 0.32];
  static const _colors = [
    Color(0xFFBBF7D0),
    Color(0xFF86EFAC),
    Color(0xFF9AE6B4),
    Color(0xFF4ADE80),
    Color(0xFF1DBF73),
    Color(0xFFD1FAE5),
    Color(0xFFE5E7EB),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_days.length, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: _heights[index],
                        widthFactor: 0.55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _colors[index],
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _days[index],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.chipInactiveText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
