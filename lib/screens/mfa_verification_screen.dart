import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../services/session_manager.dart';
import 'dashboard_screen.dart';
import 'provider_dashboard_screen.dart';

class MfaVerificationScreen extends StatefulWidget {
  final String email;

  const MfaVerificationScreen({
    Key? key,
    this.email = 'ad***@fueltrack.com',
  }) : super(key: key);

  @override
  State<MfaVerificationScreen> createState() => _MfaVerificationScreenState();
}

class _MfaVerificationScreenState extends State<MfaVerificationScreen> {
  String _code = '';
  bool _isLoading = false;
  bool _hasError = false;
  int _attemptsLeft = 5;

  void _onKeyPress(String value) {
    setState(() {
      if (_hasError) _hasError = false; // Limpia el error al escribir de nuevo
      if (_code.length < 6) {
        _code += value;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_hasError) _hasError = false;
      if (_code.isNotEmpty) {
        _code = _code.substring(0, _code.length - 1);
      }
    });
  }

  void _onClearAll() {
    setState(() {
      _hasError = false;
      _code = '';
    });
  }

  Future<void> _handleVerify() async {
    if (_code.length < 6) return;

    setState(() => _isLoading = true);

    // Simulación de validación
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Simulamos que el código correcto es 123456
    if (_code == '123456') {
      final user = SessionManager.instance.user;
      final isProvider = user != null && user.isProvider;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isProvider ? const ProviderDashboardScreen() : const DashboardScreen(),
        ),
      );
    } else {
      setState(() {
        _hasError = true;
        if (_attemptsLeft > 0) _attemptsLeft--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F4),
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
              AppStrings.appName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _hasError ? AppColors.error.withOpacity(0.15) : AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _hasError ? Icons.error_outline : Icons.security,
                        color: _hasError ? AppColors.error : AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _hasError ? 'Verificación Fallida' : 'Código de Verificación',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _hasError
                      ? 'El código de seguridad que ingresaste es incorrecto o ha caducado. Por favor, inténtalo de nuevo.'
                      : 'Ingresa el código enviado a\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: _hasError ? AppColors.textDark : AppColors.textGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Cajas de entrada OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    bool isFilled = index < _code.length;
                    bool isActive = index == _code.length;

                    Color borderColor;
                    if (_hasError) {
                      borderColor = AppColors.error;
                    } else if (isActive) {
                      borderColor = AppColors.primary;
                    } else if (isFilled) {
                      borderColor = AppColors.borderGrey;
                    } else {
                      borderColor = AppColors.borderLight;
                    }

                    return Container(
                      width: 42,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isFilled ? Colors.white : const Color(0xFFF8FAFA),
                        border: Border.all(
                          color: borderColor,
                          width: isActive || _hasError ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          isFilled ? _code[index] : '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _hasError ? AppColors.error : AppColors.textDark,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // Teclado numérico o acciones de error
                if (!_hasError) ...[
                  _buildKeypad(),
                  const SizedBox(height: 32),
                ],

                ElevatedButton(
                  onPressed: _isLoading || _code.length < 6 ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                      : const Text(
                    'Verificar Código',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),

                if (_hasError) ...[
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _code = '';
                        _hasError = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderGrey, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.refresh, color: AppColors.textDark, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Reenviar Código',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.borderLight)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('O USA UNA FORMA DE SEGURIDAD', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(child: Divider(color: AppColors.borderLight)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecoveryOption(
                    icon: Icons.key_outlined,
                    title: 'Código de recuperación',
                    subtitle: 'Usa tu código de emergencia de 8 dígitos.',
                  ),
                  const SizedBox(height: 12),
                  _buildRecoveryOption(
                    icon: Icons.support_agent_outlined,
                    title: 'Contactar al administrador',
                    subtitle: 'Solicita un restablecimiento de identidad manual.',
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Intentos restantes: $_attemptsLeft de 5',
                      style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w500),
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No recibiste el código? ',
                        style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reenviando código...')),
                          );
                        },
                        child: const Text(
                          'Reenviar',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textDark),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.login_outlined, size: 16, color: AppColors.textGrey),
                        SizedBox(width: 8),
                        Text(
                          'Regresar al login',
                          style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryOption({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton('1'),
            _buildKeypadButton('2'),
            _buildKeypadButton('3'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton('4'),
            _buildKeypadButton('5'),
            _buildKeypadButton('6'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton('7'),
            _buildKeypadButton('8'),
            _buildKeypadButton('9'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildKeypadButton('X', isAction: true, onTap: _onClearAll),
            _buildKeypadButton('0'),
            _buildKeypadButton('backspace', isAction: true, onTap: _onBackspace),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String label, {bool isAction = false, VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          onTap: onTap ?? () => _onKeyPress(label),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: label == 'backspace'
                  ? const Icon(Icons.backspace_outlined, color: AppColors.textDark, size: 20)
                  : Text(
                label,
                style: TextStyle(
                  fontSize: isAction ? 18 : 20,
                  fontWeight: isAction ? FontWeight.w500 : FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}