import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'alerts_screen.dart'; // <-- Importación agregada para que funcionen las alertas
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  bool _hasData = true;

  @override
  void initState() {
    super.initState();
    _fetchAnalyticsData();
  }

  Future<void> _fetchAnalyticsData() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _orderService.getOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          // ¡AQUÍ ESTÁ EL OJITO! Botón para alternar entre vistas
          IconButton(
            icon: Icon(_hasData ? Icons.visibility : Icons.visibility_off, color: AppColors.primary),
            tooltip: 'Alternar Vista de Datos',
            onPressed: () {
              setState(() {
                _hasData = !_hasData;
              });
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textDark),
                onPressed: () {
                  // MODIFICADO: Ahora sí abre las notificaciones al presionarlo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlertsScreen()),
                  );
                },
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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary)) 
          : (_hasData ? _buildPopulatedState() : _buildEmptyState()),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Color(0xFFE8F8F5), shape: BoxShape.circle),
              child: const Icon(Icons.analytics_outlined, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('Sincronización de Sensores de Flota Pendiente', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 12),
            const Text('Conecta los sensores telemáticos de tus unidades para recibir análisis predictivos y reportes de rendimiento en tiempo real.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.4)),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_link, color: Colors.white), label: const Text('Configurar Sensores IoT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulatedState() {
    double totalLitros = _orders.where((o) => o.status == 'COMPLETED').fold(0.0, (sum, o) => sum + o.quantityGallons);
    int activeOrders = _orders.where((o) => o.status != 'COMPLETED' && o.status != 'CANCELLED').length;
    int completedOrders = _orders.where((o) => o.status == 'COMPLETED').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _generateAndPrintPDF,
                icon: const Icon(Icons.download_outlined, size: 16, color: Colors.white),
                label: const Text('Exportar Reporte', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006D3E), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: const [Text('Panel Principal', style: TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w600)), Icon(Icons.chevron_right, size: 16, color: AppColors.textGrey), Text('Analítica', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 20),
          _buildStatCard('Consumo Total', Icons.local_fire_department_outlined, '${totalLitros.toStringAsFixed(1)} Galones', 'Histórico acumulado de pedidos'),
          const SizedBox(height: 12),
          _buildStatCard('Pedidos Activos', Icons.autorenew, '$activeOrders', 'Pedidos en ruta o pendientes'),
          const SizedBox(height: 12),
          _buildStatCard('Pedidos Completados', Icons.check_circle_outline, '$completedOrders', 'Pedidos entregados con éxito'),
          const SizedBox(height: 24),
          const Text('Optimización de Operaciones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          _buildOptimizationTile(Icons.local_shipping_outlined, 'Ruta de Mayor Rendimiento', 'Corredor Norte (L2)'),
          const SizedBox(height: 12),
          _buildOptimizationTile(Icons.access_time, 'Ventana Óptima de Suministro', '22:00 - 04:00 AM'),
          const SizedBox(height: 12),
          _buildOptimizationTile(Icons.speed, 'Eficiencia de Combustible (Flota)', '24.5 L / 100 km'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, IconData icon, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)), Icon(icon, size: 16, color: AppColors.textGrey)]),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildOptimizationTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFF4F7F7), shape: BoxShape.circle), child: Icon(icon, size: 16, color: AppColors.textGrey)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold))])),
        ],
      ),
    );
  }

  Widget _buildSensorStatus({required String title, required String subtitle, required IconData icon, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isActive ? const Color(0xFFE8F8F5) : const Color(0xFFF4F7F7), borderRadius: BorderRadius.circular(12), border: Border.all(color: isActive ? const Color(0xFFB2EBF2) : AppColors.borderLight)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isActive ? const Color(0xFFD4EFDF) : const Color(0xFFEAECEE), shape: BoxShape.circle), child: Icon(icon, size: 16, color: isActive ? AppColors.primary : AppColors.textGrey)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)), const SizedBox(height: 2), Text(subtitle, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? AppColors.primary : AppColors.textGrey))])),
          if (isActive) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
        ],
      ),
    );
  }

  Future<void> _generateAndPrintPDF() async {
    final pdf = pw.Document();
    
    double totalLitros = _orders.where((o) => o.status == 'COMPLETED').fold(0.0, (sum, o) => sum + o.quantityGallons);
    int activeOrders = _orders.where((o) => o.status != 'COMPLETED' && o.status != 'CANCELLED').length;
    int completedOrders = _orders.where((o) => o.status == 'COMPLETED').length;
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('FuelTrack', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
                  pw.Text('Reporte Analítico', style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
                ],
              )
            ),
            pw.SizedBox(height: 20),
            pw.Text('Resumen Operativo', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Consumo Total: ${totalLitros.toStringAsFixed(1)} Galones'),
                  pw.Text('Pedidos Activos: $activeOrders'),
                  pw.Text('Pedidos Completados (Entregados): $completedOrders'),
                ]
              )
            ),
            pw.SizedBox(height: 20),
            pw.Text('Desglose de Pedidos', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['ID', 'Fecha', 'Producto', 'Volumen', 'Estado', 'ETA/Entrega'],
              data: _orders.map((o) => [
                'FT-${o.id}',
                DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(o.createdAt).toLocal()),
                o.productName,
                '${o.quantityGallons} Gal',
                o.status,
                o.etaMinutes != null ? '${o.etaMinutes} min' : '-',
              ]).toList(),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Optimización de Operaciones', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: PdfColors.grey300)
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('• Ruta de Mayor Rendimiento: Corredor Norte (L2)', style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 4),
                  pw.Text('• Ventana Óptima de Suministro: 22:00 - 04:00 AM', style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 4),
                  pw.Text('• Eficiencia de Combustible (Flota): 24.5 L / 100 km', style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 4),
                  pw.Text('• Alertas Críticas Recientes: 0', style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 4),
                  pw.Text('• Índice de Burn Rate Actual: ${(totalLitros / 15000.0 * 100).clamp(0, 100).toStringAsFixed(1)}%', style: pw.TextStyle(fontSize: 12)),
                ]
              )
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text('Reporte generado el ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
            ),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Reporte_Analitico_FuelTrack.pdf',
    );
  }
}
