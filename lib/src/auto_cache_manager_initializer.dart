import 'auto_cache_injections.dart';
import 'auto_cache_manager_config.dart';

import 'core/core.dart';

/// A singleton class responsible for initializing and configuring the auto cache manager.
/// It provides a central point of access to manage cache configurations and ensures
/// that the cache injection mechanism is properly set up before use.
class AutoCacheManagerInitializer {
  /// Private constructor for the singleton pattern.
  AutoCacheManagerInitializer._();

  /// The single instance of [AutoCacheManagerInitializer].
  static final _instance = AutoCacheManagerInitializer._();

  /// Provides global access to the [AutoCacheManagerInitializer] instance.
  static AutoCacheManagerInitializer get instance => _instance;

  /// Initializes the cache management system with optional custom configuration.
  /// This method sets up necessary bindings and applies the provided `CacheConfig`.
  ///
  /// - [config]: An optional `CacheConfig` to customize cache behavior.
  Future<void> init({CacheConfig? config}) async {
    AutoCacheManagerConfig.instance.setConfig(config);
    await AutoCacheInjections.instance.registerBinds();
  }
}
