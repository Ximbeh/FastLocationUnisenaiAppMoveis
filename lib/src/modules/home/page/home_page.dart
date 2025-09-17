import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../components/last_address_widget.dart';
import '../controller/home_controller.dart';
import '../repositories/local_repository.dart';
import '../repositories/viacep_repository.dart';
import '../service/home_service.dart';
import '../components/address_list_widget.dart';
import '../components/empty_search_widget.dart';
import '../model/address_model.dart';
import '../../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;
  final TextEditingController cepController = TextEditingController();
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    final viacepRepo = ViacepRepository();
    final localRepo = LocalRepository();
    final service = HomeService(viacepRepo: viacepRepo, localRepo: localRepo);
    controller = HomeController(service: service, localRepo: localRepo);
    controller.loadHistory();

    _disposer = reaction<String?>((_) => controller.error, (error) {
      if (error != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    });
  }

  @override
  void dispose() {
    cepController.dispose();
    _disposer();
    super.dispose();
  }

  void _searchCep() {
    final cep = cepController.text.trim();
    if (cep.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe um CEP')));
      return;
    }
    controller.searchByCep(cep);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastLocation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de busca
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Buscar CEP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: cepController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CEP',
                        hintText: 'Digite o CEP (ex: 12345-678)',
                        prefixIcon: Icon(Icons.location_on, color: Color(0xFF3B82F6)),
                        suffixIcon: Icon(Icons.clear, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _searchCep,
                            icon: const Icon(Icons.search),
                            label: const Text('Buscar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await controller.openMapForLastAddress();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                          ),
                          child: const Icon(Icons.navigation),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Conteúdo dinâmico
            Observer(
              builder: (_) {
                if (controller.loading) {
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Buscando endereço...'),
                      ],
                    ),
                  );
                }
                if (controller.address == null && controller.history.isEmpty) {
                  return const EmptySearchWidget();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.address != null || controller.history.isNotEmpty) ...[
                      const Text(
                        'Último Endereço',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LastAddressWidget(
                        address: controller.address ??
                            (controller.history.isNotEmpty
                                ? controller.history.first
                                : null),
                        onNavigate: () async {
                          try {
                            await controller.openMapForLastAddress();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (controller.history.isNotEmpty) ...[
                      const Text(
                        'Histórico',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AddressListWidget(
                        items: controller.history.toList(),
                        onTap: (AddressModel a) {
                          controller.address = a;
                        },
                      ),
                    ],
                  ],
                );
              },
              ),
          ],
        ),
      ),
    );
  }
}
