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
}
