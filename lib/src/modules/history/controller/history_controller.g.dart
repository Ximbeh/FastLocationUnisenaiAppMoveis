// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HistoryControllerBase on _HistoryControllerBase, Store {
  late final _$loadingAtom = Atom(name: '_HistoryControllerBase.loading', context: context);

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

  late final _$historyAtom = Atom(name: '_HistoryControllerBase.history', context: context);

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

  late final _$searchResultsAtom = Atom(name: '_HistoryControllerBase.searchResults', context: context);

  @override
  ObservableList<AddressModel> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(ObservableList<AddressModel> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$errorAtom = Atom(name: '_HistoryControllerBase.error', context: context);

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

  late final _$isSearchingAtom = Atom(name: '_HistoryControllerBase.isSearching', context: context);

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  late final _$searchUfAtom = Atom(name: '_HistoryControllerBase.searchUf', context: context);

  @override
  String get searchUf {
    _$searchUfAtom.reportRead();
    return super.searchUf;
  }

  @override
  set searchUf(String value) {
    _$searchUfAtom.reportWrite(value, super.searchUf, () {
      super.searchUf = value;
    });
  }

  late final _$searchCityAtom = Atom(name: '_HistoryControllerBase.searchCity', context: context);

  @override
  String get searchCity {
    _$searchCityAtom.reportRead();
    return super.searchCity;
  }

  @override
  set searchCity(String value) {
    _$searchCityAtom.reportWrite(value, super.searchCity, () {
      super.searchCity = value;
    });
  }

  late final _$searchStreetAtom = Atom(name: '_HistoryControllerBase.searchStreet', context: context);

  @override
  String get searchStreet {
    _$searchStreetAtom.reportRead();
    return super.searchStreet;
  }

  @override
  set searchStreet(String value) {
    _$searchStreetAtom.reportWrite(value, super.searchStreet, () {
      super.searchStreet = value;
    });
  }

  late final _$loadHistoryAsyncAction = AsyncAction('_HistoryControllerBase.loadHistory', context: context);

  @override
  Future<void> loadHistory() {
    return _$loadHistoryAsyncAction.run(() => super.loadHistory());
  }

  late final _$searchByAddressAsyncAction = AsyncAction('_HistoryControllerBase.searchByAddress', context: context);

  @override
  Future<void> searchByAddress() {
    return _$searchByAddressAsyncAction.run(() => super.searchByAddress());
  }

  late final _$openMapForAddressAsyncAction = AsyncAction('_HistoryControllerBase.openMapForAddress', context: context);

  @override
  Future<void> openMapForAddress(AddressModel address) {
    return _$openMapForAddressAsyncAction.run(() => super.openMapForAddress(address));
  }

  late final _$saveAddressToHistoryAsyncAction = AsyncAction('_HistoryControllerBase.saveAddressToHistory', context: context);

  @override
  Future<void> saveAddressToHistory(AddressModel address) {
    return _$saveAddressToHistoryAsyncAction.run(() => super.saveAddressToHistory(address));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
history: ${history},
searchResults: ${searchResults},
error: ${error},
isSearching: ${isSearching},
searchUf: ${searchUf},
searchCity: ${searchCity},
searchStreet: ${searchStreet}
    ''';
  }
}
