import 'package:dogmatch_ai/app/router/app_routes.dart';
import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:dogmatch_ai/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Login-Screen mit Email/Passwort und Anonymem Login. Anonymous-Accounts
/// koennen spaeter mit einem Email-Account verknuepft werden.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isRegister = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      if (_isRegister) {
        await repo.registerWithEmail(
          email: _emailCtrl.text.trim(),
          password: _pwCtrl.text,
        );
      } else {
        await repo.signInWithEmail(
          email: _emailCtrl.text.trim(),
          password: _pwCtrl.text,
        );
      }
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      setState(() => _error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInAsGuest() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).signInAnonymously();
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      // Fallback: weiter ohne Konto - die App funktioniert auch offline.
      if (!mounted) return;
      context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _friendlyError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('email-already-in-use')) {
      return 'Diese E-Mail ist bereits registriert.';
    }
    if (s.contains('weak-password')) {
      return 'Passwort muss mindestens 6 Zeichen haben.';
    }
    if (s.contains('user-not-found') || s.contains('wrong-password') ||
        s.contains('invalid-credential')) {
      return 'E-Mail oder Passwort falsch.';
    }
    if (s.contains('network')) {
      return 'Netzwerkfehler - bist du online?';
    }
    return 'Anmeldung fehlgeschlagen.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _isRegister ? 'Konto erstellen' : 'Anmelden',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _isRegister
                      ? 'Mit Konto kannst du deine Hunde-Daten geraeteuebergreifend nutzen.'
                      : 'Melde dich an, um deine Daten zu synchronisieren - oder fahre als Gast fort.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'E-Mail',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            (v == null || !v.contains('@')) ? 'Gueltige E-Mail eingeben' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _pwCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Passwort',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (v) =>
                            (v == null || v.length < 6) ? 'Min. 6 Zeichen' : null,
                      ),
                    ],
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: _busy ? null : _submitEmail,
                  child: Text(_isRegister ? 'Registrieren' : 'Anmelden'),
                ),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() => _isRegister = !_isRegister),
                  child: Text(
                    _isRegister
                        ? 'Bereits ein Konto? Anmelden'
                        : 'Neu hier? Konto erstellen',
                  ),
                ),
                const Divider(height: AppSpacing.xl * 2),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _signInAsGuest,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Als Gast fortfahren'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
