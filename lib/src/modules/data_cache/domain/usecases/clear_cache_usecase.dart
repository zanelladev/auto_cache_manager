import '../../../../core/core.dart';
import '../dtos/clear_cache_dto.dart';
import '../repositories/i_cache_repository.dart';

abstract interface class ClearCacheUsecase {
  AsyncEither<AutoCacheManagerException, Unit> execute(ClearCacheDTO dto);
}

class ClearCache implements ClearCacheUsecase {
  final ICacheRepository _repository;

  const ClearCache(this._repository);

  @override
  AsyncEither<AutoCacheManagerException, Unit> execute(ClearCacheDTO dto) async {
    return _repository.clear(dto);
  }
}
