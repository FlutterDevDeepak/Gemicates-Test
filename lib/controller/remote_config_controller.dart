import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RemoteConfigController extends ChangeNotifier {
  final Ref ref;
  RemoteConfigController(this.ref);
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _showDiscountedPrice = false;

  bool get showDiscountedPrice => _showDiscountedPrice;

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _remoteConfig.fetchAndActivate();
      _showDiscountedPrice = _remoteConfig.getBool('show_discounted_price');
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Remote Config: $e');
      }
    }
  }
}

final remoteConfigController = ChangeNotifierProvider((ref) => RemoteConfigController(ref));
