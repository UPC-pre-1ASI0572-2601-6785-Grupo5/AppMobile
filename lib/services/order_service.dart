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

  Future<void> dispatchOrder(int id, int driverId, int tankId) async {
    final body = {
      'driverId': driverId,
      'tankId': tankId,
    };
    await _api.patch('${ApiConfig.orders}/$id/dispatch', body: body);
  }

  Future<void> markAsDelivered(int id) async {
    await _api.patch('${ApiConfig.orders}/$id/deliver');
  }

  Future<OrderModel> markAsCompleted(int id) async {
    final response = await _api.patch('${ApiConfig.orders}/$id/complete');
    return OrderModel.fromJson(response);
  }

  Future<OrderModel> approveOrder(int id) async {
    final response = await _api.patch('${ApiConfig.orders}/$id/approve');
    return OrderModel.fromJson(response);
  }

  Future<OrderModel> accelerateOrder(int id) async {
    final response = await _api.patch('${ApiConfig.orders}/$id/accelerate');
    return OrderModel.fromJson(response);
  }

  Future<OrderModel> saveSignature(int id, String signature) async {
    final body = {
      'signature': signature,
    };
    final response = await _api.patch('${ApiConfig.orders}/$id/signature', body: body);
    return OrderModel.fromJson(response);
  }
}
