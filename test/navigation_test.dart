import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practicalExam1/presentation/screens/main_navigation.dart';
import 'package:practicalExam1/presentation/providers/cart_provider.dart';
import 'package:practicalExam1/presentation/providers/product_provider.dart';
import 'package:practicalExam1/presentation/providers/ai_provider.dart';
import 'package:practicalExam1/data/repositories/product_repository_impl.dart';
import 'package:practicalExam1/data/datasources/product_remote_data_source.dart';

void main() {
  testWidgets('Bottom Navigation Tabs Test', (WidgetTester tester) async {
    final remoteDataSource = ProductRemoteDataSource();
    final productRepository = ProductRepositoryImpl(remoteDataSource: remoteDataSource);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider(repository: productRepository),
          ),
          ChangeNotifierProvider<CartProvider>(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider<AIProvider>(
            create: (_) => AIProvider(),
          ),
        ],
        child: const MaterialApp(
          home: MainNavigation(),
        ),
      ),
    );

    // 1. Check Initial State (Home)
    expect(find.text("New Arrivals"), findsOneWidget);

    // 2. Navigate to Favorites
    final favoriteTab = find.byIcon(Icons.favorite);
    await tester.tap(favoriteTab);
    await tester.pumpAndSettle();
    expect(find.text("My Favorites"), findsOneWidget);

    // 3. Navigate to Cart
    final cartTab = find.byIcon(Icons.shopping_cart);
    await tester.tap(cartTab);
    await tester.pumpAndSettle();
    expect(find.text("Your Cart"), findsOneWidget);

    // 4. Back to Home
    final homeTab = find.byIcon(Icons.home);
    await tester.tap(homeTab);
    await tester.pumpAndSettle();
    expect(find.text("New Arrivals"), findsOneWidget);
  });
}
