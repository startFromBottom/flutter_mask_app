import 'package:flutter_test/flutter_test.dart';
import 'package:mask_app/data/mock_datas.dart';
import 'package:mask_app/domain/usecase/get_near_by_stores_use_case.dart';

void main() {
  final useCase = GetNearByStoresUseCase(
    storeRepository: MockStoreRepositoryImpl(),
    locationRepository: MockLocationRepositoryImpl(),
    locationPermissionHandler: MockLocationPermissionHandler(),
  );
  test('약국정보가 가까운 순서대로 오름차순 정렬되어야 함', () async {
    final stores = await useCase.execute();
    expect(stores[0].name, '수원 약국');
    expect(stores[1].name, '안양 약국');
    expect(stores[2].name, '평택 약국');
  });
}
