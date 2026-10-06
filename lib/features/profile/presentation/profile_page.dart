import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authNotifierProvider).value;
    final user = session?.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              Text(
                user.fullName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(user.email),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final role in user.roles) Chip(label: Text(role.code)),
                ],
              ),
              if (user.actorZone != null) ...[
                const SizedBox(height: 8),
                Text('Zone: ${user.actorZone!.code}'),
              ],
              if (user.organizationId != null) ...[
                const SizedBox(height: 8),
                Text('Org: ${user.organizationId}'),
              ],
            ] else
              const Text('Not signed in.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => ref
                    .read(authNotifierProvider.notifier)
                    .logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
