import 'package:hive/hive.dart';
part 'address_model.g.dart';

@HiveType(typeId: 0)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String cep;
  @HiveField(1)
  final String logradouro;
  @HiveField(2)
  final String complemento;
  @HiveField(3)
  final String bairro;
  @HiveField(4)
  final String localidade;
  @HiveField(5)
  final String uf;
  @HiveField(6)
  final String ibge;
  @HiveField(7)
  final String gia;
  @HiveField(8)
  final String ddd;
  @HiveField(9)
  final String siafi;

  AddressModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('erro')) {
      throw Exception('CEP não encontrado');
    }
    return AddressModel(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
      ibge: json['ibge'] ?? '',
      gia: json['gia'] ?? '',
      ddd: json['ddd'] ?? '',
      siafi: json['siafi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'cep': cep,
    'logradouro': logradouro,
    'complemento': complemento,
    'bairro': bairro,
    'localidade': localidade,
    'uf': uf,
    'ibge': ibge,
    'gia': gia,
    'ddd': ddd,
    'siafi': siafi,
  };

  @override
  String toString() => '$logradouro, $bairro - $localidade/$uf (CEP $cep)';
}
