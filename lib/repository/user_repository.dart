import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/data_models/recipefilter_model.dart';
import '../data_models/usermodel.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar(
            "Success",
            "Your account has been created.",
            snackPosition: SnackPosition.BOTTOM,
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint("signup error$error");
    });
  }

  Future<UserModel> getUserData(String userId) async {
    final snapshot = await _db
        .collection("Users")
        .where(FieldPath.documentId, isEqualTo: userId)
        .get();
    final userData = snapshot.docs.map((e) => UserModel.fromJson(e)).single;
    return userData;
  }

  Future<String?> getUserId(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromJson(e)).single;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = userData.id!;
    await prefs.setString('userId', userId);
    return userData.id;
  }

  Future<String?> getUserName(String userId) async {
    final snapshot = await _db
        .collection("Users")
        .where(FieldPath.documentId, isEqualTo: userId)
        .get();
    final userData = snapshot.docs.map((e) => UserModel.fromJson(e)).single;

    // print("username from repo${userData.username}");
    return userData.username;
  }

  Future<String?> getUserEmail(String userId) async {
    final snapshot = await _db
        .collection("Users")
        .where(FieldPath.documentId, isEqualTo: userId)
        .get();
    final userData = snapshot.docs.map((e) => UserModel.fromJson(e)).single;

    // print("username from repo${userData.username}");
    return userData.email;
  }

  updateData(UserModel user, userId, successMessage) async {
    await _db
        .collection("Users")
        .doc(userId)
        .update(user.toJson())
        .whenComplete(
          () =>successMessage==''?null: Get.snackbar(
            "Success",
            successMessage,
            snackPosition: SnackPosition.BOTTOM,
          ),
        )
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint("signup error$error");
    });
  }

  getUserId1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    return userId;
  }

  saveUserPreferences(data) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userId = prefs.getString('userId');

    var userId = await getUserId1();
    var filtersListToString = data.join(',');

    Map<String, dynamic> idMap = {'filters': filtersListToString};
    final snapshot = await FirebaseFirestore.instance
        .collection('/Users/$userId/UserPreferences')
        .get();
    var userRepo = UserRepository();
    UserModel userdata = await userRepo.getUserData(userId);
    if (snapshot.size == 0) {
      await _db
          .collection("/Users/$userId/UserPreferences/")
          .add(idMap)
          .then((DocumentReference docId) {
            var user = UserModel(
                username: userdata.username,
                email: userdata.email,
                pfp: userdata.pfp,
                shoppingListId: userdata.shoppingListId,
                userPrefId: docId.id);
            userRepo.updateData(user, userId, "Your details have been Updated");
          })
          .whenComplete(
            () => debugPrint("success"),
          )
          .catchError((error, stackTrace) {
            debugPrint("signup error$error");
          });
    } else if (snapshot.size == 1) {
      //var tempDocId = existingDocId.getString("userPrefDocId");
      await _db
          .collection("/Users/$userId/UserPreferences/")
          .doc(userdata.userPrefId)
          .update(idMap)
          .whenComplete(
            () => debugPrint("success"),
          )
          .catchError((error, stackTrace) {
        debugPrint("signup error$error");
      });
    } else {
      print("alot");
    }
  }

  Future getUserPreferences() async {
    var userId = await getUserId1();
    var userRepo = UserRepository();
    UserModel userdata = await userRepo.getUserData(userId);
    List filters = [];
    final snapshot = await _db
        .collection("/Users/$userId/UserPreferences/")
        .where(FieldPath.documentId, isEqualTo: userdata.userPrefId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final preferences =
          RecipeFilter.fromJson(snapshot.docs[0]).toJson()['filters'];
      filters = preferences.split(',');
    }
    return filters;
  }
}
