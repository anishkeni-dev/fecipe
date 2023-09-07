import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fecipe/commons/days_and_mealTimes.dart';
import 'package:fecipe/data_models/meal_plan_model.dart';
import 'package:fecipe/repository/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

class MealPlanRepository extends GetxController {
  static MealPlanRepository get instance => Get.find();

  //Pointing the application to the database
  final _db = FirebaseFirestore.instance;
  // final _mealPlanList = AsyncMemoizer();
  ApiRepository apiRepo = ApiRepository();

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    return userId;
  }

  scheduleMeal(
      {required String day,
      required String mealTime,
      required String recipeID,
      required String recipeTitle}) async {
    var userId = await getUserId();

    final snapshot =
        await _db.collection('/Users/$userId/MealPlan/$day/$mealTime').get();

    if (snapshot.size == 0) {
      Map<String, dynamic> idMap = {
        'id': [recipeID]
      };

      await _db
          .collection("/Users/$userId/MealPlan/$day/$mealTime/")
          .doc('id')
          .set(idMap)
          .whenComplete(
            () => Get.snackbar(
              "Success",
              "$recipeTitle was scheduled successfully.",
              snackPosition: SnackPosition.BOTTOM,
            ),
          )
          .catchError((error, stackTrace) {
        Get.snackbar(
          "Error",
          "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
        );
        debugPrint("Schedule Meal Error: $error");
      });
    } else if (snapshot.size == 1) {
      final mealTimeSnapshot =
          _db.collection("/Users/$userId/MealPlan/$day/$mealTime").doc('id');

      await mealTimeSnapshot
          .update({
            "id": FieldValue.arrayUnion([recipeID]),
          })
          .whenComplete(
            () => Get.snackbar(
              "Success",
              "$recipeTitle was scheduled successfully.",
              snackPosition: SnackPosition.BOTTOM,
            ),
          )
          .catchError((error, stackTrace) {
            Get.snackbar(
              "Error",
              "Something went wrong. Try again",
              snackPosition: SnackPosition.BOTTOM,
            );
            debugPrint("Schedule Meal Error: $error");
          });
    }
  }

  unscheduleMeal(
      {required String day,
      required String mealTime,
      required String recipeID,
      required String recipeTitle}) async {
    var userId = await getUserId();

    final snapshot =
        _db.collection('/Users/$userId/MealPlan/$day/$mealTime').doc('id');

    await snapshot
        .update({
          "id": FieldValue.arrayRemove([recipeID]),
        })
        .whenComplete(
          () => Get.snackbar(
            "Success",
            "$recipeTitle was unscheduled successfully.",
            snackPosition: SnackPosition.BOTTOM,
          ),
        )
        .catchError((error, stackTrace) {
          Get.snackbar(
            "Error",
            "Something went wrong. Try again",
            snackPosition: SnackPosition.BOTTOM,
          );
          debugPrint("Unschedule Meal Error: $error");
        });
  }

  Future<Map<String, List<dynamic>>> getIdLists({required String day}) async {
    Map<String, List<dynamic>> idLists = {};
    var userId = await getUserId();

    for (String mealTime in mealTimes) {
      final snapshot = await _db
          .collection('/Users/$userId/MealPlan/$day/$mealTime')
          .doc('id')
          .get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        List<dynamic> value =
            data?['id']; // <-- The value you want to retrieve.
        idLists[mealTime] = value;
      } else {
        idLists[mealTime] = [];
      }
    }
    debugPrint(idLists.toString());

    return idLists;
  }

  getMealPlans({required List<dynamic> idList}) async {
    // return _mealPlanList.runOnce(() {
    debugPrint('getMealPlans() called');
    List<MealPlanItemModel> mealTimePlans = [];

    for (var id in idList) {
      final response = await http.get(
          Uri.parse(
              '${apiRepo.url}${id.toString()}/information?includeNutrition=true'),
          headers: apiRepo.api);
      // debugPrint(response.body);
      final responseJson = jsonDecode(response.body);
      MealPlanItemModel temp = MealPlanItemModel.fromJson(responseJson);
      if (temp.id != 0) {
        temp.printMealPlanItem();
        mealTimePlans.add(temp);
      } else {
        break;
      }
    }
    return mealTimePlans;
    // }
    // );
  }
}
