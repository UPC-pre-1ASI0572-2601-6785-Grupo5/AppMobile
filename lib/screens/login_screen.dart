import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../services/auth_service.dart';
import 'forgot_password_screen.dart';
import 'mfa_verification_screen.dart'; // IMPORTACIÓN AÑADIDA

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _keepLoggedIn = false;
  bool _isLoading = false;

  late TapGestureRecognizer _registerRecognizer;
  late TapGestureRecognizer _forgotPasswordRecognizer;

  @override
  void initState() {
    super.initState();
    _registerRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context); // Asumiendo que vienes de la pantalla de registro
      };
    _forgotPasswordRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
        );
      };
  }

  @override
  void dispose() {
    _registerRecognizer.dispose();
    _forgotPasswordRecognizer.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // FUNCIÓN MODIFICADA PARA NAVEGAR A MFA
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulación de validación de credenciales con el backend
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Obtenemos el email ingresado para mostrarlo en la pantalla MFA (Opcional pero recomendado por tu diseño)
      final String userEmail = _emailController.text.trim();

      // Navegación directa a la pantalla de Verificación MFA
      Navigator.push(
        context,
        MaterialPageRoute(
          // Si tu MfaVerificationScreen acepta un email por parámetro, puedes pasarlo así:
          // builder: (context) => MfaVerificationScreen(email: userEmail),
          builder: (context) => const MfaVerificationScreen(),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDemoLogin() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.demoLogin();
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Accediendo a Demo como ${user.companyName}'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F4), // Fondo ligeramente tintado según diseño
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.lock_outline, color: AppColors.primary, size: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bienvenido de nuevo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingrese sus credenciales para acceder al panel',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 32),
                  const Text('Correo electrónico', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'nombre@empresa.com',
                      prefixIcon: Icon(Icons.mail_outline, color: AppColors.textGrey, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Contraseña', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      RichText(
                        text: TextSpan(
                          text: '¿Olvidaste tu contraseña?',
                          style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                          recognizer: _forgotPasswordRecognizer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.key_outlined, color: AppColors.textGrey, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: AppColors.textGrey, size: 20),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _keepLoggedIn,
                          onChanged: (value) => setState(() => _keepLoggedIn = value ?? false),
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Mantener sesión iniciada', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006D3E), // Tono verde oscuro del diseño
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Entrar al sistema', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _isLoading ? null : _handleDemoLogin,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF006D3E), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.auto_awesome, color: Color(0xFF006D3E), size: 18),
                        SizedBox(width: 8),
                        Text('Acceder con Demo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006D3E))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.borderLight)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Seguridad Certificada', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                      ),
                      Expanded(child: Divider(color: AppColors.borderLight)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.verified_user_outlined, color: AppColors.textLight, size: 24),
                      SizedBox(width: 16),
                      Icon(Icons.lock_person_outlined, color: AppColors.textLight, size: 24),
                      SizedBox(width: 16),
                      Icon(Icons.military_tech_outlined, color: AppColors.textLight, size: 24),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: '¿No tiene una cuenta? ',
                        style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                        children: [
                          TextSpan(
                            text: 'Registrarse en FuelTrack',
                            style: const TextStyle(color: Color(0xFF006D3E), fontWeight: FontWeight.bold),
                            recognizer: _registerRecognizer,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}