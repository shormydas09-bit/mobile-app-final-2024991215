import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_explorer/main.dart';

void main() {
  testWidgets('Recipe Explorer app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeExplorerApp());

    expect(find.text('Recipe Explorer'), findsOneWidget);
  });
}
