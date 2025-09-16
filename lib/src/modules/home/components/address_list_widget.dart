import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddressListWidget extends StatelessWidget {
  final List<AddressModel> items;
  final ValueChanged<AddressModel>? onTap;

  const AddressListWidget({super.key, required this.items, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const Center(child: Text('Nenhum histórico.'));
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final a = items[i];
        return ListTile(
          title: Text(a.logradouro.isNotEmpty ? a.logradouro : 'Sem rua'),
          subtitle: Text(
            '${a.bairro} • ${a.localidade}/${a.uf} • CEP ${a.cep}',
          ),
          onTap: () => onTap?.call(a),
        );
      },
    );
  }
}
