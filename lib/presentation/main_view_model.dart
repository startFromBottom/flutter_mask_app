import 'package:flutter/foundation.dart';
import 'package:mask_app/domain/usecase/get_near_by_stores_use_case.dart';
import 'package:mask_app/presentation/main_state.dart';

class MainViewModel with ChangeNotifier {
  final GetNearByStoresUseCase _getNearByStoresUseCase;

  MainState _state = MainState();

  MainState get state => _state;

  MainViewModel(this._getNearByStoresUseCase);

  Future<void> getStores() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    _state = _state.copyWith(
      stores: await _getNearByStoresUseCase.execute(),
      isLoading: false,
    );

    notifyListeners();
  }
}
