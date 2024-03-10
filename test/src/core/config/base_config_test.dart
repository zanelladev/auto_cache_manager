import 'package:auto_cache_manager/src/core/config/base_config.dart';
import 'package:auto_cache_manager/src/modules/cache/domain/enums/invalidation_type.dart';
import 'package:auto_cache_manager/src/modules/cache/domain/enums/storage_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sut = BaseConfig.defaultConfig();

  group('BaseConfig.defaultConfig |', () {
    test('should be able to validate attributes of default config', () {
      expect(sut.invalidationType, equals(InvalidationType.refresh));
      expect(sut.storageType, equals(StorageType.kvs));
    });
  });
}