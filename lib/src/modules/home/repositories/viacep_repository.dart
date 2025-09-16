import 'package:dio/dio.dart';
import 'package:fast_location/src/http/dio_client.dart';
import '../model/address_model.dart';

class ViacepRepository {
  final Dio _dio = DioClient.dio;
  Future<AddressModel> fetchByCep(String cep) async {
    final sanitized = cep.replaceAll(RegExp(r'[^0-9]'), '');
    final response = await _dio.get('$sanitized/json/');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('erro')) {
        throw Exception('CEP não encontrado');
      }
      return AddressModel.fromJson(Map<String, dynamic>.from(data));
    }
    throw Exception('Falha ao consultar CEP');
  }

  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final path =
        '${uf.trim()}/${Uri.encodeComponent(city.trim())}/${Uri.encodeComponent(street.trim())}/json/';
    final response = await _dio.get(path);
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        return [];
      }
    }
    throw Exception('Falha na busca por endereço');
  }
}
