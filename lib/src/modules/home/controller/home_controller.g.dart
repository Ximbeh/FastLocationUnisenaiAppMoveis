// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_HomeControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$addressAtom =
      Atom(name: '_HomeControllerBase.address', context: context);

  @override
  AddressModel? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(AddressModel? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$historyAtom =
      Atom(name: '_HomeControllerBase.history', context: context);

  @override
  ObservableList<AddressModel> get history {
    _$historyAtom.reportRead();
    return super.history;
  }

  @override
  set history(ObservableList<AddressModel> value) {
    _$historyAtom.reportWrite(value, super.history, () {
      super.history = value;
    });
  }

  late final _$errorAtom =
      Atom(name: '_HomeControllerBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$loadHistoryAsyncAction =
      AsyncAction('_HomeControllerBase.loadHistory', context: context);

  @override
  Future<void> loadHistory() {
    return _$loadHistoryAsyncAction.run(() => super.loadHistory());
  }

  late final _$searchByCepAsyncAction =
      AsyncAction('_HomeControllerBase.searchByCep', context: context);

  @override
  Future<void> searchByCep(String cep) {
    return _$searchByCepAsyncAction.run(() => super.searchByCep(cep));
  }

  late final _$openMapForLastAddressAsyncAction = AsyncAction(
      '_HomeControllerBase.openMapForLastAddress',
      context: context);

  @override
  Future<void> openMapForLastAddress() {
    return _$openMapForLastAddressAsyncAction
        .run(() => super.openMapForLastAddress());
  }

  @override
  String toString() {
    return '''
loading: ${loading},
address: ${address},
history: ${history},
error: ${error}
    ''';
  }
}
