import 'package:mobx/mobx.dart';
import '../../home/model/address_model.dart';
import '../../home/service/home_service.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

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

  // Adicionar um controle para evitar múltiplas chamadas simultâneas
  bool _isLoadingHistory = false;
  bool _isSearching = false;

  @action
  Future<void> loadHistory() async {
    // Prevenir múltiplas chamadas simultâneas
    if (_isLoadingHistory) return;
    
    _isLoadingHistory = true;
    loading = true;
    error = null;
    
    try {
      final list = await service.getHistory();
      runInAction(() {
        history = ObservableList<AddressModel>.of(list);
      });
    } catch (e) {
      runInAction(() {
        error = e.toString();
      });
    } finally {
      runInAction(() {
        loading = false;
        _isLoadingHistory = false;
      });
    }
  }

  @action
  Future<void> searchByAddress() async {
    // Prevenir múltiplas buscas simultâneas
    if (_isSearching) return;
    
    if (searchUf.isEmpty || searchCity.isEmpty || searchStreet.isEmpty) {
      runInAction(() {
        error = 'Preencha todos os campos para buscar';
      });
      return;
    }

    _isSearching = true;
    
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
        searchResults = ObservableList<AddressModel>.of(results);
        isSearching = false;
        _isSearching = false;
      });
    } catch (e) {
      runInAction(() {
        error = e.toString();
        searchResults.clear();
        isSearching = false;
        _isSearching = false;
      });
    }
  }

  @action
  void clearSearch() {
    searchResults.clear();
    searchUf = '';
    searchCity = '';
    searchStreet = '';
    error = null;
    _isSearching = false;
  }

  @action
  void setSearchUf(String value) {
    searchUf = value;
  }

  @action
  void setSearchCity(String value) {
    searchCity = value;
  }

  @action
  void setSearchStreet(String value) {
    searchStreet = value;
  }

  @action
  Future<void> openMapForAddress(AddressModel address) async {
    try {
      await service.openMapForAddress(address);
    } catch (e) {
      runInAction(() {
        error = e.toString();
      });
    }
  }

  @action
  Future<void> saveAddressToHistory(AddressModel address) async {
    try {
      // Usar o método getByCep que já salva automaticamente no histórico
      await service.getByCep(address.cep);
      // Recarregar o histórico após salvar
      await loadHistory();
    } catch (e) {
      runInAction(() {
        error = e.toString();
      });
    }
  }

  // Dispose para limpar recursos se necessário
  void dispose() {
    _isLoadingHistory = false;
    _isSearching = false;
  }
}