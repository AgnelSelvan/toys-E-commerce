import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toys/models/review.dart';

class User {
  String uid, username, email, photoUrl, loginType, role;
  Map<String, dynamic> deliveryAddress;
  List<String> cartProducts;
  List<String> boughtProducts;
  List<Review> reviews;

  User(
      {this.uid,
      this.username,
      this.email,
      this.deliveryAddress,
      this.cartProducts,
      this.photoUrl,
      this.loginType,
      this.role,
      this.reviews,
      this.boughtProducts});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid ?? '',
      'name': username ?? '',
      'email': email ?? '',
      'photoUrl': photoUrl ?? '',
      'deliveryAddress': deliveryAddress ??
          {'address': '', 'pincode': '', 'state': '', 'city': ''},
      'cartProducts': cartProducts ?? [],
      'role': 'user',
      'review': reviews ?? [],
      'boughtProducts': boughtProducts ?? [],
    };
  }

  factory User.fromMap(Map snapshot) {
    snapshot = snapshot ?? {};
    return User(
        photoUrl: snapshot['photoUrl'],
        username: snapshot["username"],
        email: snapshot["email"],
        role: snapshot['role'],
        deliveryAddress: snapshot["deliveryAddress"],
        cartProducts: snapshot["cartProducts"],
        boughtProducts: snapshot["boughtProducts"],
        reviews: snapshot["reviews"]);
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
        username: data["username"] ?? '',
        email: data["email"] ?? '',
        role: data['role'],
        photoUrl: data['photoUrl'],
        deliveryAddress: data["deliveryAddress"] ?? '',
        cartProducts: data["cartProducts"] ?? [],
        boughtProducts: data["boughtProducts"] ?? [],
        reviews: data["reviews"] ?? 0);
  }
}
