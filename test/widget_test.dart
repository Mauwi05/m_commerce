import 'package:flutter_test/flutter_test.dart';

import 'package:m_commers/main.dart';

void main() {
  testWidgets('MCommerceApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MCommerceApp());

    expect(find.text('Firebase conectado correctamente'), findsOneWidget);
  });
}
