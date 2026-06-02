import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import 'order_confirmation_screen.dart'; // Importación de la pantalla de confirmación

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  String _selectedFuel = 'Diésel';
  final TextEditingController _dateController = TextEditingController();

  // Función para abrir el calendario y formatear la fecha seleccionada
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // No permite seleccionar fechas pasadas
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Formatea la fecha como dd/mm/yyyy
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nuevo Pedido',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de Recomendación IoT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB2EBF2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.memory, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recomendación IoT', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('Basado en tus niveles actuales, te sugerimos 5000L (Precisión 95%)', style: TextStyle(fontSize: 12, color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Input Cantidad
            const Text('Cantidad (litros)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ej. 5000',
                suffixText: 'Lts',
                suffixStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 24),

            // Tipo de Combustible
            const Text('Tipo de Combustible', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildFuelTypeOption('Diésel', Icons.local_gas_station)),
                const SizedBox(width: 12),
                Expanded(child: _buildFuelTypeOption('Premium', Icons.ev_station)),
                const SizedBox(width: 12),
                Expanded(child: _buildFuelTypeOption('Regular', Icons.water_drop_outlined)),
              ],
            ),
            const SizedBox(height: 24),

            // Dirección de Entrega
            const Text('Dirección de Entrega', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.map_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Planta Industrial Norte - Sector B',
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
                        items: ['Planta Industrial Norte - Sector B', 'Sede Central Sur'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fecha Programada con Interacción
            const Text('Fecha Programada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context), // Al presionar se abre el calendario
              decoration: InputDecoration(
                hintText: 'dd/mm/yyyy',
                prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 16),

            // MAPA REAL INTEGRADO
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(-12.0464, -77.0428), // Coordenadas del diseño
                        initialZoom: 14.0,
                        interactionOptions: InteractionOptions(flags: InteractiveFlag.none), // Se bloquea el arrastre para no estorbar el scroll general
                      ),
                      children: [
                        TileLayer(
                          // Usamos un mapa en tonos claros para este contenedor
                          urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                          userAgentPackageName: 'com.example.fueltrack',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: const LatLng(-12.0464, -77.0428),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: AppColors.primary, size: 36),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text('Ubicación confirmada', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tiempo estimado y Botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Tiempo estimado de entrega', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                Text('24 - 48 Horas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // NAVEGACIÓN A LA PANTALLA DE ÉXITO Y CIERRE DEL MODAL
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Confirmar Pedido >', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget para las tarjetas seleccionables de combustible
  Widget _buildFuelTypeOption(String name, IconData icon) {
    bool isSelected = _selectedFuel == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFuel = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textGrey, size: 28),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}