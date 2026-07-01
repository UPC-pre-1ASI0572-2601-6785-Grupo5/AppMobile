import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ResourceTrackingDetailScreen extends StatelessWidget {
  // Corregido el warning del 'key' usando super.key (Flutter 3.0+)
  const ResourceTrackingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'FuelTrack',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textDark),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // CORREGIDO: Se quitÃ³ el 'const' que envolvÃ­a al NetworkImage
          const CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // ==========================================
            // HEADER: ALERTA ROJA
            // ==========================================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('ALERTA: CaÃ­da de\nPresiÃ³n Detectada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFC0392B), height: 1.2)),
                                  SizedBox(height: 6),
                                  Text('ESTADO: CRÃTICO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error, letterSpacing: 0.5)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // ACTIVO SELECCIONADO
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('ACTIVO SELECCIONADO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.5)),
                      SizedBox(height: 4),
                      Text('Tanque TK-402', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFD4EFDF), borderRadius: BorderRadius.circular(20)),
                    child: const Text('ID: FT-9921', style: TextStyle(color: Color(0xFF006D3E), fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // GRÃFICA DE CAÃDA DE PRESIÃ“N
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('PresiÃ³n (PSI) - Ãšltimos 15 min', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          const Text('Live', style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ãrea de la grÃ¡fica dibujada con CustomPaint
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // Fondo del grÃ¡fico
                        Positioned.fill(
                          child: CustomPaint(painter: _PressureDropChartPainter()),
                        ),
                        // Textos Y-Axis
                        const Positioned(top: 8, left: 8, child: Text('120 PSI', style: TextStyle(fontSize: 10, color: AppColors.textGrey))),
                        const Positioned(bottom: 8, left: 8, child: Text('12 PSI', style: TextStyle(fontSize: 10, color: AppColors.textGrey))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // MAPA CON UBICACIÃ“N EXACTA
            // ==========================================
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  // Imagen de refinerÃ­a/planta industrial
                  image: AssetImage('assets/images/trailer.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Marcador Rojo en el centro
                  const Icon(Icons.location_on, color: AppColors.error, size: 40),
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(100)),
                  ),

                  // PÃ­ldora inferior de coordenadas
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.location_on_outlined, color: Color(0xFF006D3E), size: 14),
                          SizedBox(width: 6),
                          Text('KM 142 - Autopista Norte', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // LECTURAS DE SENSORES RAW
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lecturas de Sensores Raw', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  _buildSensorRow('CaudalÃ­metro (F-1)', '0.00 L/m', isAlert: false),
                  _buildSensorRow('Temperatura (T-2)', '24.5 Â°C', isAlert: false),
                  _buildSensorRow('VÃ¡lvula Principal', 'ABIERTA', isAlert: true),
                  _buildSensorRow('Densidad', '0.845 kg/L', isAlert: false, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // BOTONES DE EMERGENCIA
            // ==========================================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock, color: Colors.white, size: 18),
                label: const Text('Cerrar VÃ¡lvulas de Emergencia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone_in_talk, color: Color(0xFF006D3E), size: 18),
                label: const Text('Contactar Operador', style: TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4EFDF), // Verde claro
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // WIDGET REUTILIZABLE: Fila de sensor
  Widget _buildSensorRow(String name, String value, {required bool isAlert, bool isLast = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isAlert ? FontWeight.bold : FontWeight.w500,
                color: isAlert ? AppColors.error : AppColors.textDark,
              ),
            ),
          ],
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.borderLight, height: 1),
          ),
      ],
    );
  }
}

// ===============================================
// DIBUJO DE LA GRÃFICA ROJA (CustomPaint)
// ===============================================
class _PressureDropChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. DIBUJAR LA LÃNEA ROJA
    final paintLine = Paint()
      ..color = AppColors.error
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Coordenadas simulando la caÃ­da de presiÃ³n del diseÃ±o
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width * 0.15, size.height * 0.32);
    path.lineTo(size.width * 0.3, size.height * 0.31);
    path.lineTo(size.width * 0.45, size.height * 0.35);
    path.lineTo(size.width * 0.55, size.height * 0.34); // Punto antes de la caÃ­da

    // CAÃDA DRÃSTICA
    path.lineTo(size.width * 0.65, size.height * 0.75);

    // EstabilizaciÃ³n en la parte baja
    path.lineTo(size.width * 0.8, size.height * 0.85);
    path.lineTo(size.width * 0.95, size.height * 0.88);
    path.lineTo(size.width, size.height * 0.87);

    // 2. DIBUJAR EL DEGRADADO ROJO DEBAJO DE LA LÃNEA
    final paintFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.error.withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final pathFill = Path.from(path);
    pathFill.lineTo(size.width, size.height);
    pathFill.lineTo(0, size.height);
    pathFill.close();

    canvas.drawPath(pathFill, paintFill); // Dibuja el fondo difuminado
    canvas.drawPath(path, paintLine);     // Dibuja la lÃ­nea dura

    // 3. DIBUJAR UN PUNTO EN LA CAÃDA (Opcional, le da buen toque)
    final dotPaint = Paint()..color = AppColors.error;
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.75), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
