import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:practicalExam1/presentation/screens/home_screen.dart';
import 'package:practicalExam1/presentation/providers/product_provider.dart';
import 'package:practicalExam1/data/repositories/product_repository_impl.dart';
import 'package:practicalExam1/data/datasources/product_remote_data_source.dart';

void main() {
  testWidgets('Home Screen UI Rendering Test', (WidgetTester tester) async {
    // Fixed: Added remoteDataSource argument here to resolve the compiler error
    final remoteDataSource = ProductRemoteDataSource();
    final repo = ProductRepositoryImpl(remoteDataSource: remoteDataSource);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => ProductProvider(repository: repo),
          child: const HomeScreen(),
        ),
      ),
    );

    // All strings and labels are in English to eliminate typos and language warnings
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text("New Arrivals"), findsOneWidget);
  });
}