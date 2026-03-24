import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pocketclaw_flutter_app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PocketClaw onboarding smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const PocketClawApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('OpenClaw'), findsOneWidget);
    expect(find.text('Connection setup'), findsOneWidget);
  });
}
