import '../../domain/entities/data_cache_entity.dart';
import 'enums/invalidation_types_adapter.dart';

/// A utility class responsible for serializing and deserializing cache entities to and from JSON.
///
/// The [CacheAdapter] provides methods that facilitate converting cache data to a JSON format
/// and reconstructing entities back from the JSON structure. It also handles type mapping and
/// invalidation type conversions.
class DataCacheAdapter {
  /// Deserializes a JSON map into a [DataCacheEntity] of type [T].
  ///
  /// This method creates a new [DataCacheEntity] from the given JSON structure, converting the values
  /// and applying the appropriate invalidation type.
  ///
  /// - Parameter [json]: A `Map<String, dynamic>` representing the JSON structure of a cache entity.
  ///
  /// - Returns: A fully constructed [DataCacheEntity] of type [T] based on the provided JSON data.
  static DataCacheEntity<T> fromJson<T extends Object>(Map<String, dynamic> json) {
    return DataCacheEntity<T>(
      id: json['id'],
      data: json['data'],
      invalidationType: InvalidationTypesAdapter.fromKey(json['invalidation_type']),
      createdAt: DateTime.parse(json['created_at']),
      endAt: DateTime.parse(json['end_at']),
    );
  }

  /// Deserializes a JSON map into a list-based [DataCacheEntity] of type [T], where the list contains elements of type [DataType].
  ///
  /// This method specifically reconstructs cache entities containing lists of data items,
  /// converting and filtering based on the provided data type.
  ///
  /// - Parameter [json]: A `Map<String, dynamic>` representing the JSON structure of a list-based cache entity.
  ///
  /// - Returns: A [DataCacheEntity] of type [T], containing a list of data elements of type [DataType].
  static DataCacheEntity<T> listFromJson<T extends Object, DataType extends Object>(Map<String, dynamic> json) {
    return DataCacheEntity<T>(
      id: json['id'],
      data: List.from(json['data']).whereType<DataType>().toList() as T,
      invalidationType: InvalidationTypesAdapter.fromKey(json['invalidation_type']),
      createdAt: DateTime.parse(json['created_at']),
      endAt: DateTime.parse(json['end_at']),
    );
  }

  /// Serializes a [DataCacheEntity] of type [T] into a JSON map.
  ///
  /// This method converts the specified cache entity into a JSON-compatible structure, including
  /// appropriate key-value pairs for serialization and storage.
  ///
  /// - Parameter [cache]: The [DataCacheEntity] instance to be serialized into JSON.
  ///
  /// - Returns: A `Map<String, dynamic>` containing the serialized form of the given cache entity.
  static Map<String, dynamic> toJson<T extends Object>(DataCacheEntity<T> cache) {
    return {
      'id': cache.id,
      'data': cache.data,
      'invalidation_type': InvalidationTypesAdapter.toKey(cache.invalidationType),
      'created_at': cache.createdAt.toIso8601String(),
      'end_at': cache.endAt.toIso8601String(),
    };
  }
}
