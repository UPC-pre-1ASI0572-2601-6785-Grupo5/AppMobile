import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/fleet_service.dart';

class TankFormScreen extends StatefulWidget {
  final TankModel? tank;

  const TankFormScreen({Key? key, this.tank}) : super(key: key);

  @override
  _TankFormScreenState createState() => _TankFormScreenState();
}

class _TankFormScreenState extends State<TankFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fleetService = FleetService();

  late TextEditingController _plateController;
  late TextEditingController _modelController;
  late TextEditingController _capacityController;
  late TextEditingController _fuelController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.tank?.plate ?? '');
    _modelController = TextEditingController(text: widget.tank?.model ?? '');
    _capacityController = TextEditingController(text: widget.tank?.capacityGallons.toString() ?? '');
    _fuelController = TextEditingController(text: widget.tank?.currentFuelGallons.toString() ?? '');
  }

  @override
  void dispose() {
    _plateController.dispose();
    _modelController.dispose();
    _capacityController.dispose();
    _fuelController.dispose();
    super.dispose();
  }

  Future<void> _saveTank() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newTank = TankModel(
        id: widget.tank?.id,
        providerId: widget.tank?.providerId,
        plate: _plateController.text.trim(),
        model: _modelController.text.trim(),
        capacityGallons: double.tryParse(_capacityController.text.trim()) ?? 0,
        currentFuelGallons: double.tryParse(_fuelController.text.trim()) ?? 0,
        status: widget.tank?.status ?? 'AVAILABLE',
        smartLockStatus: widget.tank?.smartLockStatus ?? 'LOCKED',
        valveStatus: widget.tank?.valveStatus ?? 'CLOSED',
        tirePressurePsi: widget.tank?.tirePressurePsi ?? 32.0,
        speedKmh: widget.tank?.speedKmh ?? 0.0,
      );

      if (widget.tank == null) {
        await _fleetService.addTank(newTank);
      } else {
        await _fleetService.updateTank(newTank);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tank != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Cisterna' : 'Nueva Cisterna', style: const TextStyle(color: AppColors.textDark, fontSize: 16)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        elevation: 0,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Eliminar'),
                    content: const Text('¿Seguro que deseas eliminar esta cisterna?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar', style: TextStyle(color: AppColors.error))),
                    ],
                  ),
                );
                if (confirm == true) {
                  setState(() => _isLoading = true);
                  await _fleetService.deleteTank(widget.tank!.id!);
                  Navigator.pop(context, true);
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Placa', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _plateController,
                      decoration: InputDecoration(
                        hintText: 'Ej. MX-4501',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Modelo', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        hintText: 'Ej. KENWORTH T680',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Capacidad (Gal)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _capacityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nivel Actual (Gal)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _fuelController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveTank,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Guardar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
