import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String username;
  final String email;
  final String? pfp;
  final String? shoppingListId;
  final String? userPrefId;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.pfp,
    this.shoppingListId,
    this.userPrefId,
  });

  toJson() {
    return {
      "username": username,
      "email": email,
      "pfp": pfp,
      "shoppingListId": shoppingListId,
      "userPrefId": userPrefId,
    };
  }

  factory UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        username: data["username"],
        email: data["email"],
        pfp: data["pfp"],
        shoppingListId: data["shoppingListId"],
        userPrefId: data["userPrefId"]);
  }
}
