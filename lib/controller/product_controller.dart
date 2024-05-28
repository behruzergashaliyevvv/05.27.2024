import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uyishi/models/product.dart';

class ProductController {
  List<Product> products = [];

  Future<void> getProducts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/company/products'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      products = jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/company/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      products.add(product);
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(int index, Product product) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/company/products/${products[index].id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      products[index] = product;
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int index) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/company/products/${products[index].id}'),
    );

    if (response.statusCode == 200) {
      products.removeAt(index);
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
