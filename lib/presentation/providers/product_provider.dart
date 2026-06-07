import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

enum SortOption { nameAZ, priceLowHigh, priceHighLow }

class ProductProvider with ChangeNotifier {
  final ProductRepository repository;

  List<Product> _products = [];
  bool _isLoading = false;
  String _selectedCategory = "All";
  SortOption _sortBy = SortOption.nameAZ;
  String _searchQuery = "";
  String _favSearchQuery = "";
  String _favSelectedCategory = "All";

  ProductProvider({required this.repository});

  List<Product> get products {
    return _filterAndSort(_products, _selectedCategory, _searchQuery);
  }

  List<Product> get favoriteProducts {
    final favorites = _products.where((p) => p.isFavorite).toList();
    return _filterAndSort(favorites, _favSelectedCategory, _favSearchQuery);
  }

  List<Product> _filterAndSort(List<Product> list, String category, String query) {
    List<Product> filtered = list;

    // Filter by Category
    if (category != "All") {
      filtered = filtered.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    // Filter by Search Query
    if (query.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.description.toLowerCase().contains(query.toLowerCase()) ||
              p.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }

    // Sort
    List<Product> sorted = [...filtered];
    switch (_sortBy) {
      case SortOption.nameAZ:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.priceLowHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    return sorted;
  }

  List<String> get categories {
    final allCategories = _products.map((p) => p.category).toSet().toList();
    allCategories.sort();
    return ["All", ...allCategories];
  }

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get favSelectedCategory => _favSelectedCategory;
  SortOption get sortBy => _sortBy;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await repository.getProducts();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(Product product) {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setFavCategory(String category) {
    _favSelectedCategory = category;
    notifyListeners();
  }

  void setSortBy(SortOption option) {
    _sortBy = option;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFavSearchQuery(String query) {
    _favSearchQuery = query;
    notifyListeners();
  }
}
