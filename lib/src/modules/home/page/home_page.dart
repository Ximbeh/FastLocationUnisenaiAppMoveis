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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final HomeController controller;
  final TextEditingController cepController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  late final ReactionDisposer _disposer;
  late final ReactionDisposer _resultsDisposer;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    final viacepRepo = ViacepRepository();
    final localRepo = LocalRepository();
    final service = HomeService(viacepRepo: viacepRepo, localRepo: localRepo);
    controller = HomeController(service: service, localRepo: localRepo);

    // Rebuild when switching tabs to ensure UI reflects latest MobX state
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        if (mounted) setState(() {});
      }
    });

    _disposer = reaction<String?>((_) => controller.error, (error) {
      if (error != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    });

    // Força rebuild quando resultados/estado de busca mudarem (workaround web/tab cache)
    _resultsDisposer = autorun((_) {
      // Observa os valores, sem precisar de pacote externo
      final _ = controller.isSearching;
      final __ = controller.searchResults.length;
      final ___ = controller.error;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    cepController.dispose();
    ufController.dispose();
    cityController.dispose();
    streetController.dispose();
    tabController.dispose();
    _disposer();
    _resultsDisposer();
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
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.push_pin, color: Colors.white), text: 'Por CEP'),
            Tab(icon: Icon(Icons.search, color: Colors.white), text: 'Por Endereço'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildCepTab(),
          _buildAddressTab(),
        ],
      ),
    );
  }

  Widget _buildCepTab() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Buscar CEP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
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
                            if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
            Observer(
              builder: (_) {
                if (controller.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.address == null) {
                  return const EmptySearchWidget();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Último Endereço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      LastAddressWidget(
                    address: controller.address!,
                        onNavigate: () async {
                          try {
                            await controller.openMapForLastAddress();
                          } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        },
                      ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTab() {
    return Observer(
      builder: (_) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buscar CEP por Endereço',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: ufController,
                        decoration: const InputDecoration(
                          labelText: 'UF (Estado)',
                          hintText: 'Ex: SC, SP, RJ',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        onChanged: controller.setSearchUf,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: cityController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          hintText: 'Ex: Florianópolis',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        onChanged: controller.setSearchCity,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: streetController,
                        decoration: const InputDecoration(
                          labelText: 'Rua/Logradouro',
                          hintText: 'Ex: Rua Felipe',
                          prefixIcon: Icon(Icons.route),
                        ),
                        onChanged: controller.setSearchStreet,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: controller.isSearching
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      controller.searchByAddress();
                                    },
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
                          const SizedBox(width: 12),
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
                              backgroundColor: const Color(0xFF64748B),
                              foregroundColor: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (controller.error != null)
                Text(controller.error!, style: const TextStyle(color: Colors.red))
              else if (controller.isSearching)
                const Center(child: CircularProgressIndicator())
              else if (controller.searchResults.isEmpty)
                const EmptySearchWidget()
              else
                AddressListWidget(
                  items: controller.searchResults.toList(),
                  onTap: (AddressModel a) {
                    controller.address = a;
                  },
                  onSave: (a) async {
                    await controller.saveToHistory(a);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Endereço salvo no histórico')),
                    );
                  },
                  onOpenMap: (a) async {
                    try {
                      await controller.openMapForAddress(a);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                      );
                    }
                  },
              ),
          ],
        ),
        );
      },
    );
  }
}
