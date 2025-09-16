import 'package:hive_flutter/hive_flutter.dart';
import '../../modules/home/model/address_model.dart';

class AppStorage {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AddressModelAdapter());
    await Hive.openBox<AddressModel>('addresses');
  }
}
