import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/features/assistant/presentation/assistant_screen.dart';
import 'package:dogmatch_ai/features/auth/presentation/login_screen.dart';
import 'package:dogmatch_ai/features/breeders/presentation/breeder_finder_screen.dart';
import 'package:dogmatch_ai/features/breeders/presentation/breeder_profile_screen.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_detail_screen.dart';
import 'package:dogmatch_ai/features/dogs/presentation/add_edit_dog_screen.dart';
import 'package:dogmatch_ai/features/dogs/presentation/manage_dogs_screen.dart';
import 'package:dogmatch_ai/features/favorites/presentation/favorites_screen.dart';
import 'package:dogmatch_ai/features/documents/presentation/documents_screen.dart';
import 'package:dogmatch_ai/features/health/presentation/add_health_event_screen.dart';
import 'package:dogmatch_ai/features/health/presentation/health_calendar_screen.dart';
import 'package:dogmatch_ai/features/home/presentation/home_screen.dart';
import 'package:dogmatch_ai/features/knowledge/presentation/article_screen.dart';
import 'package:dogmatch_ai/features/knowledge/presentation/knowledge_screen.dart';
import 'package:dogmatch_ai/features/matching/presentation/match_results_screen.dart';
import 'package:dogmatch_ai/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dogmatch_ai/features/onboarding/presentation/splash_screen.dart';
import 'package:dogmatch_ai/features/premium/presentation/premium_screen.dart';
import 'package:dogmatch_ai/features/profile/presentation/edit_profile_screen.dart';
import 'package:dogmatch_ai/features/profile/presentation/profile_screen.dart';
import 'package:dogmatch_ai/features/profile/presentation/settings_screen.dart';
import 'package:dogmatch_ai/features/quiz/presentation/quiz_screen.dart';
import 'package:dogmatch_ai/features/symptom_check/presentation/symptom_check_screen.dart';
import 'package:dogmatch_ai/features/training/presentation/training_detail_screen.dart';
import 'package:dogmatch_ai/features/training/presentation/training_screen.dart';
import 'package:dogmatch_ai/shared/navigation/scaffold_with_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// go_router-Konfiguration der App.
///
/// Die fuenf Haupt-Tabs liegen in einer [StatefulShellRoute] - jeder Tab
/// behaelt seinen eigenen Navigationsstack. Vollbild-Seiten (Splash, Login,
/// Detailseiten) liegen darueber auf der Root-Ebene.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNav(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.quiz,
              builder: (context, state) => const QuizScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.assistant,
              builder: (context, state) => const AssistantScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '${AppRoutes.breedDetail}/:id',
      builder: (context, state) =>
          BreedDetailScreen(breedId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.matchResults,
      builder: (context, state) => const MatchResultsScreen(),
    ),
    GoRoute(
      path: AppRoutes.knowledge,
      builder: (context, state) => const KnowledgeScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.article}/:id',
      builder: (context, state) =>
          ArticleScreen(articleId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.premium,
      builder: (context, state) => const PremiumScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.manageDogs,
      builder: (context, state) => const ManageDogsScreen(),
    ),
    GoRoute(
      path: AppRoutes.addDog,
      builder: (context, state) => const AddEditDogScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.editDog}/:id',
      builder: (context, state) =>
          AddEditDogScreen(dogId: state.pathParameters['id']),
    ),
    GoRoute(
      path: AppRoutes.healthCalendar,
      builder: (context, state) => const HealthCalendarScreen(),
    ),
    GoRoute(
      path: AppRoutes.addHealthEvent,
      builder: (context, state) => const AddHealthEventScreen(),
    ),
    GoRoute(
      path: AppRoutes.documents,
      builder: (context, state) => const DocumentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.symptomCheck,
      builder: (context, state) => const SymptomCheckScreen(),
    ),
    GoRoute(
      path: AppRoutes.training,
      builder: (context, state) => const TrainingScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.training}/:id',
      builder: (context, state) =>
          TrainingDetailScreen(planId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.breederFinder,
      builder: (context, state) => const BreederFinderScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.breederProfile}/:id',
      builder: (context, state) =>
          BreederProfileScreen(breederId: state.pathParameters['id']!),
    ),
  ],
);
