import 'package:auto_cache_manager/src/core/core.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/dtos/clear_cache_dto.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/dtos/delete_cache_dto.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/dtos/get_cache_dto.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/dtos/save_cache_dto.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/entities/cache_entity.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/enums/storage_type.dart';
import 'package:auto_cache_manager/src/modules/data_cache/infra/datasources/i_prefs_cache_datasource.dart';
import 'package:auto_cache_manager/src/modules/data_cache/infra/datasources/i_sql_cache_datasource.dart';
import 'package:auto_cache_manager/src/modules/data_cache/infra/repositories/cache_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../commons/extensions/when_extensions.dart';

class PrefsDatasourceMock extends Mock implements IPrefsCacheDatasource {}

class SQLDatasourceMock extends Mock implements ISQLCacheDatasource {}

class FakeAutoCacheManagerException extends Fake implements AutoCacheManagerException {}

class FakeCacheConfig extends Fake implements CacheConfig {}

class CacheEntityFake<T extends Object> extends Fake implements CacheEntity<T> {
  final T fakeData;

  CacheEntityFake({required this.fakeData});

  @override
  T get data => fakeData;
}

void main() {
  final prefsDatasource = PrefsDatasourceMock();
  final sqlDatasource = SQLDatasourceMock();

  final fakeCacheConfig = FakeCacheConfig();

  final sut = CacheRepository(prefsDatasource, sqlDatasource);

  tearDown(() {
    reset(prefsDatasource);
    reset(sqlDatasource);
  });

  group('CacheRepository.get |', () {
    const sqlDto = GetCacheDTO(key: 'my_key', storageType: StorageType.sql);
    const prefsDto = GetCacheDTO(key: 'my_key', storageType: StorageType.prefs);

    test('should be able to find cache data by key in prefs successfully', () async {
      when(() => prefsDatasource.get<String>('my_key')).thenReturn(CacheEntityFake<String>(fakeData: 'any_data'));

      final response = await sut.get<String>(prefsDto);

      expect(response.isSuccess, isTrue);
      expect(response.success?.data, equals('any_data'));
      verify(() => prefsDatasource.get<String>('my_key')).called(1);
      verifyNever(() => sqlDatasource.get<String>('my_key'));
    });

    test('should be able to return NULL when cache not found data in prefs', () async {
      when(() => prefsDatasource.get<String>('my_key')).thenReturn(null);

      final response = await sut.get<String>(prefsDto);

      expect(response.isSuccess, isTrue);
      expect(response.success, isNull);
      verify(() => prefsDatasource.get<String>('my_key')).called(1);
      verifyNever(() => sqlDatasource.get<String>('my_key'));
    });

    test('should NOT be able to get cache in prefs when datasource throws an AutoCacheManagerException', () async {
      when(() => prefsDatasource.get<String>('my_key')).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.get<String>(prefsDto);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => prefsDatasource.get<String>('my_key')).called(1);
      verifyNever(() => sqlDatasource.get<String>('my_key'));
    });

    test('should be able to find cache data by key in SQL successfully', () async {
      when(() => sqlDatasource.get<String>('my_key')).thenAnswer(
        (_) async => CacheEntityFake<String>(fakeData: 'any_data'),
      );

      final response = await sut.get<String>(sqlDto);

      expect(response.isSuccess, isTrue);
      expect(response.success?.data, equals('any_data'));
      verify(() => sqlDatasource.get<String>('my_key')).called(1);
      verifyNever(() => prefsDatasource.get<String>('my_key'));
    });

    test('should be able to return NULL when cache not found data in SQL', () async {
      when(() => sqlDatasource.get<String>('my_key')).thenAnswer((_) async => null);

      final response = await sut.get<String>(sqlDto);

      expect(response.isSuccess, isTrue);
      expect(response.success, isNull);
      verify(() => sqlDatasource.get<String>('my_key')).called(1);
      verifyNever(() => prefsDatasource.get<String>('my_key'));
    });

    test('should NOT be able to find cache data in SQL when datasource throws an AutoCacheManagerException', () async {
      when(() => sqlDatasource.get<String>('my_key')).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.get<String>(sqlDto);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => sqlDatasource.get<String>('my_key')).called(1);
      verifyNever(() => prefsDatasource.get<String>('my_key'));
    });
  });

  group('CacheRepository.getKeys |', () {
    test('should be able to get keys of prefs datasource successfully', () async {
      when(() => prefsDatasource.getKeys()).thenReturn(['keys']);

      final response = await sut.getKeys(StorageType.prefs);

      expect(response.isSuccess, isTrue);
      expect(response.success, equals(['keys']));
      verify(() => prefsDatasource.getKeys()).called(1);
      verifyNever(() => sqlDatasource.getKeys());
    });

    test('should be able to get keys of sql datasource successfully', () async {
      when(() => sqlDatasource.getKeys()).thenAnswer((_) async => ['keys']);

      final response = await sut.getKeys(StorageType.sql);

      expect(response.isSuccess, isTrue);
      expect(response.success, equals(['keys']));
      verify(() => sqlDatasource.getKeys()).called(1);
      verifyNever(() => prefsDatasource.getKeys());
    });

    test('should NOT be able to get keys of prefs when prefs datasource fails', () async {
      when(() => prefsDatasource.getKeys()).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.getKeys(StorageType.prefs);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => prefsDatasource.getKeys()).called(1);
      verifyNever(() => sqlDatasource.getKeys());
    });

    test('should NOT be able to get keys of sql when sql datasource fails', () async {
      when(() => sqlDatasource.getKeys()).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.getKeys(StorageType.sql);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => sqlDatasource.getKeys()).called(1);
      verifyNever(() => prefsDatasource.getKeys());
    });
  });

  group('CacheRepository.save |', () {
    final prefsDto = SaveCacheDTO<String>(
      key: 'my_key',
      data: 'my_data',
      storageType: StorageType.prefs,
      cacheConfig: fakeCacheConfig,
    );

    final sqlDto = SaveCacheDTO<String>(
      key: 'my_key',
      data: 'my_data',
      storageType: StorageType.sql,
      cacheConfig: fakeCacheConfig,
    );

    test('should be able to save cache data with prefs successfully', () async {
      when(() => prefsDatasource.save<String>(prefsDto)).thenAsyncVoid();

      final response = await sut.save<String>(prefsDto);

      expect(response.isSuccess, isTrue);
      verify(() => prefsDatasource.save<String>(prefsDto)).called(1);
      verifyNever(() => sqlDatasource.save<String>(prefsDto));
    });

    test('should NOT be able to save cache when prefs datasource throws an AutoCacheManagerException', () async {
      when(() => prefsDatasource.save<String>(prefsDto)).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.save<String>(prefsDto);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => prefsDatasource.save<String>(prefsDto)).called(1);
      verifyNever(() => sqlDatasource.save<String>(prefsDto));
    });

    test('should be able to save cache data with SQL successfully', () async {
      when(() => sqlDatasource.save<String>(sqlDto)).thenAsyncVoid();

      final response = await sut.save<String>(sqlDto);

      expect(response.isSuccess, isTrue);
      verify(() => sqlDatasource.save<String>(sqlDto)).called(1);
      verifyNever(() => prefsDatasource.save<String>(sqlDto));
    });

    test('should NOT be able to save cache when SQL datasource throws an AutoCacheManagerException', () async {
      when(() => sqlDatasource.save<String>(sqlDto)).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.save<String>(sqlDto);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => sqlDatasource.save<String>(sqlDto)).called(1);
      verifyNever(() => prefsDatasource.save<String>(sqlDto));
    });
  });

  group('CacheRepository.delete |', () {
    const prefsDto = DeleteCacheDTO(key: 'my_key', storageType: StorageType.prefs);
    const sqlDto = DeleteCacheDTO(key: 'my_key', storageType: StorageType.sql);

    test('should be able to delete prefs cache by key successfully', () async {
      when(() => prefsDatasource.delete('my_key')).thenAsyncVoid();

      final response = await sut.delete(prefsDto);

      expect(response.isSuccess, isTrue);
      expect(response.success, isA<Unit>());
      verify(() => prefsDatasource.delete('my_key')).called(1);
      verifyNever(() => sqlDatasource.delete('my_key'));
    });

    test('should be able to delete sql cache by key successfully', () async {
      when(() => sqlDatasource.delete('my_key')).thenAsyncVoid();

      final response = await sut.delete(sqlDto);

      expect(response.isSuccess, isTrue);
      expect(response.success, isA<Unit>());
      verify(() => sqlDatasource.delete('my_key')).called(1);
      verifyNever(() => prefsDatasource.delete('my_key'));
    });

    test('should NOT be able to delete prefs cache when datasource fails', () async {
      when(() => prefsDatasource.delete('my_key')).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.delete(prefsDto);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => prefsDatasource.delete('my_key')).called(1);
      verifyNever(() => sqlDatasource.delete('my_key'));
    });

    test('should NOT be able to delete sql cache when datasource fails', () async {
      when(() => sqlDatasource.delete('my_key')).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.delete(sqlDto);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(() => sqlDatasource.delete('my_key')).called(1);
      verifyNever(() => prefsDatasource.delete('my_key'));
    });
  });

  group('CacheRepository.clear |', () {
    const prefsDTO = ClearCacheDTO(storageType: StorageType.prefs);
    const sqlDTO = ClearCacheDTO(storageType: StorageType.sql);

    test('should be able to clear prefs data successfully', () async {
      when(prefsDatasource.clear).thenAsyncVoid();

      final response = await sut.clear(prefsDTO);

      expect(response.isSuccess, isTrue);
      verify(prefsDatasource.clear).called(1);
      verifyNever(sqlDatasource.clear);
    });

    test('should be able to clear SQL data successfully', () async {
      when(sqlDatasource.clear).thenAsyncVoid();

      final response = await sut.clear(sqlDTO);

      expect(response.isSuccess, isTrue);
      verify(sqlDatasource.clear).called(1);
      verifyNever(prefsDatasource.clear);
    });

    test('should NOT be able to clear prefs data when datasource fails', () async {
      when(prefsDatasource.clear).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.clear(prefsDTO);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(prefsDatasource.clear).called(1);
      verifyNever(sqlDatasource.clear);
    });

    test('should NOT be able to clear SQL data when datasource fails', () async {
      when(sqlDatasource.clear).thenThrow(FakeAutoCacheManagerException());

      final response = await sut.clear(sqlDTO);

      expect(response.isError, isTrue);
      expect(response.error, isA<AutoCacheManagerException>());
      verify(sqlDatasource.clear).called(1);
      verifyNever(prefsDatasource.clear);
    });
  });
}
