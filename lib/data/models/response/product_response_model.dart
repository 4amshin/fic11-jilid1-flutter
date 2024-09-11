import 'dart:convert';

class ProductResponseModel {
  final List<Product> data;

  ProductResponseModel({
    required this.data,
  });

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        data: List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Product {
  final int id;
  final String name;
  final String? description;
  final String price;
  final int stock;
  final String category;
  final String? image;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"] ?? '',
        price: json["price"],
        stock: json["stock"],
        category: json["category"],
        image: json["image"] ?? '',
      );

  factory Product.fromLocalMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        category: json["category"],
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        "image": image,
      };

  Map<String, dynamic> toLocalMap() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "category": category,
        "image": image,
      };
}
