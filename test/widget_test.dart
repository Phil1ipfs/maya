// Basic Flutter widget test for the Wallet app

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maya/main.dart';

void main() {
  testWidgets('App should launch without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MayaWalletApp()));

    // Verify that the app launches (splash screen should show)
    expect(find.text('Wallet'), findsOneWidget);
    expect(find.text('Your Digital Wallet'), findsOneWidget);
  });
}
