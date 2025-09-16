import 'package:hive/hive.dart';
import '../model/address_model.dart';

class LocalRepository {
  static const String boxName = 'addresses';

  Future<Box<AddressModel>> _openBox() async {
    return await Hive.openBox<AddressModel>(boxName);
  }

  Future<void> save(AddressModel address) async {
    final box = await _openBox();
    await box.add(address);
  }

  Future<List<AddressModel>> getAll() async {
    final box = await _openBox();
    return box.values.toList().reversed.toList();
  }

  Future<AddressModel?> getLast() async {
    final box = await _openBox();
    if (box.isEmpty) return null;
    return box.getAt(box.length - 1);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
