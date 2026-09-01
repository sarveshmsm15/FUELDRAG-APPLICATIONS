import '../../services/api/dio_client.dart';

class FuelRepository {
  final _dio = DioClient.instance;

  Future<List<Map<String, dynamic>>> getCurrentRates() async {
    final response = await _dio.get('/fuel-rates/current');
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data.cast<Map<String, dynamic>>();
  }
}