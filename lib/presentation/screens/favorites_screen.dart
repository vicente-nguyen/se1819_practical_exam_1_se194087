import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final favorites = productProvider.favoriteProducts;

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Trong thực tế, bạn có thể chuyển tab về Home ở đây nếu dùng Navigation Provider
            // Hoặc đơn giản là thông báo cho người dùng
          },
        ),
        title: const Text("My Favorites",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar for Favorites
            TextField(
              onChanged: (value) => productProvider.setFavSearchQuery(value),
              decoration: InputDecoration(
                hintText: "Search in favorites...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: const Color(0xFF1E1E32),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            // Category Filter for Favorites
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: productProvider.categories.map((cat) {
                  bool isSelected = productProvider.favSelectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => productProvider.setFavCategory(cat),
                      selectedColor: const Color(0xFF2D2DFF),
                      backgroundColor: const Color(0xFF1E1E32),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Favorites List
            Expanded(
              child: favorites.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("No favorites found!", style: TextStyle(color: Colors.grey, fontSize: 18)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final product = favorites[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetailScreen(product: product)),
                          ),
                          child: Card(
                            color: const Color(0xFF1E1E32),
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: Image.network(product.thumbnail,
                                          height: 180, width: double.infinity, fit: BoxFit.cover),
                                    ),
                                    // Positioned(
                                    //   top: 8,
                                    //   right: 8,
                                    //   child: Container(
                                    //     decoration: const BoxDecoration(
                                    //       color: Colors.black26,
                                    //       shape: BoxShape.circle,
                                    //     ),
                                    //     child: IconButton(
                                    //       icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border,
                                    //           color: Colors.red),
                                    //       onPressed: () => productProvider.toggleFavorite(product),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.title,
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                product.rating.toString(),
                                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.tags.join(", "),
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$${product.price}",
                                            style: const TextStyle(
                                              color: Color(0xFF2D2DFF),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                            onPressed: () => productProvider.toggleFavorite(product),
                                          ),
                                          // SizedBox(
                                          //   width: double.infinity,
                                          //   height: 56,
                                          //   child: ElevatedButton(
                                          //     style: ElevatedButton.styleFrom(
                                          //       backgroundColor: const Color(0xFF2D2DFF),
                                          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          //       elevation: 0,
                                          //     ),
                                          //     onPressed: () => productProvider.toggleFavorite(product),
                                          //     child: const Text(
                                          //       "Remove",
                                          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
