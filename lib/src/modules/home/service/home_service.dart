import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/address_model.dart';
import '../repositories/viacep_repository.dart';
import '../repositories/local_repository.dart';

class HomeService {
  final ViacepRepository viacepRepo;
  final LocalRepository localRepo;

  HomeService({required this.viacepRepo, required this.localRepo});

  Future<AddressModel> getByCep(String cep) async {
    final address = await viacepRepo.fetchByCep(cep);
    await localRepo.save(address);
    return address;
  }

  Future<List<AddressModel>> searchAddress({
    required String uf,
    required String city,
    required String street,
  }) {
    return viacepRepo.searchByAddress(uf: uf, city: city, street: street);
  }

  Future<List<AddressModel>> getHistory() => localRepo.getAll();

  Future<AddressModel?> getLast() => localRepo.getLast();

  Future<void> openMapForAddress(AddressModel address) async {
    final query =
        '${address.logradouro}, ${address.localidade}, ${address.uf}, Brasil';
    
    try {
      // Tenta usar apps nativos primeiro
      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.isNotEmpty) {
        final locations = await locationFromAddress(query);
        if (locations.isNotEmpty) {
          final loc = locations.first;
          await availableMaps.first.showMarker(
            coords: Coords(loc.latitude, loc.longitude),
            title: address.logradouro.isNotEmpty ? address.logradouro : 'Destino',
            description: address.toString(),
          );
          return;
        }
      }
    } catch (e) {
      // Se falhar, continua para abrir no navegador
    }
    
    // Se não há apps nativos ou falhou, abre no navegador
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
    final uri = Uri.parse(googleMapsUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Não foi possível abrir o mapa. URL: $googleMapsUrl');
    }
  }
}
