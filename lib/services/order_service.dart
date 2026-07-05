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

  Future<OrderModel> getOrder(int id) async {
    final response = await _api.get('${ApiConfig.orders}/$id');
    return OrderModel.fromJson(response);
  }

  Future<OrderModel> createOrder({
    required String productName,
    required String name,
    required double quantityGallons,
    required String documentRef,
    required int etaMinutes,
  }) async {
    final body = {
      'fuelType': productName,
      'name': name,
      'gallons': quantityGallons,
      'documentRef': documentRef,
      'etaMinutes': etaMinutes,
    };

    final response = await _api.post(ApiConfig.orders, body: body);
    return OrderModel.fromJson(response);
  }

  Future<void> cancelOrder(int id) async {
    await _api.delete('${ApiConfig.orders}/$id');
  }

  Future<void> markAsDelivered(int id) async {
    await _api.patch('${ApiConfig.orders}/$id/deliver');
  }

  Future<void> markAsCompleted(int id) async {
    await _api.patch('${ApiConfig.orders}/$id/complete');
  }
}
