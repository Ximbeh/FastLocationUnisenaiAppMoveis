import 'package:mobx/mobx.dart';
import '../model/address_model.dart';
import '../repositories/local_repository.dart';
import '../service/home_service.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final HomeService service;
  final LocalRepository localRepo;

  _HomeControllerBase({required this.service, required this.localRepo});

  @observable
  bool loading = false;

  @observable
  AddressModel? address;

  @observable
  ObservableList<AddressModel> history = ObservableList<AddressModel>();

  @observable
  String? error;

  // Search by address (UF, city, street)
  @observable
  bool isSearching = false;

  @observable
  String searchUf = '';

  @observable
  String searchCity = '';

  @observable
  String searchStreet = '';

  @observable
  ObservableList<AddressModel> searchResults = ObservableList<AddressModel>();

  @action
  Future<void> loadHistory() async {
    final list = await service.getHistory();
    history = ObservableList<AddressModel>.of(list);
  }

  @action
  Future<void> searchByCep(String cep) async {
    loading = true;
    error = null;
    try {
      final result = await service.getByCep(cep);
      address = result;
      // atualiza histórico localmente
      await loadHistory();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> openMapForLastAddress() async {
    if (address == null) {
      final last = await service.getLast();
      if (last == null) {
        throw Exception('Nenhum endereço disponível para traçar rota');
      }
      address = last;
    }
    await service.openMapForAddress(address!);
  }

  // Setters for search inputs
  void setSearchUf(String value) {
    searchUf = value;
  }

  void setSearchCity(String value) {
    searchCity = value;
  }

  void setSearchStreet(String value) {
    searchStreet = value;
  }

  void clearSearch() {
    runInAction(() {
      searchResults.clear();
      searchUf = '';
      searchCity = '';
      searchStreet = '';
      error = null;
    });
  }

  @action
  Future<void> searchByAddress() async {
    if (searchUf.isEmpty || searchCity.isEmpty || searchStreet.isEmpty) {
      runInAction(() {
        error = 'Preencha UF, cidade e rua';
      });
      return;
    }

    runInAction(() {
      isSearching = true;
      error = null;
    });

    try {
      final results = await service.searchAddress(
        uf: searchUf,
        city: searchCity,
        street: searchStreet,
      );
      runInAction(() {
        searchResults
          ..clear()
          ..addAll(results);
        isSearching = false;
      });
    } catch (e) {
      runInAction(() {
        error = e.toString();
        searchResults.clear();
        isSearching = false;
      });
    }
  }

  @action
  Future<void> saveToHistory(AddressModel addressToSave) async {
    await localRepo.save(addressToSave);
    await loadHistory();
  }

  @action
  Future<void> openMapForAddress(AddressModel addressToOpen) async {
    await service.openMapForAddress(addressToOpen);
  }
}
