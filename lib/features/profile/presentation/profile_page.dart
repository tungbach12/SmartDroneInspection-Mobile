import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authNotifierProvider).value;
    final locale =
        ref.watch(localeNotifierProvider).value ?? const Locale('en');
    final user = session?.user;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              key: const Key('language-selector'),
              initialValue: locale.languageCode,
              decoration: InputDecoration(labelText: context.l10n.language),
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(context.l10n.languageEnglish),
                ),
                DropdownMenuItem(
                  value: 'vi',
                  child: Text(context.l10n.languageVietnamese),
                ),
              ],
              onChanged: (languageCode) {
                if (languageCode != null) {
                  ref
                      .read(localeNotifierProvider.notifier)
                      .setLocale(Locale(languageCode));
                }
              },
            ),
            const SizedBox(height: 16),
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
                  for (final role in user.roles)
                    Chip(label: Text(localizedRole(context.l10n, role.code))),
                ],
              ),
              if (user.actorZone != null) ...[
                const SizedBox(height: 8),
                Text(
                  context.l10n.zone(
                    localizedActorZone(context.l10n, user.actorZone!.code),
                  ),
                ),
              ],
              if (user.organizationId != null) ...[
                const SizedBox(height: 8),
                Text(context.l10n.organization(user.organizationId!)),
              ],
            ] else
              Text(context.l10n.notSignedIn),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    ref.read(authNotifierProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
                label: Text(context.l10n.signOut),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
