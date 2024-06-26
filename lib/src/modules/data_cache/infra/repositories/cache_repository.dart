import '../../../../core/core.dart';
import '../../domain/dtos/clear_cache_dto.dart';
import '../../domain/dtos/delete_cache_dto.dart';
import '../../domain/dtos/get_cache_dto.dart';
import '../../domain/dtos/save_cache_dto.dart';
import '../../domain/entities/cache_entity.dart';
import '../../domain/enums/storage_type.dart';
import '../../domain/repositories/i_cache_repository.dart';

import '../datasources/i_prefs_cache_datasource.dart';
import '../datasources/i_sql_cache_datasource.dart';

class CacheRepository implements ICacheRepository {
  final IPrefsCacheDatasource _prefsDatasource;
  final ISQLCacheDatasource _sqlDatasource;

  const CacheRepository(this._prefsDatasource, this._sqlDatasource);

  @override
  AsyncEither<AutoCacheManagerException, CacheEntity<T>?> get<T extends Object>(GetCacheDTO dto) async {
    try {
      final action = dto.storageType.isPrefs ? _prefsDatasource.get : _sqlDatasource.get;

      final response = await action.call<T>(dto.key);

      return right(response);
    } on AutoCacheManagerException catch (exception) {
      return left(exception);
    }
  }

  @override
  AsyncEither<AutoCacheManagerException, List<String>> getKeys(StorageType storageType) async {
    try {
      final action = storageType.isPrefs ? _prefsDatasource.getKeys : _sqlDatasource.getKeys;

      final response = await action.call();

      return right(response);
    } on AutoCacheManagerException catch (exception) {
      return left(exception);
    }
  }

  @override
  AsyncEither<AutoCacheManagerException, Unit> save<T extends Object>(SaveCacheDTO<T> dto) async {
    try {
      final action = dto.storageType.isPrefs ? _prefsDatasource.save : _sqlDatasource.save;

      await action.call<T>(dto);

      return right(unit);
    } on AutoCacheManagerException catch (exception) {
      return left(exception);
    }
  }

  @override
  AsyncEither<AutoCacheManagerException, Unit> delete(DeleteCacheDTO dto) async {
    try {
      final action = dto.storageType.isPrefs ? _prefsDatasource.delete : _sqlDatasource.delete;

      await action.call(dto.key);

      return right(unit);
    } on AutoCacheManagerException catch (exception) {
      return left(exception);
    }
  }

  @override
  AsyncEither<AutoCacheManagerException, Unit> clear(ClearCacheDTO dto) async {
    try {
      final action = dto.storageType.isPrefs ? _prefsDatasource.clear : _sqlDatasource.clear;

      await action.call();

      return right(unit);
    } on AutoCacheManagerException catch (exception) {
      return left(exception);
    }
  }

  @override
  AsyncEither<AutoCacheManagerException, Unit> update<T extends Object>() async {
    throw UnimplementedError();
  }
}
