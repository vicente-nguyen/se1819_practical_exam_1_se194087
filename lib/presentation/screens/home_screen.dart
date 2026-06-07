import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // decoration: BoxDecoration(
            //   //color: const Color(0xFF1E1E32),
            //   borderRadius: BorderRadius.circular(8),
            // ),
            child: const Icon(Icons.menu, color: Colors.white),
          ),
        ),
        title: const Text("New Arrivals", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E32),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          )
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar and Filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => productProvider.setSearchQuery(value),
                    decoration: InputDecoration(
                      hintText: "Search tech & lifestyle...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      fillColor: const Color(0xFF1E1E32),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2D2DFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: PopupMenuButton<SortOption>(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onSelected: (SortOption result) {
                      productProvider.setSortBy(result);
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                      const PopupMenuItem<SortOption>(
                        value: SortOption.nameAZ,
                        child: Text('Sort by Name (A-Z)'),
                      ),
                      const PopupMenuItem<SortOption>(
                        value: SortOption.priceLowHigh,
                        child: Text('Price: Low to High'),
                      ),
                      const PopupMenuItem<SortOption>(
                        value: SortOption.priceHighLow,
                        child: Text('Price: High to Low'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Category Filter Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: productProvider.categories.map((cat) {
                  bool isSelected = productProvider.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => productProvider.setCategory(cat),
                      selectedColor: Color(0xFF2D2DFF),
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
            // Scrollable Product List
            Expanded(
              child: ListView.builder(
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
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
                                child: Image.network(product.thumbnail, height: 180, width: double.infinity, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 8, right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                      icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                      onPressed: () => productProvider.toggleFavorite(product),
                                  ),
                                ),
                              )
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
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<CartProvider>().addToCart(product);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Added to Cart!"), duration: Duration(seconds: 1)),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2D2DFF),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
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