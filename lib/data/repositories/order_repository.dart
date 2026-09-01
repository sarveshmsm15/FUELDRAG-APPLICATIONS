import '../../services/api/dio_client.dart';

class OrderRepository {
  final _dio = DioClient.instance;

  Future<Map<String, dynamic>> createOrder({
    required String addressId,
    String? vehicleId,
    required String fuelType,
    required double quantityLiters,
    double distanceKm = 5,
    String? promoCode,
    String? notes,
  }) async {
    final response = await _dio.post('/orders', data: {
      'addressId': addressId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      'fuelType': fuelType,
      'quantityLiters': quantityLiters,
      'distanceKm': distanceKm,
      if (promoCode != null) 'promoCode': promoCode,
      if (notes != null) 'notes': notes,
    });
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getActiveOrder() async {
    final response = await _dio.get('/orders/active');
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
  }

  Future<List<Map<String, dynamic>>> getOrders({int page = 1, int pageSize = 20}) async {
    final response = await _dio.get('/orders', queryParameters: {'page': page, 'pageSize': pageSize});
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> cancelOrder(String orderId, {String? reason}) async {
    final response = await _dio.patch('/orders/$orderId/cancel', data: {'reason': reason});
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> calculatePricing({
    required String fuelType,
    required double quantityLiters,
    double distanceKm = 5,
    String? promoCode,
  }) async {
    final response = await _dio.post('/pricing/calculate', data: {
      'fuelType': fuelType,
      'quantityLiters': quantityLiters,
      'distanceKm': distanceKm,
      if (promoCode != null) 'promoCode': promoCode,
    });
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
}