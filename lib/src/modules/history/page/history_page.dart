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

class _HistoryPageState extends State<HistoryPage> {
  late HistoryController controller;

  @override
  void initState() {
    super.initState();
    
    // Inicializar o service e controller
    final viacepRepo = ViacepRepository();
    final localRepo = LocalRepository();
    final service = HomeService(viacepRepo: viacepRepo, localRepo: localRepo);
    controller = HistoryController(service: service);
  }

  @override
  void dispose() {
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
              return _buildAddressCard(address);
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


  Widget _buildAddressCard(AddressModel address) {
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
            ElevatedButton.icon(
              onPressed: () => controller.openMapForAddress(address),
              icon: const Icon(Icons.map, size: 18),
              label: const Text('Abrir no Mapa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
