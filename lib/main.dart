import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Data Layer
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';

// Import Domain Layer
import 'domain/repositories/product_repository.dart';

// Import Presentation Layer (Providers & Screens)
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/ai_provider.dart';
import 'presentation/screens/main_navigation.dart';

void main() {
  // 1. Khởi tạo các lớp dữ liệu hạ tầng (Dependencies Setup)
  final remoteDataSource = ProductRemoteDataSource();
  final productRepository = ProductRepositoryImpl(remoteDataSource: remoteDataSource);

  // 2. Chạy ứng dụng và nạp các Provider vào cây Widget
  runApp(
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce UI App',
      debugShowCheckedModeBanner: false,

      // Cấu hình Dark Theme đồng bộ toàn bộ Text, Appbar, Scaffolds
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0C0C1E),
        primaryColor: Colors.blueAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        useMaterial3: true,
      ),

      // Màn hình khởi đầu có chứa Bottom Navigation Bar để điều hướng 4 màn hình
      home: const MainNavigation(),
    );
  }
}