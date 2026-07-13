import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

/// Handles reading and writing the `users` collection in Cloud Firestore.
/// Each document is keyed by the Firebase Auth UID, per the task
/// requirement of storing name + email after signup.
class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUserProfile(AppUser user) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  /// One-time fetch of the saved profile (used right after login/signup).
  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  /// Live stream so the Profile screen updates in real time if the
  /// document changes (e.g. edited from the Firebase console).
  Stream<AppUser?> streamUserProfile(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return AppUser.fromMap(uid, doc.data()!);
    });
  }

  Future<void> updateName(String uid, String name) async {
    await _users.doc(uid).update({'name': name});
  }
}
