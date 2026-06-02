class Validators {
  static String? validateCompanyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa el nombre de la empresa';
    }
    if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    // El .trim() limpia los espacios invisibles antes de validar
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasNumbers = value.contains(RegExp(r'[0-9]'));

    if (!hasUppercase || !hasLowercase || !hasNumbers) {
      return 'La contraseña debe contener mayúsculas, minúsculas y números';
    }
    return null;
  }

  static String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor selecciona un rol';
    }
    return null;
  }

  static String? validateTerms(bool value) {
    if (!value) {
      return 'Debes aceptar los términos y condiciones';
    }
    return null;
  }

  /// Capacidad disponible en planta (mock IoT).
  static const int plantAvailableCapacityLiters = 7000;

  static int? parseQuantityLiters(String raw) {
    final cleaned = raw.trim().replaceAll(RegExp(r'[.\s]'), '').replaceAll(',', '');
    return int.tryParse(cleaned);
  }

  static String? validateOrderQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa la cantidad en litros';
    }
    final quantity = parseQuantityLiters(value);
    if (quantity == null) {
      return 'Ingresa un valor numérico válido';
    }
    if (quantity <= 0) {
      return 'La cantidad debe ser mayor a 0';
    }
    if (quantity > plantAvailableCapacityLiters) {
      return 'Excede la capacidad disponible en planta';
    }
    return null;
  }
}