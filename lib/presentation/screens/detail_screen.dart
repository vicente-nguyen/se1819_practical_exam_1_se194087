import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_provider.dart';
import '../providers/ai_provider.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    // Xóa gợi ý cũ khi vào màn hình mới
    Future.microtask(() => context.read<AIProvider>().clearSuggestion());
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    // Calculate Rating Distribution
    final Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in product.reviews) {
      if (ratingCounts.containsKey(review.rating)) {
        ratingCounts[review.rating] = ratingCounts[review.rating]! + 1;
      }
    }
    final int totalReviews = product.reviews.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C1E),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Image and Overlay Buttons
            Stack(
              children: [
                Image.network(
                  product.images,
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCircleIcon(context, Icons.arrow_back, onPressed: () => Navigator.pop(context)),
                        Row(
                          children: [
                            _buildCircleIcon(context, Icons.share_outlined),
                            const SizedBox(width: 12),
                            _buildCircleIcon(context, Icons.more_vert),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Stock Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF4D4DFF),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E32),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "In Stock",
                          style: TextStyle(color: Color(0xFF4D4DFF), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Price
                  Row(
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "\$${(product.price * 1.2).toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),
                  // Rating and Reviews
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      const Text("|", style: TextStyle(color: Colors.white24, fontSize: 20)),
                      const SizedBox(width: 16),
                      Text(
                        "$totalReviews Reviews",
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Read More",
                      style: TextStyle(color: Color(0xFF4D4DFF), fontWeight: FontWeight.bold),
                    ),
                  ),

                  // AI Recommendation Section
                  Consumer<AIProvider>(
                    builder: (context, aiProv, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E32),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 20),
                                SizedBox(width: 8),
                                Text("AI Smart Recommendation",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            aiProv.isAnalyzing
                                ? const LinearProgressIndicator(color: Colors.purpleAccent, backgroundColor: Colors.white10)
                                : Text(
                                    aiProv.aiSuggestion.isEmpty
                                        ? "Tap 'Ask AI' to get personal styling suggestions."
                                        : aiProv.aiSuggestion,
                                    style: const TextStyle(color: Colors.white70, fontSize: 14)),
                            if (aiProv.aiSuggestion.isEmpty && !aiProv.isAnalyzing)
                              TextButton(
                                onPressed: () =>
                                    context.read<AIProvider>().generateSmartSuggestion(product.title, product.category),
                                child: const Text("Ask AI Stylist", style: TextStyle(color: Colors.purpleAccent)),
                              )
                          ],
                        ),
                      );
                    },
                  ),

                  // Rating Distribution
                  const Text(
                    "Rating Distribution",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...[5, 4, 3, 2, 1].map((star) {
                    final int count = ratingCounts[star] ?? 0;
                    final double progress = totalReviews > 0 ? count / totalReviews : 0.0;
                    final String percent = totalReviews > 0 ? "${(progress * 100).toInt()}%" : "0%";
                    return _buildRatingRow(star.toString(), progress, percent);
                  }).toList(),

                  const SizedBox(height: 40),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D2DFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.read<CartProvider>().addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to Cart!"), duration: Duration(seconds: 1)),
                        );
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(BuildContext context, IconData icon, {VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed ?? () {},
      ),
    );
  }

  Widget _buildRatingRow(String label, double progress, String percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text(label, style: const TextStyle(color: Colors.grey))),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white10,
                color: const Color(0xFF2D2DFF),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 35, child: Text(percent, style: const TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }
}
