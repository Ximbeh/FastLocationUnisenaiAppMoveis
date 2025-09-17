import 'package:flutter/material.dart';
import '../model/address_model.dart';

class LastAddressWidget extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback? onNavigate;

  const LastAddressWidget({super.key, this.address, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    Icons.location_on,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Último Endereço',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.navigation, color: Color(0xFF10B981)),
                    onPressed: onNavigate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address!.logradouro.isNotEmpty
                  ? address!.logradouro
                  : 'Endereço sem rua',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_city, color: Color(0xFF6B7280), size: 16),
                const SizedBox(width: 8),
                Text(
                  '${address!.bairro} • ${address!.localidade}/${address!.uf}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.pin_drop, color: Color(0xFF6B7280), size: 16),
                const SizedBox(width: 8),
                Text(
                  'CEP: ${address!.cep}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
