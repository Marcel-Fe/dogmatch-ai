import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/assistant/data/stt_service.dart';
import 'package:flutter/material.dart';

/// Eingabeleiste fuer den Chat: Textfeld + Mikrofon + Senden.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.isEnabled = true,
    this.hintText = 'Frag den KI-Berater ...',
  });

  final void Function(String text) onSend;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sprach-Eingabe ist in diesem Browser nicht unterstuetzt '
            '(Chrome/Edge nutzen).',
          ),
        ),
      );
      return;
    }
    setState(() => _listening = true);
    try {
      final text = await _stt.listenOnce();
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
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            tooltip: micActive ? 'Aufnahme stoppen' : 'Sprach-Eingabe',
            onPressed: widget.isEnabled ? _toggleMic : null,
            icon: Icon(
              micActive ? Icons.stop_circle_outlined : Icons.mic_rounded,
              color: micActive ? Colors.redAccent : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
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
