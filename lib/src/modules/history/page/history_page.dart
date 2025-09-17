import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../home/model/address_model.dart';
import '../../home/repositories/local_repository.dart';
import '../../home/repositories/viacep_repository.dart';
import '../../home/service/home_service.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  late HistoryController controller;
  late TabController tabController;
  late TextEditingController ufController;
  late TextEditingController cityController;
  late TextEditingController streetController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    
    // Inicializar controllers de texto
    ufController = TextEditingController();
    cityController = TextEditingController();
    streetController = TextEditingController();
    
    // Inicializar o service e controller
    final viacepRepo = ViacepRepository();
    final localRepo = LocalRepository();
    final service = HomeService(viacepRepo: viacepRepo, localRepo: localRepo);
    controller = HistoryController(service: service);
    
    // Listener para recarregar histórico quando a aba for selecionada
    tabController.addListener(() {
      if (tabController.index == 0 && !tabController.indexIsChanging) {
        // Aba de histórico foi selecionada
        controller.loadHistory();
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    ufController.dispose();
    cityController.dispose();
    streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildHistoryTab(),
    );
  }

  Widget _buildHistoryTab() {
    return FutureBuilder<void>(
      future: _initializeHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return Observer(
          builder: (context) {
            if (controller.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

        if (controller.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar histórico',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadHistory,
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        if (controller.history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum histórico encontrado',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Faça algumas buscas para ver o histórico aqui',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadHistory,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.history.length,
            itemBuilder: (context, index) {
              final address = controller.history[index];
              return _buildAddressCard(address, isFromHistory: true);
            },
          ),
        );
          },
        );
      },
    );
  }

  Future<void> _initializeHistory() async {
    await controller.loadHistory();
  }

  Widget _buildSearchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buscar CEP por Endereço',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Observer(
                    builder: (context) => TextField(
                      controller: ufController,
                      decoration: const InputDecoration(
                        labelText: 'UF (Estado)',
                        hintText: 'Ex: SP, RJ, MG',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      onChanged: controller.setSearchUf,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Observer(
                    builder: (context) => TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        hintText: 'Ex: São Paulo, Rio de Janeiro',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      onChanged: controller.setSearchCity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Observer(
                    builder: (context) => TextField(
                      controller: streetController,
                      decoration: const InputDecoration(
                        labelText: 'Rua/Logradouro',
                        hintText: 'Ex: Rua das Flores, Avenida Paulista',
                        prefixIcon: Icon(Icons.route),
                      ),
                      onChanged: controller.setSearchStreet,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.isSearching ? null : controller.searchByAddress,
                          icon: controller.isSearching
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.search),
                          label: Text(controller.isSearching ? 'Buscando...' : 'Buscar'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          controller.clearSearch();
                          ufController.clear();
                          cityController.clear();
                          streetController.clear();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Observer(
            builder: (context) {
              if (controller.error != null) {
                return Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.error!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.searchResults.isEmpty && !controller.isSearching) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum resultado encontrado',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Preencha os campos e clique em buscar',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.isSearching) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resultados da Busca (${controller.searchResults.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...controller.searchResults.map(
                    (address) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildAddressCard(address, isFromHistory: false),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, {required bool isFromHistory}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.logradouro.isNotEmpty ? address.logradouro : 'Logradouro não informado',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (address.bairro.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Bairro: ${address.bairro}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${address.localidade}/${address.uf}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'CEP: ${address.cep}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.openMapForAddress(address),
                    icon: const Icon(Icons.map, size: 18),
                    label: const Text('Abrir no Mapa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                    ),
                  ),
                ),
                if (!isFromHistory) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.saveAddressToHistory(address),
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Salvar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
