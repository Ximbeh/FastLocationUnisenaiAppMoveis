import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddressListWidget extends StatelessWidget {
  final List<AddressModel> items;
  final ValueChanged<AddressModel>? onTap;
  final void Function(AddressModel)? onSave;
  final void Function(AddressModel)? onOpenMap;

  const AddressListWidget({
    super.key,
    required this.items,
    this.onTap,
    this.onSave,
    this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Color(0xFF9CA3AF)),
              SizedBox(height: 16),
              Text(
                'Nenhum histórico ainda',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final a = items[i];
        return Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
            title: Text(
              a.logradouro.isNotEmpty ? a.logradouro : 'Sem rua',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            subtitle: Text(
              '${a.bairro} • ${a.localidade}/${a.uf} • CEP ${a.cep}',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 13,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.map, color: Color(0xFF10B981)),
                  tooltip: 'Abrir no mapa',
                  onPressed: () => onOpenMap?.call(a),
                ),
                IconButton(
                  icon: const Icon(Icons.save, color: Color(0xFF3B82F6)),
                  tooltip: 'Salvar no histórico',
                  onPressed: () => onSave?.call(a),
                ),
              ],
            ),
            onTap: () => onTap?.call(a),
          ),
        );
      },
    );
  }
}
