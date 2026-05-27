import 'package:dogmatch_ai/core/enums/country.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/core/widgets/error_view.dart';
import 'package:dogmatch_ai/core/widgets/loading_view.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_insurance.dart';
import 'package:dogmatch_ai/features/breeds/domain/country_breed_info.dart';
import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:dogmatch_ai/features/breeds/presentation/breed_providers.dart';
import 'package:dogmatch_ai/features/breeds/presentation/widgets/rating_bar.dart';
import 'package:dogmatch_ai/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:dogmatch_ai/features/profile/presentation/user_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Rassenprofil. Laedt die Rasse ueber [breedByIdProvider] und stellt
/// Steckbrief, Bewertungen, Eigenschaften und Gesundheitsthemen dar.
class BreedDetailScreen extends ConsumerWidget {
  const BreedDetailScreen({super.key, required this.breedId});

  final String breedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedAsync = ref.watch(breedByIdProvider(breedId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rassenprofil'),
        actions: [FavoriteButton(breedId: breedId)],
      ),
      body: breedAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'Rasse konnte nicht geladen werden.',
          onRetry: () => ref.invalidate(breedByIdProvider(breedId)),
        ),
        data: (breed) => _BreedDetailContent(breed: breed),
      ),
    );
  }
}

class _BreedDetailContent extends ConsumerWidget {
  const _BreedDetailContent({required this.breed});

