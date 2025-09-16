import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
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
    final locations = await locationFromAddress(query);
    if (locations.isEmpty)
      throw Exception('Não foi possível obter coordenadas');
    final loc = locations.first;
    final availableMaps = await MapLauncher.installedMaps;
    if (availableMaps.isEmpty) throw Exception('Nenhum app de mapa disponível');
    await availableMaps.first.showMarker(
      coords: Coords(loc.latitude, loc.longitude),
      title: address.logradouro.isNotEmpty ? address.logradouro : 'Destino',
      description: address.toString(),
    );
  }
}
