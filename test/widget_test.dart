import 'package:flutter_test/flutter_test.dart';

import 'package:feel/app/app.dart';
import 'package:feel/app/bootstrap/app_bootstrap_controller.dart';

void main() {
  testWidgets('shows splash then onboarding on first launch', (
    WidgetTester tester,
  ) async {
    final bootstrap = AppBootstrapController();

    await tester.pumpWidget(BibleApp(bootstrap: bootstrap));

    expect(find.text('Bible App V1'), findsOneWidget);
    expect(
      find.text(
        'Calm, guest-first scripture reading with a modern cozy shell.',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();

    expect(find.text('Start with a calmer daily Bible rhythm'), findsOneWidget);
    expect(find.text('Start onboarding'), findsOneWidget);
  });

  testWidgets('goes to Today tab after onboarding is already completed', (
    WidgetTester tester,
  ) async {
    final bootstrap = AppBootstrapController()..completeOnboarding();

    await tester.pumpWidget(BibleApp(bootstrap: bootstrap));

    expect(find.text('Bible App V1'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Your daily verse home is ready'), findsOneWidget);
  });
}
