import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> saveUserDetails(String uid, String name, String email) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to save user details: $e');
    }
  }

  Future<bool> getShowDiscountedPrice() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero
        ),
      );
      await _remoteConfig.fetchAndActivate();
      return _remoteConfig.getBool('show_discounted_price');
    } catch (e) {
      throw Exception('Failed to get remote config: $e');
    }
  }
}
