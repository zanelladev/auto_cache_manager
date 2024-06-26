import '../../../core.dart';

class GetStorageException extends AutoCacheManagerException {
  GetStorageException({
    required super.code,
    required super.message,
    required super.stackTrace,
  });
}

class GetStorageKeysException extends AutoCacheManagerException {
  GetStorageKeysException({
    required super.code,
    required super.message,
    required super.stackTrace,
  });
}

class SaveStorageException extends AutoCacheManagerException {
  SaveStorageException({
    required super.code,
    required super.message,
    required super.stackTrace,
  });
}

class DeleteStorageException extends AutoCacheManagerException {
  DeleteStorageException({
    required super.code,
    required super.message,
    required super.stackTrace,
  });
}

class ClearStorageException extends AutoCacheManagerException {
  ClearStorageException({
    required super.code,
    required super.message,
    required super.stackTrace,
  });
}
