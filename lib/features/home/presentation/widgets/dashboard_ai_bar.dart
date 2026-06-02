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
    ref.read(assistantHandoffProvider.notifier).queue(
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Frag die KI - sofort',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            padding: const EdgeInsets.only(left: AppSpacing.md, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_listening,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (v) => _submit(v),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: _listening
                          ? 'Hoere zu ...'
                          : 'Was moechtest du wissen?',
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Foto an die KI senden',
                  onPressed: () => context.go(AppRoutes.assistant),
                  icon: Icon(Icons.add_photo_alternate_outlined,
                      color: theme.colorScheme.primary),
                ),
                IconButton(
                  tooltip: _listening ? 'Stoppen' : 'Sprechen',
                  onPressed: _toggleMic,
                  icon: Icon(
                    _listening ? Icons.stop_circle_outlined : Icons.mic_rounded,
                    color: _listening ? Colors.redAccent : theme.colorScheme.primary,
                  ),
                ),
                Material(
                  color: theme.colorScheme.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _submit(),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
