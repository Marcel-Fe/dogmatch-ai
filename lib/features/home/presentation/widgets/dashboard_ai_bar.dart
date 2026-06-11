import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_colors.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/data/stt_service.dart';
import 'package:dogmatch_ai/features/assistant/domain/chat_mode.dart';
import 'package:dogmatch_ai/features/assistant/presentation/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Prominente KI-Eingabeleiste oben im Dashboard - "frag sofort, wie bei
/// ChatGPT". Tippen, diktieren oder Foto-Hinweis; beim Absenden wird die
/// Frage an den KI-Berater-Tab uebergeben (Handoff) und dort beantwortet.
class DashboardAiBar extends ConsumerStatefulWidget {
  const DashboardAiBar({super.key});

  @override
  ConsumerState<DashboardAiBar> createState() => _DashboardAiBarState();
}

class _DashboardAiBarState extends ConsumerState<DashboardAiBar> {
  final _controller = TextEditingController();
  final _stt = SttService();
  bool _listening = false;

  @override
  void dispose() {
    _stt.stop();
    _controller.dispose();
    super.dispose();
  }

  void _submit([String? raw]) {
    final text = (raw ?? _controller.text).trim();
    if (text.isEmpty) {
      // Ohne Text einfach den KI-Berater oeffnen.
      context.go(AppRoutes.assistant);
      return;
    }
    // Frage vormerken und zum KI-Berater springen - dort wird sie
    // automatisch abgeschickt (gleicher Mechanismus wie Verhalten-Check).
    ref
        .read(assistantHandoffProvider.notifier)
        .queue(
          AssistantHandoff(
            prompt: text,
            mode: ChatMode.advisor,
            origin: AppRoutes.home,
          ),
        );
    _controller.clear();
    context.go(AppRoutes.assistant);
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      _stt.stop();
      setState(() => _listening = false);
      return;
    }
    if (!_stt.isAvailable) {
      final msg = _stt.isIosSafari
          ? 'Apple unterstuetzt Sprach-Eingabe im iPhone-Safari nicht. '
                'Bitte tippe deine Frage - die KI-Antwort funktioniert trotzdem.'
          : 'Sprach-Eingabe ist in diesem Browser nicht unterstuetzt '
                '(Chrome / Edge nutzen).';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
      );
      return;
    }
    setState(() => _listening = true);
    try {
      final text = await _stt.listenOnce(
        // Live mitschreiben, damit man beim Sprechen sofort Text sieht.
        onPartial: (partial) {
          if (!mounted) return;
          _controller.text = partial;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: partial.length),
          );
        },
      );
      if (!mounted) return;
      if (text != null && text.trim().isNotEmpty) {
        // Direkt absenden - "sprechen -> KI antwortet".
        _submit(text);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    // Dezente, schlanke Eingabeleiste im Horizon-Stil: weisse Karte mit
    // weichem Schatten, kleines Akzent-Badge, ein Eingabefeld - bewusst
    // zurueckhaltend, damit das Hundebild darueber im Mittelpunkt bleibt.
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded, color: accent, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !_listening,
              textInputAction: TextInputAction.send,
              onSubmitted: (v) => _submit(v),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: _listening ? 'Hoere zu ...' : 'Frag die KI ...',
              ),
            ),
          ),
          IconButton(
            tooltip: 'Foto an die KI senden',
            visualDensity: VisualDensity.compact,
            onPressed: () => context.go(AppRoutes.assistant),
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          IconButton(
            tooltip: _listening ? 'Stoppen' : 'Sprechen',
            visualDensity: VisualDensity.compact,
            onPressed: _toggleMic,
            icon: Icon(
              _listening ? Icons.stop_circle_outlined : Icons.mic_rounded,
              color: _listening
                  ? Colors.redAccent
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 2),
          Material(
            color: accent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _submit(),
              child: const Padding(
                padding: EdgeInsets.all(7),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
