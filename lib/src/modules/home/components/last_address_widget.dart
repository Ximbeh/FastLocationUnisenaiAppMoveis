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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(
          address!.logradouro.isNotEmpty
              ? address!.logradouro
              : 'Endereço sem rua',
        ),
        subtitle: Text(
          '${address!.bairro} • ${address!.localidade}/${address!.uf}\nCEP: ${address!.cep}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.navigation),
          onPressed: onNavigate,
        ),
      ),
    );
  }
}
