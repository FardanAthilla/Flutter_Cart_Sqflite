import 'dart:typed_data';

class CartModel {
  int? id;
  Uint8List? image;
  double? price;
  String? title,description;

  CartModel({
   this.id , this.image, this.price, this.title, this.description
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      image: json['image'],
      price: json['price'],
      title: json['title'],
      description: json['description'],
    );
  }
}