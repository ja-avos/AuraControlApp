import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsRepositoryImpl {
  final FirebaseFirestore _firestore;

  SettingsRepositoryImpl(this._firestore);

  Future<Map<String, dynamic>> fetchSettings() async {
    try {
      final snapshot =
          await _firestore.collection('settings').doc('default').get();
      return snapshot.data() ?? {};
    } catch (e) {
      rethrow;
    }
  }
}
