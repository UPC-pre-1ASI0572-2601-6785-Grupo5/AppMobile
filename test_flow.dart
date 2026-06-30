import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  print('--- Iniciando Test E2E desde Dart ---');
  
  final baseUrl = 'https://fueltrack-backend-api.onrender.com/api/v1';
  
  // 1. Iniciar sesión como Test Mobile
  print('1. Intentando iniciar sesión...');
  final loginResponse = await http.post(
    Uri.parse('$baseUrl/authentication/sign-in'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': 'testmobile@fueltrack.com',
      'password': 'TestMobile123!'
    }),
  );

  if (loginResponse.statusCode != 200) {
    print('❌ Error en login: ${loginResponse.statusCode} - ${loginResponse.body}');
    return;
  }
  
  final loginData = jsonDecode(loginResponse.body);
  final token = loginData['token'];
  final userId = loginData['id'];
  print('✅ Login exitoso. User ID: $userId');

  // 2. Crear un nuevo pedido
  print('\n2. Creando un nuevo pedido...');
  final orderResponse = await http.post(
    Uri.parse('$baseUrl/orders'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'requesterId': userId,
      'providerId': 1, // Asumimos que el proveedor 1 es FuelTrack Provider (el default)
      'fuelType': 'Diesel B5 S-50',
      'volume': 1500,
      'deliveryAddress': 'Planta Industrial Norte - Sector B (Test Dart)',
      'scheduledDate': '2026-07-01'
    }),
  );

  if (orderResponse.statusCode != 201 && orderResponse.statusCode != 200) {
    print('❌ Error creando pedido: ${orderResponse.statusCode} - ${orderResponse.body}');
    return;
  }

  final orderData = jsonDecode(orderResponse.body);
  final orderId = orderData['id'];
  print('✅ Pedido creado exitosamente! Order ID: $orderId');

  // 3. Obtener los pedidos para verificar
  print('\n3. Verificando pedido en la lista del usuario...');
  final listResponse = await http.get(
    Uri.parse('$baseUrl/orders/requester/$userId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (listResponse.statusCode != 200) {
    print('❌ Error obteniendo pedidos: ${listResponse.statusCode} - ${listResponse.body}');
    return;
  }

  final listData = jsonDecode(listResponse.body) as List;
  final found = listData.any((order) => order['id'] == orderId);
  
  if (found) {
    print('✅ El pedido $orderId se encuentra en el listado del backend.');
  } else {
    print('❌ El pedido no apareció en el listado.');
  }
  
  print('\n--- Prueba finalizada con éxito ---');
}
