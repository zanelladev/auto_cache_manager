// ignore_for_file: require_trailing_commas

import 'package:auto_cache_manager/src/core/extensions/map_extensions.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/entities/cache_entity.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/enums/invalidation_type.dart';
import 'package:auto_cache_manager/src/modules/data_cache/domain/enums/storage_type.dart';
import 'package:auto_cache_manager/src/modules/data_cache/external/adapters/cache_adapter.dart';
import 'package:auto_cache_manager/src/modules/data_cache/external/adapters/enums/invalidation_type_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const id = 'zanelladev';
  const data = 'test';
  const storageType = StorageType.prefs;
  const invalidationType = InvalidationType.ttl;
  final createdAt = DateTime.utc(2024, 9, 9);
  final endAt = createdAt.add(const Duration(days: 3));

  group('CacheAdapter.fromJson |', () {
    final jsonCache = {
      'id': id,
      'data': data,
      'storage_type': storageType.name,
      'invalidation_type': InvalidationTypeAdapter.toKey(invalidationType),
      'created_at': createdAt.toIso8601String(),
      'end_at': endAt.toIso8601String()
    };

    test('should be able to get CacheEntity from json successfully', () {
      final cache = CacheAdapter.fromJson(jsonCache);

      expect(cache.id, equals(id));
      expect(cache.data, equals(data));
      expect(cache.invalidationType, equals(invalidationType));
      expect(cache.createdAt, equals(createdAt));
      expect(cache.endAt, equals(endAt));
    });

    test('should NOT be able to get CacheEntity from json when invalid values', () {
      final invalidJson = jsonCache.updateValueByKey(key: 'created_at', newValue: 'invalid_value');

      expect(() => CacheAdapter.fromJson(invalidJson), throwsFormatException);
    });

    test('should NOT be able to get CacheEntity from json when invalid keys', () {
      final jsonInvalidKeys = jsonCache.updateKey(oldKey: 'created_at', newKey: 'invalid_created_at');

      expect(() => CacheAdapter.fromJson(jsonInvalidKeys), throwsA(isA<TypeError>()));
    });
  });

  group('CacheAdapter.toJson |', () {
    final cache = CacheEntity(
      id: id,
      data: data,
      invalidationType: invalidationType,
      createdAt: createdAt,
      endAt: endAt,
    );

    test('should be able to parse CacheEntity to json successfully', () {
      final jsonCache = CacheAdapter.toJson(cache);

      expect(jsonCache.containsKey('id'), isTrue);
      expect(jsonCache['id'], equals(id));

      expect(jsonCache.containsKey('data'), isTrue);
      expect(jsonCache['data'], equals(data));

      expect(jsonCache.containsKey('invalidation_type'), isTrue);
      expect(jsonCache['invalidation_type'], equals(InvalidationTypeAdapter.toKey(invalidationType)));

      expect(jsonCache.containsKey('created_at'), isTrue);
      expect(jsonCache['created_at'], equals(createdAt.toIso8601String()));
    });
  });
}