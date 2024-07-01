import '../../../domain/dtos/update_cache_dto.dart';
import '../../../domain/dtos/write_cache_dto.dart';
import '../../../domain/entities/data_cache_entity.dart';

final class WriteCacheDTOAdapter {
  static DataCacheEntity<T> toSave<T extends Object>(WriteCacheDTO<T> dto) {
    return DataCacheEntity<T>(
      id: dto.key,
      data: dto.data,
      createdAt: DateTime.now(),
      endAt: DateTime.now().add(dto.cacheConfig.dataCacheOptions.ttlMaxDuration),
    );
  }

  static DataCacheEntity<T> toUpdate<T extends Object>(UpdateCacheDTO<T> dto) {
    return DataCacheEntity<T>(
      id: dto.previewCache.id,
      data: dto.previewCache.data,
      createdAt: dto.previewCache.createdAt,
      endAt: DateTime.now().add(dto.config.dataCacheOptions.ttlMaxDuration),
      updatedAt: DateTime.now(),
    );
  }
}
