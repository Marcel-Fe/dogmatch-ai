import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/features/assistant/presentation/assistant_screen.dart';
import 'package:dogmatch_ai/features/auth/presentation/login_screen.dart';
import 'package:dogmatch_ai/features/breeders/presentation/breeder_finder_screen.dart';
import 'package:dogmatch_ai/features/breeders/presentation/breeder_profile_screen.dart';
import 'package:dogmatch_ai/features/breeders/presentation/breeding_knowledge_screen.dart';
import 'package:dogmatch_ai/features/breeders/presentation/fci_standards_screen.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_detail_screen.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_list_screen.dart';
import 'package:dogmatch_ai/features/breeds/presentation/mix_breed_screen.dart';
import 'package:dogmatch_ai/features/clubs/clubs_screen.dart';
import 'package:dogmatch_ai/features/forms/presentation/forms_screen.dart';
import 'package:dogmatch_ai/features/treats/presentation/treats_screen.dart';
import 'package:dogmatch_ai/features/dogs/presentation/add_edit_dog_screen.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dog_record_screen.dart';
import 'package:dogmatch_ai/features/dogs/presentation/manage_dogs_screen.dart';
import 'package:dogmatch_ai/features/favorites/presentation/favorites_screen.dart';
import 'package:dogmatch_ai/features/documents/presentation/documents_screen.dart';
import 'package:dogmatch_ai/features/health/presentation/add_health_event_screen.dart';
import 'package:dogmatch_ai/features/health/presentation/health_calendar_screen.dart';
import 'package:dogmatch_ai/features/home/presentation/home_screen.dart';
import 'package:dogmatch_ai/features/knowledge/presentation/article_screen.dart'
    deferred as article_screen;
import 'package:dogmatch_ai/features/knowledge/presentation/knowledge_screen.dart'
    deferred as knowledge_screen;
import 'package:dogmatch_ai/features/matching/presentation/match_results_screen.dart';
import 'package:dogmatch_ai/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dogmatch_ai/features/places/presentation/nearby_screen.dart';
import 'package:dogmatch_ai/features/onboarding/presentation/splash_screen.dart';
import 'package:dogmatch_ai/features/premium/presentation/premium_screen.dart';
import 'package:dogmatch_ai/features/profile/presentation/edit_profile_screen.dart';
import 'package:dogmatch_ai/features/profile/presentation/profile_screen.dart';
import 'package:dogmatch_ai/features/profile/presentation/settings_screen.dart';
import 'package:dogmatch_ai/features/behavior_check/presentation/behavior_check_screen.dart';
import 'package:dogmatch_ai/features/checklists/presentation/checklist_detail_screen.dart';
import 'package:dogmatch_ai/features/checklists/presentation/checklists_screen.dart';
import 'package:dogmatch_ai/features/legal/presentation/legal_doc_screen.dart';
import 'package:dogmatch_ai/features/legal/presentation/legal_screen.dart';
import 'package:dogmatch_ai/features/quiz/presentation/quiz_screen.dart';
import 'package:dogmatch_ai/features/tips/presentation/tips_screen.dart'
    deferred as tips_screen;
import 'package:dogmatch_ai/features/vacation/presentation/vacation_screen.dart'
    deferred as vacation_screen;
import 'package:dogmatch_ai/features/symptom_check/presentation/symptom_check_screen.dart';
import 'package:dogmatch_ai/features/training/presentation/training_detail_screen.dart';
import 'package:dogmatch_ai/features/training/presentation/training_screen.dart';
import 'package:dogmatch_ai/core/widgets/deferred_screen.dart';
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
      path: AppRoutes.breedList,
      builder: (context, state) => const BreedListScreen(),
    ),
    GoRoute(
      path: AppRoutes.mixBreed,
      builder: (context, state) => const MixBreedScreen(),
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
      builder: (context, state) => DeferredScreen(
        load: knowledge_screen.loadLibrary,
        builder: (_) => knowledge_screen.KnowledgeScreen(),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.article}/:id',
      builder: (context, state) => DeferredScreen(
        load: article_screen.loadLibrary,
        builder: (_) =>
            article_screen.ArticleScreen(articleId: state.pathParameters['id']!),
      ),
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
      path: AppRoutes.dogRecord,
      builder: (context, state) => const DogRecordScreen(),
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
      path: AppRoutes.nearby,
      builder: (context, state) => const NearbyScreen(),
    ),
    GoRoute(
      path: AppRoutes.behaviorCheck,
      builder: (context, state) => const BehaviorCheckScreen(),
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
      path: AppRoutes.tips,
      builder: (context, state) => DeferredScreen(
        load: tips_screen.loadLibrary,
        builder: (_) => tips_screen.TipsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.treats,
      builder: (context, state) => const TreatsScreen(),
    ),
    GoRoute(
      path: AppRoutes.clubs,
      builder: (context, state) => const ClubsScreen(),
    ),
    GoRoute(
      path: AppRoutes.checklists,
      builder: (context, state) => const ChecklistsScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.checklists}/:id',
      builder: (context, state) =>
          ChecklistDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.vacation,
      builder: (context, state) => DeferredScreen(
        load: vacation_screen.loadLibrary,
        builder: (_) => vacation_screen.VacationScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forms,
      builder: (context, state) => const FormsScreen(),
    ),
    GoRoute(
      path: AppRoutes.legal,
      builder: (context, state) => const LegalScreen(),
    ),
    GoRoute(
      path: AppRoutes.imprint,
      builder: (context, state) =>
          const LegalDocScreen(doc: LegalDoc.imprint),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      builder: (context, state) =>
          const LegalDocScreen(doc: LegalDoc.privacy),
    ),
    GoRoute(
      path: AppRoutes.terms,
      builder: (context, state) =>
          const LegalDocScreen(doc: LegalDoc.terms),
    ),
    GoRoute(
      path: AppRoutes.disclaimer,
      builder: (context, state) =>
          const LegalDocScreen(doc: LegalDoc.disclaimer),
    ),
    GoRoute(
      path: AppRoutes.breederFinder,
      builder: (context, state) => const BreederFinderScreen(),
    ),
    GoRoute(
      path: AppRoutes.fciStandards,
      builder: (context, state) => const FciStandardsScreen(),
    ),
    GoRoute(
      path: AppRoutes.breedingKnowledge,
      builder: (context, state) => const BreedingKnowledgeScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.breederProfile}/:id',
      builder: (context, state) =>
          BreederProfileScreen(breederId: state.pathParameters['id']!),
    ),
  ],
);
