import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
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
              if (user.hasRole(UserRole.inspector)) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilot License',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (user.pilotLicenseNumber != null &&
                            user.pilotLicenseNumber!.isNotEmpty) ...[
                          Text(
                            'License: ${user.pilotLicenseNumber} (${user.pilotLicenseClass ?? "Standard"})',
                          ),
                          if (user.pilotLicenseExpiresAt != null)
                            Text(
                              'Expires: ${user.pilotLicenseExpiresAt!.split("T").first}',
                            ),
                          const SizedBox(height: 12),
                        ] else ...[
                          const Text('No pilot license declared yet.'),
                          const SizedBox(height: 12),
                        ],
                        FilledButton.tonal(
                          key: const Key('update-pilot-license-btn'),
                          onPressed: () =>
                              _showPilotLicenseDialog(context, ref, user),
                          child: Text(
                            user.pilotLicenseNumber != null
                                ? 'Update Pilot License'
                                : 'Declare Pilot License',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ] else
              Text(context.l10n.notSignedIn),
            const SizedBox(height: 32),
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

  void _showPilotLicenseDialog(
    BuildContext context,
    WidgetRef ref,
    AuthUser user,
  ) {
    final numberController = TextEditingController(
      text: user.pilotLicenseNumber ?? '',
    );
    final classController = TextEditingController(
      text: user.pilotLicenseClass ?? 'CLASS_A',
    );
    DateTime selectedExpiry = user.pilotLicenseExpiresAt != null
        ? DateTime.tryParse(user.pilotLicenseExpiresAt!) ??
            DateTime.now().add(const Duration(days: 365))
        : DateTime.now().add(const Duration(days: 365));

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Declare Pilot License'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      key: const Key('pilot-license-number-field'),
                      controller: numberController,
                      decoration: const InputDecoration(
                        labelText: 'License Number',
                        hintText: 'e.g. PL-12345',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('pilot-license-class-field'),
                      controller: classController,
                      decoration: const InputDecoration(
                        labelText: 'License Class',
                        hintText: 'e.g. CLASS_A',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Expires At'),
                      subtitle: Text(
                        '${selectedExpiry.year}-${selectedExpiry.month.toString().padLeft(2, "0")}-${selectedExpiry.day.toString().padLeft(2, "0")}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedExpiry,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 3650),
                          ),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedExpiry = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  key: const Key('save-pilot-license-btn'),
                  onPressed: () async {
                    final number = numberController.text.trim();
                    if (number.isEmpty) return;
                    final licenseClass = classController.text.trim().isEmpty
                        ? 'CLASS_A'
                        : classController.text.trim();

                    Navigator.of(dialogContext).pop();
                    final result = await ref
                        .read(authNotifierProvider.notifier)
                        .updatePilotLicense(
                          licenseNumber: number,
                          licenseClass: licenseClass,
                          expiresAt: selectedExpiry,
                        );
                    if (!context.mounted) return;
                    if (result is ApiSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilot license updated successfully.'),
                        ),
                      );
                    } else if (result is ApiError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update pilot license.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
