part of '../substitution_cache_strategy.dart';

final class FifoSubstitutionCacheStrategy extends ISubstitutionCacheStrategy {
  const FifoSubstitutionCacheStrategy(super.dataRepository, super.substitutionRepository);

  @override
  Either<AutoCacheError, String> getCacheKey({bool recursive = false}) {
    final keysResponse = substitutionRepository.getKeys();
    return keysResponse.mapRight((keys) => keys.first);
  }
}
