import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practicalExam1/main.dart';
import 'package:practicalExam1/data/datasources/product_remote_data_source.dart';
import 'package:practicalExam1/data/repositories/product_repository_impl.dart';
import 'package:practicalExam1/presentation/providers/product_provider.dart';
import 'package:practicalExam1/presentation/providers/cart_provider.dart';
import 'package:practicalExam1/presentation/providers/ai_provider.dart';

void main() {
  testWidgets('Full App Smoke Test', (WidgetTester tester) async {
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
        child: const MyApp(),
      ),
    );

    // Verify Home Screen is shown
    expect(find.text('New Arrivals'), findsOneWidget);

    // Verify Bottom Navigation exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorite'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
  });
}
