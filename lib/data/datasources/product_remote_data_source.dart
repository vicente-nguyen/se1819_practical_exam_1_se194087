import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final String _apiUrl = "https://dummyjson.com/products";

  Future<List<ProductModel>> fetchProductsFromApi() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List productsJson = data['products'];

        // Chuyển đổi List JSON thành List ProductModel
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("Server returned error code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to connect to Remote Data Source: $e");
    }
  }
}