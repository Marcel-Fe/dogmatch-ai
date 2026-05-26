import 'dart:convert';
import 'dart:io';

import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Alle Rassen in breeds.json parsen sauber', () {
    final file = File('assets/data/breeds.json');
    final raw = file.readAsStringSync();
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final failed = <(String, Object)>[];
    for (final j in list) {
      try {
        DogBreed.fromJson(j);
      } catch (e) {
        failed.add((j['id']?.toString() ?? 'unknown', e));
      }
    }
    if (failed.isNotEmpty) {
      // Print errors so we see them in test output.
      for (final (id, err) in failed) {
        // ignore: avoid_print
        print('FAIL $id: $err');
      }
    }
    expect(failed, isEmpty, reason: '${failed.length} Rassen failen beim Parsen');
    expect(list.length, greaterThan(200));
  });
}
