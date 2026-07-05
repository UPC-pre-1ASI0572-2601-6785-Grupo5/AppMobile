import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

class ProviderOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const ProviderOrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Desconocida';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (e) {
      return isoString;
    }
  }

  String _getStatusTranslation(String status) {
    switch (status) {
      case 'PENDING_APPROVAL':
        return 'Pendiente';
      case 'APPROVED':
        return 'Confirmado';
      case 'DISPATCHED':
      case 'IN_TRANSIT':
        return 'En Ruta';
      case 'DELIVERED':
        return 'Entregado';
      case 'COMPLETED':
        return 'Completado';
      case 'CANCELLED':
        return 'Cancelado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detalles del Pedido', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(
                  '#FT-${order.id}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            _buildSectionTitle('Información General'),
            _buildDetailCard([
              _buildRow('Estado', _getStatusTranslation(order.status)),
              _buildRow('Creado el', _formatDate(order.createdAt)),
              if (order.dispatchedAt != null) _buildRow('Despachado el', _formatDate(order.dispatchedAt)),
              if (order.completedAt != null) _buildRow('Completado el', _formatDate(order.completedAt)),
            ]),

            const SizedBox(height: 24),
            _buildSectionTitle('Detalles de la Carga'),
            _buildDetailCard([
              _buildRow('Combustible', order.productName),
              _buildRow('Volumen', '${order.quantityGallons} Galones'),
              _buildRow('ETA Cliente', '${order.etaMinutes ?? 0} minutos'),
            ]),

            const SizedBox(height: 24),
            _buildSectionTitle('Información de Destino (Cliente)'),
            _buildDetailCard([
              _buildRow('Cliente (Privado)', 'Protegido por Sistema'),
              _buildRow('Documento/RUC', order.documentRef),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGrey),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
