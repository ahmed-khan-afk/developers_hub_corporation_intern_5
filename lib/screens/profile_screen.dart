import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final User firebaseUser;

  const ProfileScreen({super.key, required this.firebaseUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: _isSigningOut
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout_rounded),
            onPressed: _isSigningOut
                ? null
                : () async {
                    setState(() => _isSigningOut = true);
                    await _authService.signOut();
                  },
          ),
        ],
      ),
      body: StreamBuilder<AppUser?>(
        // Live Firestore stream - Task requirement: "retrieve and
        // display the saved data" in real time.
        stream: _firestoreService.streamUserProfile(widget.firebaseUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorState(message: snapshot.error.toString());
          }

          final user = snapshot.data;
          final name = user?.name.isNotEmpty == true
              ? user!.name
              : (widget.firebaseUser.email?.split('@').first ?? 'User');
          final email = user?.email ?? widget.firebaseUser.email ?? '—';
          final initials = name.trim().isNotEmpty
              ? name.trim()[0].toUpperCase()
              : 'U';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 20),
                Text(name, style: Theme.of(context).textTheme.headlineMedium)
                    .animate()
                    .fadeIn(delay: 100.ms),
                const SizedBox(height: 4),
                Text(email, style: Theme.of(context).textTheme.bodyMedium)
                    .animate()
                    .fadeIn(delay: 150.ms),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Account details',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'Full name',
                          value: name,
                        ),
                        const Divider(height: 28),
                        _InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email address',
                          value: email,
                        ),
                        const Divider(height: 28),
                        _InfoRow(
                          icon: Icons.verified_user_outlined,
                          label: 'User ID',
                          value: widget.firebaseUser.uid,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 48),
            const SizedBox(height: 12),
            Text(
              'Could not load profile data.\n$message',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
