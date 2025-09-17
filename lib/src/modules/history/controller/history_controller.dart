import 'package:mobx/mobx.dart';
import '../../home/model/address_model.dart';
import '../../home/service/home_service.dart';

part 'history_controller.g.dart';

class HistoryController extends _HistoryControllerBase {
  HistoryController({required HomeService service}) : super(service: service);
}

abstract class _HistoryControllerBase with Store {
  final HomeService service;

  _HistoryControllerBase({required this.service});

  @observable
  bool loading = false;

  @observable
  ObservableList<AddressModel> history = ObservableList<AddressModel>();

  @observable
  ObservableList<AddressModel> searchResults = ObservableList<AddressModel>();

  @observable
  String? error;

  @observable
  bool isSearching = false;

  @observable
  String searchUf = '';

  @observable
  String searchCity = '';

  @observable
  String searchStreet = '';

  @action
  Future<void> loadHistory() async {
    loading = true;
    error = null;
    try {
      final list = await service.getHistory();
      history = ObservableList<AddressModel>.of(list);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> searchByAddress() async {
    if (searchUf.isEmpty || searchCity.isEmpty || searchStreet.isEmpty) {
      error = 'Preencha todos os campos para buscar';
      return;
    }

    isSearching = true;
    error = null;
    try {
      final results = await service.searchAddress(
        uf: searchUf,
        city: searchCity,
        street: searchStreet,
      );
      searchResults = ObservableList<AddressModel>.of(results);
    } catch (e) {
      error = e.toString();
      searchResults.clear();
    } finally {
      isSearching = false;
    }
  }

  void clearSearch() {
    searchResults.clear();
    searchUf = '';
    searchCity = '';
    searchStreet = '';
    error = null;
  }

  void setSearchUf(String value) {
    searchUf = value;
  }

  void setSearchCity(String value) {
    searchCity = value;
  }

  void setSearchStreet(String value) {
    searchStreet = value;
  }

  @action
  Future<void> openMapForAddress(AddressModel address) async {
    try {
      await service.openMapForAddress(address);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> saveAddressToHistory(AddressModel address) async {
    try {
      // O método getByCep já salva automaticamente no histórico
      await service.getByCep(address.cep);
      await loadHistory();
    } catch (e) {
      error = e.toString();
    }
  }
}
