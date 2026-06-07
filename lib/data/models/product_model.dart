import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.rating,
    required super.thumbnail,
    required super.category,
    required super.tags,
    required super.images,
    required super.reviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      category: json['category'] ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      images: (json['images'] as List?)?.isNotEmpty == true ? json['images'][0] : (json['thumbnail'] ?? ''),
      reviews: (json['reviews'] as List?)
              ?.map((r) => ReviewModel.fromJson(r))
              .toList() ??
          [],
    );
  }
}

class ReviewModel extends Review {
  ReviewModel({
    required super.rating,
    required super.comment,
    required super.date,
    required super.reviewerName,
    required super.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      reviewerEmail: json['reviewerEmail'] ?? '',
    );
  }
}