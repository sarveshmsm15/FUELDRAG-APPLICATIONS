import '../../services/api/dio_client.dart';

class WalletRepository {
  final _dio = DioClient.instance;

  Future<Map<String, dynamic>?> getWallet() async {
    final response = await _dio.get('/wallet');
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>> addMoney(double amount) async {
    final response = await _dio.post('/wallet/add-money', data: {'amount': amount});
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> pay({
    required String orderId,
    required String method,
    String? pin,
  }) async {
    final response = await _dio.post('/payments/pay', data: {
      'orderId': orderId,
      'method': method,
      if (pin != null) 'pin': pin,
    });
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
}