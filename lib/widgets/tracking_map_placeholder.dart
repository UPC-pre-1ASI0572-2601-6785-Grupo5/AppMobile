import 'package:flutter/material.dart';
import '../constants/colors.dart';

class TrackingMapPlaceholder extends StatelessWidget {
  const TrackingMapPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.trackingMapDark,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _MapGridPainter()),
          CustomPaint(painter: _RoutePainter()),
          Positioned(
            left: 16,
            top: 16,
            child: Column(
              children: [
                _MapFloatingButton(icon: Icons.my_location),
                const SizedBox(height: 10),
                _MapFloatingButton(icon: Icons.layers_outlined),
              ],
            ),
          ),
          Positioned(
            left: 48,
            bottom: 72,
            child: Icon(Icons.local_shipping, size: 36, color: Colors.white.withValues(alpha: 0.9)),
          ),
          Positioned(
            right: 56,
            top: 48,
            child: Column(
              children: [
                Icon(Icons.location_on, size: 48, color: AppColors.trackingAccentGreen),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.trackingAccentGreen.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.trackingAccentGreen.withValues(alpha: 0.15),
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapFloatingButton extends StatelessWidget {
  final IconData icon;

  const _MapFloatingButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 22, color: AppColors.trackingDarkGreen),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    const step = 32.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.45,
        size.width * 0.55,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.35,
        size.width * 0.82,
        size.height * 0.28,
      );

    final glowPaint = Paint()
      ..color = AppColors.trackingMapRoute.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = AppColors.trackingMapRoute
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
