// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final int? id;
  final String name;
  final String? description;
  final int price;
  final int stock;
  final String category;
  final String? image;
  final bool isBestSeller;
  final bool isSync;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.image,
    this.isBestSeller = false,
    this.isSync = true,
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
        isBestSeller: json["is_best_seller"] == 1 ? true : false,
        isSync: true,
      );

  factory Product.fromLocalMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        category: json["category"],
        image: json["image"] ?? '',
        isBestSeller: json["is_best_seller"] == 1 ? true : false,
        isSync: true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        "image": image,
        "is_best_seller": isBestSeller ? 1 : 0,
      };

  Map<String, dynamic> toLocalMap() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "category": category,
        "image": image,
        "is_best_seller": isBestSeller ? 1 : 0,
      };

  Product copyWith({
    int? id,
    String? name,
    String? description,
    int? price,
    int? stock,
    String? category,
    String? image,
    bool? isBestSeller,
    bool? isSync,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      image: image ?? this.image,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isSync: isSync ?? this.isSync,
    );
  }
}
