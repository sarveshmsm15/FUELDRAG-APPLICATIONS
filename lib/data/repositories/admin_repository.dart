import '../../services/api/dio_client.dart';

class AdminRepository {
  final _dio = DioClient.instance;

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get('/admin/dashboard');
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getOrders({int page = 1, int pageSize = 20, String? status}) async {
    final response = await _dio.get('/admin/orders', queryParameters: {
      'page': page, 'pageSize': pageSize, if (status != null) 'status': status,
    });
    return ((response.data as Map<String, dynamic>)['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> assignDriver(String orderId, String driverId) async {
    final response = await _dio.patch('/admin/orders/$orderId/assign', data: {'driverId': driverId});
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getDailyRevenue() async {
    final response = await _dio.get('/admin/analytics/revenue');
    return ((response.data as Map<String, dynamic>)['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getOrdersByStatus() async {
    final response = await _dio.get('/admin/analytics/orders-by-status');
    return ((response.data as Map<String, dynamic>)['data'] as List).cast<Map<String, dynamic>>();
  }
}