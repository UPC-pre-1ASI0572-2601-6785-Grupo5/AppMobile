import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DigitalSignaturePanel extends StatelessWidget {
  final String securityHash;

  const DigitalSignaturePanel({
    Key? key,
    this.securityHash = '#FT-HASH-992-B821-X9',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.trackingDeliveredBtnBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.draw, size: 18, color: AppColors.trackingDarkGreen),
              ),
              const SizedBox(width: 10),
              const Text(
                'Firma Digital',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.trackingDarkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFD1D5DB),
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: CustomPaint(
                  painter: _SignaturePainter(),
                  size: const Size(double.infinity, 100),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Text(
                    'VERIFICADO',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.trackingAccentGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.trackingDeliveredBtnBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código Hash de Seguridad',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.chipInactiveText.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  securityHash,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.trackingDarkGreen,
                    letterSpacing: 0.2,
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

class _SignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textDark.withValues(alpha: 0.75)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(size.width * 0.08, size.height * 0.62);
    path.quadraticBezierTo(
      size.width * 0.18,
      size.height * 0.28,
      size.width * 0.32,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.42,
      size.height * 0.78,
      size.width * 0.52,
      size.height * 0.42,
    );
    path.quadraticBezierTo(
      size.width * 0.62,
      size.height * 0.18,
      size.width * 0.74,
      size.height * 0.58,
    );
    path.quadraticBezierTo(
      size.width * 0.84,
      size.height * 0.82,
      size.width * 0.92,
      size.height * 0.48,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
