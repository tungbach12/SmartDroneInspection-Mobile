import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/features/assets/presentation/pages/asset_detail_page.dart';
import 'package:smart_drone_inspection/features/assets/presentation/pages/assets_page.dart';
import 'package:smart_drone_inspection/features/auth/presentation/forgot_password_page.dart';
import 'package:smart_drone_inspection/features/auth/presentation/login_page.dart';
import 'package:smart_drone_inspection/features/auth/presentation/oauth_callback_screen.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/register_page.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/pages/contracts_page.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/pages/create_service_request_page.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/pages/order_chat_page.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/pages/service_request_detail_page.dart';
import 'package:smart_drone_inspection/features/dashboard/presentation/customer_dashboard_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspection_detail_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspections_page.dart';
import 'package:smart_drone_inspection/features/notifications/presentation/notifications_page.dart';
import 'package:smart_drone_inspection/features/profile/presentation/profile_page.dart';

CustomTransitionPage<void> _buildSmoothPage({
  required GoRouterState state,
  required Widget child,
  Offset beginOffset = const Offset(0, 0.03),
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 240),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
        return child;
      }
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Customer-only mobile router: auth gate + 5 bottom-nav Customer branches.
final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<Object?>(null);
  ref.listen(authNotifierProvider, (_, _) {
    refreshListenable.value = Object();
  });
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: '/home',
    errorBuilder: (context, state) => const NotFoundScreen(),
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final session = ref.read(authNotifierProvider).value;
      final location = state.matchedLocation;

      if (session == null) return null;

      final isAuthenticated =
          session.isAuthenticated && (session.user?.isCustomer ?? false);
      final publicRoute =
          location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          location.startsWith('/auth/callback');

      if (!isAuthenticated && !publicRoute) {
        return '/login';
      }
      if (isAuthenticated && publicRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          final extra = state.extra is Map
              ? Map<String, dynamic>.from(state.extra as Map)
              : const <String, dynamic>{};
          return _buildSmoothPage(
            state: state,
            beginOffset: Offset.zero,
            child: LoginPage(
              initialEmail: extra['email'] as String?,
              bannerMessage: extra['banner'] as String?,
              initialError: extra['error'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _buildSmoothPage(
          state: state,
          beginOffset: const Offset(0.05, 0),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => _buildSmoothPage(
          state: state,
          beginOffset: const Offset(0.05, 0),
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: '/auth/callback',
        builder: (context, state) => OAuthCallbackScreen(
          accessToken: state.uri.queryParameters['accessToken'],
          refreshToken: state.uri.queryParameters['refreshToken'],
          error: state.uri.queryParameters['error'],
        ),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) =>
            _buildSmoothPage(state: state, child: const NotificationsPage()),
      ),
      GoRoute(
        path: '/assets/:assetId',
        pageBuilder: (context, state) => _buildSmoothPage(
          state: state,
          child: AssetDetailPage(assetId: state.pathParameters['assetId']!),
        ),
      ),
      GoRoute(
        path: '/requests/new',
        pageBuilder: (context, state) => _buildSmoothPage(
          state: state,
          child: const CreateServiceRequestPage(),
        ),
      ),
      GoRoute(
        path: '/requests/:requestId',
        pageBuilder: (context, state) => _buildSmoothPage(
          state: state,
          child: ServiceRequestDetailPage(
            requestId: state.pathParameters['requestId']!,
          ),
        ),
      ),
      GoRoute(
        path: '/requests/:requestId/chat',
        pageBuilder: (context, state) => _buildSmoothPage(
          state: state,
          child: OrderChatPage(requestId: state.pathParameters['requestId']!),
        ),
      ),
      GoRoute(
        path: '/inspections/:inspectionId',
        pageBuilder: (context, state) {
          final tab =
              int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
          return _buildSmoothPage(
            state: state,
            child: InspectionDetailPage(
              inspectionId: state.pathParameters['inspectionId']!,
              initialTab: tab,
            ),
          );
        },
      ),
      GoRoute(
        path: '/inspections/:inspectionId/settlement',
        pageBuilder: (context, state) {
          return _buildSmoothPage(
            state: state,
            child: InspectionDetailPage(
              inspectionId: state.pathParameters['inspectionId']!,
              initialTab: 2,
            ),
          );
        },
      ),
      GoRoute(
        path: '/:inspectionId/settlement',
        redirect: (context, state) {
          final id = state.pathParameters['inspectionId']!;
          return '/inspections/$id?tab=2';
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppScaffold(shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const CustomerDashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/assets',
                builder: (context, state) => const AssetsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/requests',
                builder: (context, state) => const ContractsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inspections',
                builder: (context, state) => const InspectionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class AppScaffold extends StatelessWidget {
  const AppScaffold(this.shell, {super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            top: BorderSide(color: scheme.outlineVariant, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (index) => shell.goBranch(
            index,
            initialLocation: index == shell.currentIndex,
          ),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard_rounded),
              label: l10n.navDashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.domain_outlined),
              selectedIcon: const Icon(Icons.domain_rounded),
              label: l10n.navAssets,
            ),
            NavigationDestination(
              icon: const Icon(Icons.assignment_outlined),
              selectedIcon: const Icon(Icons.assignment_rounded),
              label: l10n.navRequests,
            ),
            NavigationDestination(
              icon: const Icon(Icons.flight_takeoff_outlined),
              selectedIcon: const Icon(Icons.flight_takeoff_rounded),
              label: l10n.navInspections,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: l10n.navAccount,
            ),
          ],
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notFound)),
      body: Center(child: Text(context.l10n.pageNotFound)),
    );
  }
}
