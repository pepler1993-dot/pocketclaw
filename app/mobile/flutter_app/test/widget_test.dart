import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pocketclaw_flutter_app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PocketClaw onboarding smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'pc_onboarding_done': false,
    });

    await tester.pumpWidget(const PocketClawApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.textContaining('in your pocket'), findsOneWidget);
    expect(find.text('Connection setup'), findsOneWidget);
  });
}
