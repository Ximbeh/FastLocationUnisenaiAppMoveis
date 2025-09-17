// lib/src/modules/home/repositories/viacep_repository.dart
import 'package:dio/dio.dart';
import 'package:fast_location/src/http/dio_client.dart';
import '../model/address_model.dart';
import 'dart:async'; // Import para Completer

class ViacepRepository {
  final Dio _dio;

  // Usar uma instância por repositório em vez de estática
  ViacepRepository() : _dio = DioClient.dio;

  // Controlar requests pendentes para evitar duplicação
  final Map<String, Completer<AddressModel>> _pendingCepRequests = {};
  final Map<String, Completer<List<AddressModel>>> _pendingSearchRequests = {};

  Future<AddressModel> fetchByCep(String cep) async {
    final sanitized = cep.replaceAll(RegExp(r'[^0-9]'), '');
    final cacheKey = 'cep_$sanitized';

    // Verificar se já existe uma request pendente
    if (_pendingCepRequests.containsKey(cacheKey)) {
      return _pendingCepRequests[cacheKey]!.future;
    }

    final completer = Completer<AddressModel>();
    _pendingCepRequests[cacheKey] = completer;

    try {
      final response = await _dio.get('$sanitized/json/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('erro')) {
          throw Exception('CEP não encontrado');
        }
        
        final address = AddressModel.fromJson(Map<String, dynamic>.from(data));
        completer.complete(address);
        _pendingCepRequests.remove(cacheKey);
        return address;
      }
      
      throw Exception('Falha ao consultar CEP');
    } catch (e) {
      completer.completeError(e);
      _pendingCepRequests.remove(cacheKey);
      rethrow;
    }
  }

  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final cacheKey = 'search_${uf}_${city}_${street}';

    // Verificar se já existe uma request pendente
    if (_pendingSearchRequests.containsKey(cacheKey)) {
      return _pendingSearchRequests[cacheKey]!.future;
    }

    final completer = Completer<List<AddressModel>>();
    _pendingSearchRequests[cacheKey] = completer;

    try {
      final path = '${uf.trim()}/${Uri.encodeComponent(city.trim())}/${Uri.encodeComponent(street.trim())}/json/';
      final response = await _dio.get(path);
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<AddressModel> results = [];
        
        if (data is List) {
          results = data
              .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
        
        completer.complete(results);
        _pendingSearchRequests.remove(cacheKey);
        return results;
      }
      
      throw Exception('Falha na busca por endereço');
    } catch (e) {
      completer.completeError(e);
      _pendingSearchRequests.remove(cacheKey);
      rethrow;
    }
  }

  // Limpar cache se necessário
  void clearCache() {
    _pendingCepRequests.clear();
    _pendingSearchRequests.clear();
  }
}