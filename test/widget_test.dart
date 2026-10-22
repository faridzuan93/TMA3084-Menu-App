import 'package:flutter_test/flutter_test.dart';
import 'package:tma3084_menu_app/main.dart';

void main() {
  testWidgets('Bean & Bloom menu loads successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BeanAndBloomApp());

    expect(find.text('Iced Latte'), findsOneWidget);
    expect(find.text('Iced Matcha'), findsOneWidget);
    expect(find.text('Cappuccino'), findsOneWidget);
  });
}
