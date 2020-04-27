import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toys/models/review.dart';

class Product{
  int productId, discount, price, quantity, productRating;
  String title, description, thumbnailImage, adminId;
  Timestamp timestamp;
  List<Review> reviews;
  List<dynamic> previewImages;
  int stock;
  Product({this.productId, this.title, this.description, this.discount, this.quantity, this.thumbnailImage, this.price, this.adminId, this.previewImages, this.stock, this.productRating, this.timestamp, this.reviews});
  factory Product.fromDocument(DocumentSnapshot doc){
    return Product(
      productId: doc.data['productId'],
      title: doc.data['title'],
      productRating: doc.data['productRating'],
      timestamp: doc.data['timestamp'],
      description: doc.data['description'],
      discount: doc.data['discount'],
      quantity: doc.data['quantity'],
      thumbnailImage: doc.data['thumbnailImage'],
      price: doc.data['price'],
      adminId: doc.data['adminId'],
      previewImages: doc.data['previewImages'],
      stock: doc.data['stock'],
      reviews: doc.data['reviews']
    );
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["productId"] = this.productId ?? '';
    map["title"] = this.title ?? '';
    map["description"] = this.description ?? '';
    map["stock"] = this.stock ?? 0;
    map["productRating"] = this.productRating ?? 0;
    map["discount"] = this.discount ?? 0;
    map["reviews"] = this.reviews ?? [];
    map["price"] = this.price ?? 100;
    map["previewImages"] = this.previewImages ?? [];
    map["thumbnailImage"] = this.thumbnailImage ?? {};
    return map;
  }
}