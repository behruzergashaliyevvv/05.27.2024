import 'package:json_annotation/json_annotation.dart';

part "product.g.dart";

@JsonSerializable()
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool inStock;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
