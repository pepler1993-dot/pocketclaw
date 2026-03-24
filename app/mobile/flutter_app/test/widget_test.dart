import 'package:flutter_test/flutter_test.dart';

import 'package:pocketclaw_flutter_app/app.dart';

void main() {
  testWidgets('PocketClaw onboarding smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PocketClawApp());

    expect(find.textContaining('OpenClaw'), findsOneWidget);
    expect(find.text('Set up provider'), findsOneWidget);
  });
}
