import 'package:mask_app/domain/model/location.dart';
import 'package:mask_app/domain/model/permission.dart';
import 'package:mask_app/domain/model/store.dart';
import 'package:mask_app/domain/permission/location_permission_handler.dart';
import 'package:mask_app/domain/repository/location_repository.dart';
import 'package:mask_app/domain/repository/store_repository.dart';

class GetNearByStoresUseCase {
  final StoreRepository _storeRepository;
  final LocationRepository _locationRepository;
  final LocationPermissionHandler _locationPermissionHandler;

  GetNearByStoresUseCase({
    required StoreRepository storeRepository,
    required LocationRepository locationRepository,
    required LocationPermissionHandler locationPermissionHandler,
  })  : _locationPermissionHandler = locationPermissionHandler,
        _locationRepository = locationRepository,
        _storeRepository = storeRepository;

  Future<List<Store>> execute() async {
    final stores = await _storeRepository.getStores();

    // 기기의 위치 서비스 확인
    final isServiceEnabled =
        await _locationPermissionHandler.isLocationServiceEnabled();

    // 권한 체크
    if (isServiceEnabled) {
      // 현재 위치 권한 정보
      final permission = await _locationPermissionHandler.checkPermission();
      // 거부 -> 정렬 없이 리턴
      if (permission == Permission.denied) {
        print('거부');
        return stores;
      }

      // 2번 거부 -> 정렬 없이 리턴
      if (permission == Permission.deniedForever) {
        print("2번 거부");
        return stores;
      }

      // 승인 -> 정렬해서 리턴
      final location = await _locationRepository.getLocation();

      return stores
          .map(
            (store) => store.copyWith(
              distance: location.distanceBetween(
                Location(store.lat, store.lng),
              ),
            ),
          )
          .toList()
        ..sort(
          (a, b) => a.distance.compareTo(b.distance),
        );
    }

    return stores;
  }
}
