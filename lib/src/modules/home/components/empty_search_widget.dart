import 'package:flutter/material.dart';

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('Nenhum resultado. Tente buscar por um CEP ou endereço.'),
        ],
      ),
    );
  }
}