  final DogBreed breed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prefs = ref.watch(userPreferencesProvider).value;
    final defaultCountry = prefs?.country ?? Country.germany;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _BreedHeroImage(breed: breed),
        const SizedBox(height: AppSpacing.lg),
        Text(breed.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 2),
        Text(
          'Herkunft: ${breed.origin}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(breed.temperament, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(breed.description, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xl),

        const _SectionTitle('Auf einen Blick'),
        const SizedBox(height: AppSpacing.sm),
        _FactRow(label: 'Groesse', value: breed.size.label),
        _FactRow(
          label: 'Gewicht',
          value:
              '${_fmtKg(breed.weightKgMin)} - ${_fmtKg(breed.weightKgMax)} kg',
        ),
        _FactRow(label: 'Energielevel', value: breed.energyLevel.label),
        _FactRow(
          label: 'Lebenserwartung',
          value: '${breed.lifeExpectancyYears} Jahre',
        ),
        _FactRow(
          label: 'Kosten',
          value: 'ca. ${breed.monthlyCostEur} EUR/Monat',
        ),
        if (breed.dailyExerciseHours != null)
          _FactRow(
            label: 'Bewegung pro Tag',
            value: '${breed.dailyExerciseHours} h',
          ),
        if (breed.coatType != null)
          _FactRow(label: 'Fell', value: breed.coatType!),
        if (breed.fciGroup != null)
          _FactRow(label: 'FCI-Gruppe', value: breed.fciGroup!),
        if (breed.idealOwner != null)
          _FactRow(label: 'Idealer Halter', value: breed.idealOwner!),
        if (breed.apartmentSuitable != null)
          _FactRow(
            label: 'Wohnungstauglich',
            value: breed.apartmentSuitable! ? 'Ja' : 'Eingeschraenkt',
          ),
        if (breed.goodWithCats != null)
          _FactRow(
            label: 'Mit Katzen',
            value: breed.goodWithCats! ? 'Vertraegt sich' : 'Eher schwierig',
          ),
        if (breed.noiseLevel != null)
          _FactRow(
            label: 'Bell-Neigung',
            value: '${breed.noiseLevel}/5',
          ),
        const SizedBox(height: AppSpacing.xl),

        if (breed.typicalTasks.isNotEmpty) ...[
          const _SectionTitle('Typische Aufgaben'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final t in breed.typicalTasks) _Chip(text: t),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        _CountryInfoSection(
          countryInfo: breed.countryInfo,
          initialCountry: defaultCountry,
        ),
        const SizedBox(height: AppSpacing.xl),

        const _SectionTitle('Steckbrief'),
        const SizedBox(height: AppSpacing.sm),
        RatingBar(
          label: 'Anfaengerfreundlich',
          value: breed.beginnerFriendliness,
        ),
        RatingBar(label: 'Kinderfreundlich', value: breed.childFriendliness),
        RatingBar(label: 'Trainierbarkeit', value: breed.trainability),
        RatingBar(label: 'Bewegungsbedarf', value: breed.exerciseNeed),
        RatingBar(label: 'Pflegeaufwand', value: breed.grooming),
        RatingBar(label: 'Fellverlust', value: breed.shedding),
        const SizedBox(height: AppSpacing.xl),

        const _SectionTitle('Typische Eigenschaften'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [for (final trait in breed.traits) _Chip(text: trait)],
        ),
        const SizedBox(height: AppSpacing.xl),

        const _SectionTitle('Moegliche Gesundheitsthemen'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final issue in breed.commonHealthIssues) _Chip(text: issue),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        _CostSection(breed: breed),
        const SizedBox(height: AppSpacing.xl),

        if (breed.insurance != null) ...[
          _InsuranceSection(insurance: breed.insurance!),
          const SizedBox(height: AppSpacing.xl),
        ],

        if (breed.careTips.isNotEmpty) ...[
          const _SectionTitle('Pflege & Halterung'),
          const SizedBox(height: AppSpacing.sm),
          for (final tip in breed.careTips)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(tip, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  String _fmtKg(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }
}

/// Sektion "In deinem Land": zeigt Listenhund-/Reise-/Klima-Hinweise fuer
/// das im Profil gespeicherte Land an. Per Dropdown kann der Nutzer
/// ad-hoc ein anderes Land vergleichen.
class _CountryInfoSection extends StatefulWidget {
  const _CountryInfoSection({
    required this.countryInfo,
    required this.initialCountry,
  });

  final Map<String, CountryBreedInfo> countryInfo;
  final Country initialCountry;

  @override
  State<_CountryInfoSection> createState() => _CountryInfoSectionState();
}

class _CountryInfoSectionState extends State<_CountryInfoSection> {
  late Country _selected = widget.initialCountry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = widget.countryInfo[_selected.code];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.public_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'In deinem Land',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              DropdownButton<Country>(
                value: _selected,
                isDense: true,
                underline: const SizedBox.shrink(),
                onChanged: (next) {
                  if (next != null) setState(() => _selected = next);
                },
                items: [
                  for (final c in Country.values)
                    DropdownMenuItem(value: c, child: Text(c.label)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (info == null || info.isEmpty)
            Text(
              'Noch keine landesspezifischen Infos hinterlegt.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else ...[
            if (info.listenhundStatus != null &&
                info.listenhundStatus!.trim().isNotEmpty)
              _CountryInfoRow(
                icon: Icons.gavel_rounded,
                label: 'Listenhund-Status',
                value: info.listenhundStatus!,
              ),
            if (info.travelNotes != null &&
                info.travelNotes!.trim().isNotEmpty)
              _CountryInfoRow(
                icon: Icons.flight_rounded,
                label: 'Reise & Einreise',
                value: info.travelNotes!,
              ),
            if (info.climateNotes != null &&
                info.climateNotes!.trim().isNotEmpty)
              _CountryInfoRow(
                icon: Icons.thermostat_rounded,
                label: 'Klima',
                value: info.climateNotes!,
              ),
          ],
        ],
      ),
    );
  }
}

class _CountryInfoRow extends StatelessWidget {
  const _CountryInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Header-Bild der Rasse - Bundle-Asset bevorzugt, sonst URL, sonst Icon.
class _BreedHeroImage extends StatelessWidget {
  const _BreedHeroImage({required this.breed});

  final DogBreed breed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(AppSpacing.radiusMd);

    Widget fallback() => Container(
          height: 200,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: radius,
          ),
          child: Icon(
            Icons.pets_rounded,
            size: 64,
            color: theme.colorScheme.primary,
          ),
        );

    Widget? imageChild;
    if (breed.imageAsset != null && breed.imageAsset!.isNotEmpty) {
      imageChild = Image.asset(
        breed.imageAsset!,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => fallback(),
      );
    } else if (breed.imageUrl != null && breed.imageUrl!.isNotEmpty) {
      imageChild = Image.network(
        breed.imageUrl!,
        fit: BoxFit.contain,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, _, _) => fallback(),
      );
    }

    // Hintergrund-Container damit BoxFit.contain keinen weissen Rand zeigt -
    // der Hund bleibt vollstaendig sichtbar (Kopf + Pfoten).
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: 260,
        width: double.infinity,
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        child: imageChild ?? fallback(),
      ),
    );
  }
}

