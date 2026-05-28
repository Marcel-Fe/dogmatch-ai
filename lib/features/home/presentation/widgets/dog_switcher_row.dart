import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/dogs/domain/dog.dart';
import 'package:dogmatch_ai/features/dogs/presentation/dogs_controller.dart';
import 'package:dogmatch_ai/features/dogs/presentation/widgets/dog_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Horizontale Avatar-Reihe der Hunde des Nutzers - Tap wechselt den
/// aktiven Hund. Plus ein Button zum Hinzufuegen.
///
/// Wird nur gezeigt, wenn der Nutzer ueberhaupt schon mindestens 1 Hund
/// angelegt hat - sonst uebernimmt der `DogHeroCard`-Empty-State.
class DogSwitcherRow extends ConsumerWidget {
  const DogSwitcherRow({
    super.key,
    required this.dogs,
    required this.activeDog,
  });

  final List<Dog> dogs;
  final Dog? activeDog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (dogs.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: dogs.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          if (i == dogs.length) {
            return _AddDogTile(theme: theme);
          }
          final d = dogs[i];
          final isActive = activeDog?.id == d.id;
          return _DogTile(
            dog: d,
            active: isActive,
            onTap: () =>
                ref.read(dogsProvider.notifier).setActive(d.id),
            theme: theme,
          );
        },
      ),
    );
  }
}

class _DogTile extends StatelessWidget {
  const _DogTile({
    required this.dog,
    required this.active,
    required this.onTap,
    required this.theme,
  });

  final Dog dog;
  final bool active;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DogAvatar(
            size: 56,
            photoBase64: dog.photoBase64,
            borderColor: active ? theme.colorScheme.primary : null,
            borderWidth: active ? 3 : 0,
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: 64,
            child: Text(
              dog.name,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddDogTile extends StatelessWidget {
  const _AddDogTile({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.addDog),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.add_rounded,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Hund',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
