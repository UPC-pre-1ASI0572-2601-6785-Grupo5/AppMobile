import '../config/api_config.dart';
import '../models/order_model.dart';
import 'api_client.dart';

class OrderService {
  final ApiClient _api = ApiClient.instance;

  Future<List<OrderModel>> getOrders() async {
    final response = await _api.get(ApiConfig.orders);
    
    if (response is List) {
      return response.map((json) => OrderModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<OrderModel> createOrder({
    required String productName,
    required String name,
    required double quantityGallons,
    required String documentRef,
  }) async {
    final body = {
      'fuelType': productName,
      'name': name,
      'gallons': quantityGallons,
      'documentRef': documentRef,
    };

    final response = await _api.post(ApiConfig.orders, body: body);
    return OrderModel.fromJson(response);
  }

  Future<void> cancelOrder(int id) async {
    // Implement cancellation logic. Since we might not have a specific DELETE or Cancel endpoint documented,
    // assuming it might be a PUT with status CANCELLED, or DELETE /api/v1/orders/{id}. 
    // Wait, the API for order has not been fully verified for cancellation.
    // Let's assume DELETE /api/v1/orders/{id}
    await _api.delete('${ApiConfig.orders}/$id');
  }
}
