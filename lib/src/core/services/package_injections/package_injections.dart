import 'package:shared_preferences/shared_preferences.dart';

import '../../../modules/cache/infra/datasources/i_key_value_storage_datasource.dart';
import '../kvs/shared_preferences/shared_preferences_kvs_service.dart';
import 'injector.dart';

class PackageInjections {
  static Future<void> registerBinds() async {
    await Injector.instance.asyncBind(SharedPreferences.getInstance);

    Injector.instance.bindSingleton<IKeyValueStorageDatasource>(
      SharedPreferencesKeyValueStorageService(
        Injector.instance.get<SharedPreferences>(),
      ),
    );
  }
}
