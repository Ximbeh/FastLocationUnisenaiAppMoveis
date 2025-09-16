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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: cepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: 'Digite o CEP (somente números ou com traço)',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _searchCep,
                      child: const Text('Buscar CEP'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await controller.openMapForLastAddress();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },
                    child: const Icon(Icons.navigation),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Observer(
                builder: (_) {
                  if (controller.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.address == null &&
                      controller.history.isEmpty) {
                    return const EmptySearchWidget();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LastAddressWidget(
                        address:
                            controller.address ??
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
                      const SizedBox(height: 12),
                      const Text(
                        'Histórico',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      AddressListWidget(
                        items: controller.history.toList(),
                        onTap: (AddressModel a) {
                          // ao tocar, mostra detalhes como último selecionado
                          controller.address = a;
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
