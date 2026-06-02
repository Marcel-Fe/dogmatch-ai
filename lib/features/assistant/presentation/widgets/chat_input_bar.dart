import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/data/stt_service.dart';
import 'package:flutter/material.dart';

/// Eingabeleiste fuer den Chat: Textfeld + Mikrofon + Senden + optional
/// Bild-Anhang.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.onPickImage,
    this.hasPendingImage = false,
    this.isEnabled = true,
    this.hintText = 'Frag den KI-Berater ...',
  });

  final void Function(String text) onSend;

  /// Wird gerufen, wenn der Plus-Button gedrueckt wird (Bild auswaehlen).
  /// Wenn null, wird der Plus-Button nicht angezeigt.
  final VoidCallback? onPickImage;

  /// True, wenn aktuell ein Bild zum Versand ausgewaehlt ist - Plus-Button
  /// wird hervorgehoben.
  final bool hasPendingImage;

  final bool isEnabled;
  final String hintText;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _stt = SttService();
  bool _listening = false;

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
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
        // Waehrend des Sprechens den erkannten Text live anzeigen, damit
        // es nicht "haengt", bis man stoppt.
        onPartial: (partial) {
          if (!mounted) return;
          _controller.text = partial;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: partial.length),
          );
        },
      );
      if (!mounted) return;
      if (text != null && text.isNotEmpty) {
        _controller.text = text;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _listening = false);
    }
  }

  @override
  void dispose() {
    _stt.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final micActive = _listening;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          if (widget.onPickImage != null) ...[
            IconButton(
              tooltip: widget.hasPendingImage
                  ? 'Bild angehaengt - erneut tippen fuer Wechsel'
                  : 'Bild anhaengen (zum Analysieren)',
              onPressed: widget.isEnabled ? widget.onPickImage : null,
              icon: Icon(
                widget.hasPendingImage
                    ? Icons.image_rounded
                    : Icons.add_photo_alternate_outlined,
                color: widget.hasPendingImage
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.isEnabled && !_listening,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: widget.isEnabled ? (_) => _send() : null,
              decoration: InputDecoration(
                hintText: _listening ? 'Hoere zu...' : widget.hintText,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 12,
                ),
                // Mikrofon liegt INNEN im Textfeld - so kann es nicht mehr
                // mit dem Senden-Button verwechselt werden.
                suffixIcon: IconButton(
                  tooltip: micActive ? 'Aufnahme stoppen' : 'Sprach-Eingabe',
                  onPressed: widget.isEnabled ? _toggleMic : null,
                  icon: Icon(
                    micActive
                        ? Icons.stop_circle_outlined
                        : Icons.mic_rounded,
                    color: micActive
                        ? Colors.redAccent
                        : theme.colorScheme.primary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Klarer Abstand zwischen Eingabefeld und Senden-Knopf.
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: widget.isEnabled && !_listening ? _send : null,
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              minimumSize: const Size(48, 48),
            ),
            child: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
