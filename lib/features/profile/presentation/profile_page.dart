import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/theme/app_theme.dart';
import 'package:smart_drone_inspection/core/theme/theme_mode_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';
import 'package:smart_drone_inspection/shared/widgets/motion_primitives.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _busy = false;

  Future<void> _showChangePasswordDialog() async {
    final l10n = context.l10n;
    final formKey = GlobalKey<FormState>();
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    final submitted = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.changePassword),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: l10n.currentPassword),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: newCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.newPasswordRequirement,
                  ),
                  validator: (v) => (v == null || v.length < 15)
                      ? l10n.minimum15Characters
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.confirmNewPassword,
                  ),
                  validator: (v) =>
                      v != newCtrl.text ? l10n.passwordsDoNotMatch : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    final currentPassword = currentCtrl.text;
    final newPassword = newCtrl.text;
    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();

    if (submitted != true || !mounted) return;
    setState(() => _busy = true);
    final res = await ref
        .read(authNotifierProvider.notifier)
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    if (!mounted) return;
    setState(() => _busy = false);

    switch (res) {
      case ApiSuccess():
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.passwordChangedSuccess)));
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeAuthFailure(context, failure))),
        );
    }
  }

  Future<void> _confirmLogoutAll() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutAllDevices),
        content: Text(l10n.logoutAllConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    final res = await ref.read(authNotifierProvider.notifier).logoutAll();
    if (!mounted) return;
    setState(() => _busy = false);
    if (res case ApiError(:final failure)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(describeAuthFailure(context, failure))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = ref.watch(authNotifierProvider).value;
    final locale =
        ref.watch(localeNotifierProvider).value ?? const Locale('en');
    final themeMode =
        ref.watch(themeModeNotifierProvider).value ?? ThemeMode.light;
    final user = session?.user;

    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            MotionEntrance(
              offset: const Offset(0, 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF172554), scheme.surface]
                        : [const Color(0xFFEFF6FF), scheme.surface],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: scheme.outlineVariant),
                  boxShadow: AppTheme.cardShadow(context),
                ),
                padding: const EdgeInsets.all(18),
                child: user == null
                    ? Text(l10n.notSignedIn)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.brandActionGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    user.fullName.isNotEmpty
                                        ? user.fullName[0].toUpperCase()
                                        : 'C',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      user.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              for (final role in user.roles)
                                StatusPill(
                                  label: localizedRole(l10n, role.code),
                                  tone: StatusTone.primary,
                                  showDot: true,
                                ),
                            ],
                          ),
                          if (user.phoneNumber != null &&
                              user.phoneNumber!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: 15,
                                  color: scheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user.phoneNumber!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                          if (user.organizationId != null &&
                              user.organizationId!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.apartment_rounded,
                                  size: 15,
                                  color: scheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    l10n.organizationLabel(
                                      user.organizationId!,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 14),

            MotionEntrance(
              delay: const Duration(milliseconds: 50),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.preferencesSection,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        key: const Key('language-selector'),
                        initialValue: locale.languageCode,
                        decoration: InputDecoration(
                          labelText: l10n.language,
                          prefixIcon: const Icon(
                            Icons.translate_rounded,
                            size: 20,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(l10n.languageEnglish),
                          ),
                          DropdownMenuItem(
                            value: 'vi',
                            child: Text(l10n.languageVietnamese),
                          ),
                        ],
                        onChanged: (code) {
                          if (code != null) {
                            ref
                                .read(localeNotifierProvider.notifier)
                                .setLocale(Locale(code));
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<ThemeMode>(
                        key: const Key('theme-mode-selector'),
                        initialValue: themeMode,
                        decoration: InputDecoration(
                          labelText: l10n.themeModeLabel,
                          prefixIcon: const Icon(
                            Icons.palette_outlined,
                            size: 20,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text(l10n.themeSystem),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(l10n.themeLight),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(l10n.themeDark),
                          ),
                        ],
                        onChanged: (mode) {
                          if (mode != null) {
                            ref
                                .read(themeModeNotifierProvider.notifier)
                                .setThemeMode(mode);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            MotionEntrance(
              delay: const Duration(milliseconds: 90),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                      child: Text(
                        l10n.securitySection,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ListTile(
                      leading: const LeadingGlyphBadge(
                        icon: Icons.lock_reset_rounded,
                        tone: StatusTone.primary,
                        size: 36,
                      ),
                      title: Text(l10n.changePassword),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _busy ? null : _showChangePasswordDialog,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const LeadingGlyphBadge(
                        icon: Icons.devices_other_rounded,
                        tone: StatusTone.warning,
                        size: 36,
                      ),
                      title: Text(l10n.logoutAllDevices),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _busy ? null : _confirmLogoutAll,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            MotionEntrance(
              delay: const Duration(milliseconds: 120),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('sign-out-btn'),
                  onPressed: _busy
                      ? null
                      : () => ref.read(authNotifierProvider.notifier).logout(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                    side: BorderSide(
                      color: scheme.error.withValues(alpha: 0.35),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(l10n.signOut),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
