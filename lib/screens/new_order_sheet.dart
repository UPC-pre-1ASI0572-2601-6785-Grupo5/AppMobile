import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/validators.dart';
import 'order_confirmation_error_screen.dart';
import 'order_confirmation_success_screen.dart';

void showNewOrderSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const NewOrderSheet(),
  );
}

class NewOrderSheet extends StatefulWidget {
  const NewOrderSheet({Key? key}) : super(key: key);

  @override
  State<NewOrderSheet> createState() => _NewOrderSheetState();
}

class _NewOrderSheetState extends State<NewOrderSheet> {
  final _quantityController = TextEditingController(text: '5000');
  int _selectedFuel = 0;
  bool _isSubmitting = false;
  String? _quantityError;
  bool _quantityTouched = false;

  static const _fuelTypes = [
    _FuelOption(label: 'Diesel', icon: Icons.local_gas_station),
    _FuelOption(label: 'Premium', icon: Icons.ev_station),
    _FuelOption(label: 'Regular', icon: Icons.oil_barrel_outlined),
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _validateQuantity({bool force = false}) {
    if (!_quantityTouched && !force) return;

    final error = Validators.validateOrderQuantity(_quantityController.text);
    if (error != _quantityError) {
      setState(() => _quantityError = error);
    }
  }

  Future<void> _confirmOrder() async {
    setState(() => _quantityTouched = true);
    _validateQuantity(force: true);
    if (_quantityError != null) return;

    final quantity = _quantityController.text.trim();

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final navigator = Navigator.of(context);
    navigator.pop();

    final simulateError = quantity == '0000';

    navigator.push(
      MaterialPageRoute(
        builder: (context) => simulateError
            ? const OrderConfirmationErrorScreen(
                orderCode: '#FT-8892',
                volume: '5,000 L',
                eta: '45 min',
              )
            : OrderConfirmationSuccessScreen(
                orderCode: '#FT-8892',
                volume: '${_formatVolume(quantity)} L',
                eta: '45 min',
              ),
      ),
    );
  }

  String _formatVolume(String raw) {
    final n = Validators.parseQuantityLiters(raw);
    if (n == null) return raw;
    return n.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.chipInactiveText),
                ),
                const Expanded(
                  child: Text(
                    'Nuevo Pedido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.trackingDarkGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIotRecommendation(),
                  const SizedBox(height: 20),
                  _buildQuantityField(),
                  const SizedBox(height: 20),
                  _buildFuelTypeSelector(),
                  const SizedBox(height: 20),
                  _buildAddressField(),
                  const SizedBox(height: 20),
                  _buildDateField(),
                  const SizedBox(height: 20),
                  _buildMapPreview(),
                  const SizedBox(height: 16),
                  _buildEtaRow(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: AppColors.trackingDarkGreen,
                borderRadius: BorderRadius.circular(28),
                child: InkWell(
                  onTap: _isSubmitting ? null : _confirmOrder,
                  borderRadius: BorderRadius.circular(28),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isSubmitting)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          const Text(
                            'Confirmar Pedido',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right, color: Colors.white, size: 22),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIotRecommendation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.trackingDeliveredBtnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.trackingAccentGreen.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.trackingAccentGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.sensors, color: AppColors.trackingDarkGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recomendación IoT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.trackingDarkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: AppColors.trackingDarkGreen, height: 1.4),
                    children: [
                      TextSpan(text: 'Basado en tus niveles actuales, te sugerimos '),
                      TextSpan(
                        text: '5000L',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' (Precisión 95%)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityField() {
    final hasError = _quantityError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cantidad (litros)',
          style: TextStyle(fontSize: 12, color: AppColors.chipInactiveText),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          onChanged: (_) {
            if (!_quantityTouched) {
              setState(() => _quantityTouched = true);
            }
            _validateQuantity(force: true);
          },
          decoration: InputDecoration(
            hintText: 'Ej. 5000',
            hintStyle: const TextStyle(color: AppColors.textLight),
            suffixText: 'Lts',
            suffixStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: hasError ? AppColors.error : AppColors.chipInactiveText,
            ),
            filled: true,
            fillColor: AppColors.surfaceWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: hasError ? AppColors.error : const Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : const Color(0xFFE5E7EB),
                width: hasError ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.trackingDarkGreen,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            error: hasError
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error, size: 16, color: AppColors.error),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _quantityError!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.error,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFuelTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Combustible',
          style: TextStyle(fontSize: 12, color: AppColors.chipInactiveText),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(_fuelTypes.length, (index) {
            final fuel = _fuelTypes[index];
            final isSelected = _selectedFuel == index;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < _fuelTypes.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFuel = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.trackingDarkGreen : const Color(0xFFE5E7EB),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          fuel.icon,
                          size: 22,
                          color: isSelected ? AppColors.trackingDarkGreen : AppColors.chipInactiveText,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fuel.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.trackingDarkGreen : AppColors.chipInactiveText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dirección de Entrega',
          style: TextStyle(fontSize: 12, color: AppColors.chipInactiveText),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.location_on, color: AppColors.trackingDarkGreen, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Planta Industrial Norte - Sector B',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: AppColors.chipInactiveText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha Programada',
          style: TextStyle(fontSize: 12, color: AppColors.chipInactiveText),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: AppColors.trackingDarkGreen, size: 20),
              SizedBox(width: 10),
              Text(
                'mm/dd/yyyy',
                style: TextStyle(fontSize: 14, color: AppColors.textLight),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
              child: Image.network(
                'https://images.unsplash.com/photo-1524661135652-b02096e39826?w=600&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFE5E7EB),
                  child: const Icon(Icons.map, size: 48, color: AppColors.textLight),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppColors.trackingDarkGreen),
                    SizedBox(width: 4),
                    Text(
                      'Ubicación confirmada',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.trackingDarkGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEtaRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tiempo estimado de entrega',
          style: TextStyle(fontSize: 13, color: AppColors.chipInactiveText),
        ),
        Text(
          '24 - 48 Horas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.trackingDarkGreen,
          ),
        ),
      ],
    );
  }
}

class _FuelOption {
  final String label;
  final IconData icon;

  const _FuelOption({required this.label, required this.icon});
}
