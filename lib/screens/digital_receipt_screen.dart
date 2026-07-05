import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../constants/colors.dart';
import 'dashboard_screen.dart';
import 'provider_dashboard_screen.dart';
import '../models/order_model.dart';
import '../services/session_manager.dart';

class DigitalReceiptScreen extends StatefulWidget {
  // RECIBE LOS PUNTOS REALES DE LA FIRMA DIBUJADA
  final List<Offset?> signaturePoints;
  final OrderModel? order;

  const DigitalReceiptScreen({
    Key? key,
    required this.signaturePoints,
    this.order,
  }) : super(key: key);

  @override
  State<DigitalReceiptScreen> createState() => _DigitalReceiptScreenState();
}

class _DigitalReceiptScreenState extends State<DigitalReceiptScreen> {
  final int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 32,
                  height: 32,
                  color: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white, size: 20),
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
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Entrega Confirmada', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const SizedBox(height: 2),
                      Text(
                        widget.order != null && widget.order!.completedAt != null
                            ? DateFormat('dd MMM yyyy • HH:mm a').format(DateTime.parse(widget.order!.completedAt!).toLocal())
                            : 'Fecha desconocida',
                        style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: const Icon(Icons.watch_outlined, color: AppColors.textGrey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 20, color: AppColors.textDark),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Voucher Digital', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        Text(widget.order != null ? '#FT-${widget.order!.id}' : '#FT-UNKNOWN', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('Certificado PDF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('VOLUMEN ENTREGADO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(widget.order != null ? widget.order!.quantityGallons.toStringAsFixed(0) : '0', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                const Text(' L', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              ],
                            ),
                            const Icon(Icons.ev_station_outlined, size: 40, color: AppColors.borderLight),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: AppColors.borderLight),
                        const SizedBox(height: 16),

                        _buildDataRow('Producto', widget.order != null ? widget.order!.name : 'Desconocido'),
                        _buildDataRow('Unidad', widget.order != null && widget.order!.assignedTruckId != null ? 'Camión ${widget.order!.assignedTruckId}' : 'No asignada'),
                        _buildDataRow('Operador', 'Chofer Asignado'),
                        _buildDataRow('Ubicación', widget.order != null ? (widget.order!.documentRef.contains(' | ') ? widget.order!.documentRef.split(' | ')[0] : widget.order!.documentRef) : 'Destino'),

                        const SizedBox(height: 24),
                        Center(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F7F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.qr_code, color: AppColors.textGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))],              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.draw_outlined, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Firma Digital', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Caja de la firma mostrando el trazo real pasado
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight, width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        // RENDERIZADO DE LA FIRMA REAL CAPTURADA
                        ClipRect(
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: const EdgeInsets.all(8),
                              child: CustomPaint(
                                painter: VoucherSignatureViewerPainter(widget.signaturePoints),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: const Text('VERIFICADO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Código Hash de Seguridad', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                        const SizedBox(height: 2),
                        Text(widget.order?.securityHash ?? '#FT-HASH-PENDING', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateAndDownloadPdf,
                icon: const Icon(Icons.download_outlined, size: 18, color: Colors.white),
                label: const Text('Descargar PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006D3E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final isProvider = SessionManager.instance.user?.isProvider ?? false;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isProvider ? const ProviderDashboardScreen(initialIndex: 0) : const DashboardScreen(initialIndex: 0)
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_outlined, size: 18, color: AppColors.textDark),
                label: const Text('Volver al Dashboard', style: TextStyle(color: AppColors.textDark)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8F8F5),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FAF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1F2E6)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Respaldo Seguro', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        SizedBox(height: 4),
                        Text(
                          'Este documento tiene validez legal y ha sido encriptado para su seguridad.',
                          style: TextStyle(fontSize: 11, color: AppColors.textGrey, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark))),
        ],
      ),
    );
  }



  Future<void> _generateAndDownloadPdf() async {
    final pdf = pw.Document();

    // Renderizar firma a imagen para el PDF
    final signatureImage = await _captureSignatureAsImage();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('FuelTrack Comprobante de Entrega', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.Text(widget.order != null ? '#FT-${widget.order!.id}' : '', style: pw.TextStyle(fontSize: 16)),
                  ]
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Detalles del Pedido', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildPdfDataRow('Producto', widget.order?.name ?? ''),
              _buildPdfDataRow('Volumen Total', '${widget.order?.quantityGallons.toStringAsFixed(0) ?? '0'} Galones'),
              _buildPdfDataRow('Ubicación de Destino', widget.order?.documentRef ?? ''),
              if (widget.order?.completedAt != null)
                _buildPdfDataRow('Finalización', DateFormat('dd MMM yyyy • HH:mm a').format(DateTime.parse(widget.order!.completedAt!).toLocal())),
              
              pw.SizedBox(height: 30),
              pw.Text('Firma del Cliente', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              if (signatureImage != null)
                pw.Container(
                  height: 100,
                  child: pw.Image(pw.MemoryImage(signatureImage)),
                )
              else
                pw.Container(
                  height: 100,
                  alignment: pw.Alignment.center,
                  child: pw.Text('Firma no disponible'),
                ),
              pw.SizedBox(height: 30),
              pw.Text('Hash de Seguridad:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text(widget.order?.securityHash ?? 'No hash available', style: pw.TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );

    // Muestra diálogo o guarda archivo
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'comprobante_FT-${widget.order?.id ?? '0'}.pdf');
  }

  pw.Widget _buildPdfDataRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ]
      )
    );
  }

  Future<Uint8List?> _captureSignatureAsImage() async {
    if (widget.signaturePoints.isEmpty) return null;
    
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(400, 200); // Aproximado para pdf

    // Fill background
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final painter = VoucherSignatureViewerPainter(widget.signaturePoints);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}

// Pintor gráfico que dibuja los trazos reales de la firma transferida
class VoucherSignatureViewerPainter extends CustomPainter {
  final List<Offset?> points;

  VoucherSignatureViewerPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VoucherSignatureViewerPainter oldDelegate) => true;
}
