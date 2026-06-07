import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => {..._items};

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(
          0.0, (sum, item) => sum + (item.product.price * item.quantity));

  double get shipping => subtotal > 0 ? 0.0 : 0.0; // Giống thiết kế (Free)
  double get tax => 0.0;

  double get total => subtotal + shipping + tax;

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId); // Nếu giảm xuống 0 thì xóa khỏi giỏ hàng
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
