import 'dart:io';

import 'package:flutter/foundation.dart';

import 'exceptions/directory_provider_exceptions.dart';
import 'path_provider/path_provider_service.dart';
import 'states/directory_provider_state.dart';

/// An interface for a service that provides access to specific directories.
abstract class IDirectoryProviderService {
  /// Gets the directory for storing preference files.
  Directory get prefsDirectory;

  /// Gets the directory for storing SQL database files.
  Directory get sqlDirectory;

  /// Initializes and loads cache directories. This should set up `prefsDirectory`
  /// and `sqlDirectory` with the correct paths.
  Future<void> getCacheDirectories();
}

/// A concrete implementation of `IDirectoryProviderService` that manages
/// the retrieval of application document and support directories.
class DirectoryProviderService extends ValueNotifier<DirectoryProviderState> implements IDirectoryProviderService {
  /// The service used to access the path provider's functionality.
  final IPathProviderService _service;

  /// Constructs a [DirectoryProviderService] which uses the given [_service]
  /// to fetch directory paths.
  ///
  /// Initializes the state with an empty [DirectoryProviderState].
  DirectoryProviderService(this._service) : super(DirectoryProviderState.empty());

  @override
  Directory get prefsDirectory => this.value.applicationDocumentsDirectory;

  @override
  Directory get sqlDirectory => this.value.applicationSupportDirectory;

  @override
  Future<void> getCacheDirectories() async {
    try {
      ///Early return if directories are already loaded.
      if (this.value.isLoaded) return;

      ///Fetch the application document and support directories.
      final applicationDocumentsDirectory = await _service.getApplicationDocumentsDirectory();
      final applicationSupportDirectory = await _service.getApplicationSupportDirectory();

      ///Update the state with the fetched directories.
      this.value = LoadedDirectoryProviderState(
        applicationDocumentsDirectory: applicationDocumentsDirectory,
        applicationSupportDirectory: applicationSupportDirectory,
      );
    } catch (e, stackTrace) {
      throw DirectoryProviderException(
        message: 'Failed do load directories',
        stackTrace: stackTrace,
      );
    }
  }

  @visibleForTesting
  void reset() => this.value = DirectoryProviderState.empty();
}
