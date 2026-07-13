/// Simple model representing the user document stored in Cloud Firestore
/// under the `users/{uid}` collection.
class AppUser {
  final String uid;
  final String name;
  final String email;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.createdAt,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }
}
