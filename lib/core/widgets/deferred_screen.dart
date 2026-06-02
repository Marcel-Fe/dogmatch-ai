import 'package:flutter/material.dart';

/// Laedt eine selten genutzte Seite erst beim Oeffnen nach (deferred /
/// "lazy"). So muss ihr Code nicht beim App-Start mitgeladen werden, was
/// die erste Anzeige der App beschleunigt.
///
/// [load] ist die `loadLibrary`-Funktion des deferred-Imports, [builder]
/// baut den Screen, sobald der Code da ist. Waehrend des kurzen Nachladens
/// zeigt sich ein Spinner.
class DeferredScreen extends StatefulWidget {
  const DeferredScreen({
    super.key,
    required this.load,
    required this.builder,
  });

  final Future<void> Function() load;
  final WidgetBuilder builder;

  @override
  State<DeferredScreen> createState() => _DeferredScreenState();
}

class _DeferredScreenState extends State<DeferredScreen> {
  late final Future<void> _future = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Diese Seite konnte nicht geladen werden. Bitte pruefe '
                  'deine Internet-Verbindung und versuche es erneut.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return widget.builder(context);
      },
    );
  }
}
