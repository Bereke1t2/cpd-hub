import 'package:flutter_test/flutter_test.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/main.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Verify the app scaffold renders something.
    await tester.pump();
    expect(find.byType(MyApp), findsOneWidget);
  });
}
