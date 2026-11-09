import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_2415051076_i_kadek_agus_dwi_adnyana/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('Selamat Datang di CafeFinder'), findsOneWidget);
  });
}
