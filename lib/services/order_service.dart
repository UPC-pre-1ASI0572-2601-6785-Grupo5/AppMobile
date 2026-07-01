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
    required double quantityGallons,
    required String documentRef,
  }) async {
    final body = {
      'productName': productName,
      'quantityGallons': quantityGallons,
      'documentRef': documentRef,
    };

    final response = await _api.post(ApiConfig.orders, body: body);
    return OrderModel.fromJson(response);
  }
}