/// Sektion "Was kostet dieser Hund?" - Anschaffung, Futter, Tierarzt.
class _CostSection extends StatelessWidget {
  const _CostSection({required this.breed});

  final DogBreed breed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthlyFood = breed.dailyFoodCostEur != null
        ? (breed.dailyFoodCostEur! * 30).round()
        : null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.euro_rounded,
                  size: 20, color: theme.colorScheme.tertiary),
              const SizedBox(width: AppSpacing.sm),
              Text('Was kostet dieser Hund?',
                  style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (breed.acquisitionCostEurMin != null &&
              breed.acquisitionCostEurMax != null)
            _FactRow(
              label: 'Anschaffung (Züchter)',
              value:
                  '${breed.acquisitionCostEurMin} - ${breed.acquisitionCostEurMax} EUR einmalig',
            ),
          if (monthlyFood != null)
            _FactRow(
              label: 'Futter pro Monat',
              value:
                  '~$monthlyFood EUR (${breed.dailyFoodCostEur!.toStringAsFixed(2)} EUR/Tag)',
            ),
          if (breed.vetCostPerYearEur != null)
            _FactRow(
              label: 'Tierarzt-Routine/Jahr',
              value:
                  '~${breed.vetCostPerYearEur} EUR (Impfung, Check-Up, Wurmkur)',
            ),
          _FactRow(
            label: 'Laufende Kosten gesamt',
            value: 'ca. ${breed.monthlyCostEur} EUR/Monat',
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Richtwerte - tatsächliche Kosten variieren je nach Region, Vorerkrankungen und Lebensstil.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sektion "Versicherung" - Haftpflicht/Krankenvers./OP-Schutz Richtwerte.
class _InsuranceSection extends StatelessWidget {
  const _InsuranceSection({required this.insurance});

  final BreedInsurance insurance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined,
                  size: 20, color: theme.colorScheme.secondary),
              const SizedBox(width: AppSpacing.sm),
              Text('Versicherung', style: theme.textTheme.titleMedium),
              if (insurance.listenhundSurcharge) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Text(
                    'Listenhund-Aufschlag',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InsuranceRow(
            title: 'Haftpflicht',
            subtitle: 'Schaeden am Eigentum oder an anderen - in vielen DE-Bundeslaendern Pflicht.',
            range:
                '${insurance.liabilityMonthlyMin} - ${insurance.liabilityMonthlyMax} EUR/Monat',
          ),
          _InsuranceRow(
            title: 'Kranken-Vollvers.',
            subtitle: 'Übernimmt Routine + Behandlungen inkl. chronische Therapie.',
            range:
                '${insurance.healthMonthlyMin} - ${insurance.healthMonthlyMax} EUR/Monat',
          ),
          _InsuranceRow(
            title: 'OP-Schutz allein',
            subtitle: 'Deckt nur Operationen + Nachbehandlung. Günstiger als Vollvers.',
            range:
                '${insurance.opMonthlyMin} - ${insurance.opMonthlyMax} EUR/Monat',
          ),
          if (insurance.notes != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: theme.colorScheme.secondary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      insurance.notes!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Richtwerte ohne Anbieter-Empfehlung. Tarife stark abhängig von Wohnort, Alter und Vorerkrankungen - immer mehrere Angebote vergleichen.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsuranceRow extends StatelessWidget {
  const _InsuranceRow({
    required this.title,
    required this.subtitle,
    required this.range,
  });

  final String title;
  final String subtitle;
  final String range;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              Text(range,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          Text(subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              )),
        ],
      ),
    );
  }
}
