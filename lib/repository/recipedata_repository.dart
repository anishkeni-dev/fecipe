import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../data_models/carousel_model.dart';
import '../data_models/recipefilter_model.dart';
import '/data_models/ingredient_info_model.dart';
import '/data_models/fetchbyid_model.dart';
import '/data_models/recipe_info_model.dart';
import '/repository/api.dart';
import '/repository/user_repository.dart';
import '../data_models/recipe_complexsearch_model.dart';
import '../data_models/usermodel.dart';

class RecipeDataRepository extends GetxController {
  final _shoppingListFromDb = AsyncMemoizer();
  final _recipeIngredients = AsyncMemoizer();
  final _shoppingList = AsyncMemoizer();
  final _recipeSteps = AsyncMemoizer();
  final _favouritesList = AsyncMemoizer();
  ApiRepository apiRepo = ApiRepository();
  UserRepository userRepo = UserRepository();

  late var _jsonData;
  final _db = FirebaseFirestore.instance;
  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    return userId;
  }

  getCarouselData() async {
    final String file =
        await rootBundle.loadString('asset/json/carousel_data.json');
    final data = await json.decode(file);
    List<CarouselData> responseList = [];
    for (var i = 0; i < data["Slides"].length; i++) {
      CarouselData tempData = CarouselData.fromJson(data["Slides"][i]);
      responseList.add(tempData);
    }

    return responseList;
  }

  Future getMealsListBySearch(String mealType, String searchValue, type, isPreferences) async {
    print("getting new data");
    var url = '${apiRepo.url}complexSearch';
    if (searchValue.isNotEmpty) {
      url = '$url?query=$searchValue&type=$mealType';
      print("looking for: $url");
    } else {
      url = '$url?query=$mealType';
    }

    if (isPreferences) {
      List filters = [];
      List userPreferences = await userRepo.getUserPreferences();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var searchFilters = prefs.getString('searchFilters');
      filters = searchFilters.toString().split(',');

      if (filters.isEmpty) {
        if (userPreferences.isNotEmpty) {
          String diet = userPreferences[0];
          url = '$url&diet=$diet';
          print("looking for: $url");
        }
      } else {
        String diet = filters[0];
        url = '$url&diet=$diet';
        print("looking for: $url");
      }
    }
    if (type == 'popular') {
      url = '$url&tags=$type';
    }

    final response = await http.get(Uri.parse(url), headers: apiRepo.api);
    final responseJson = jsonDecode(response.body);
    List<ComplexSearchModel> recipeResponse = [];
    try {
      for (var i = 0; i < responseJson['results'].length; i++) {
        var temp = ComplexSearchModel.fromJson(responseJson['results'][i]);

        recipeResponse.add(temp);
      }

    } catch (err) {
      Get.snackbar(
        "Error",
        responseJson['message'],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return recipeResponse;
  }

  Future fetchRecipeInfo(String id) async {
    final response = await http.get(
        Uri.parse('${apiRepo.url}$id/information?includeNutrition=true'),
        headers: apiRepo.api);
    final responseJson = jsonDecode(response.body);

    var temp = RecipeInformation.fromJson(responseJson);
    return temp;
  }

  Future fetchRecipeSteps(String id) async {
    return _recipeSteps.runOnce(() async {
      List<RecipeStep> steps = [];

      final data = await http.get(
          Uri.parse('${apiRepo.url}$id/information?includeNutrition=true'),
          headers: apiRepo.api);
      _jsonData = jsonDecode(data.body);
      for (var i = 0;
          i < _jsonData['analyzedInstructions'][0]["steps"].length;
          i++) {
        RecipeStep temp = RecipeStep.fromJson(
            _jsonData['analyzedInstructions'][0]["steps"][i]);
        steps.add(temp);
      }
      return steps;
    });
  }

  storeShoppingList(data, successMessage) async {
    var userId = await getUserId();
    var idListToString = data.join(',');

    Map<String, dynamic> idMap = {'id': idListToString};
    final snapshot = await FirebaseFirestore.instance
        .collection('/Users/$userId/ShoppingList')
        .get();
    var userRepo = UserRepository();
    UserModel userdata = await userRepo.getUserData(userId);

    if (snapshot.size == 0) {
      await _db
          .collection("/Users/$userId/ShoppingList/")
          .add(idMap)
          .then((DocumentReference docId) {
            var user = UserModel(
                username: userdata.username,
                email: userdata.email,
                pfp: userdata.pfp,
                shoppingListId: docId.id);
            userRepo.updateData(user, userId, "");

            // existingDocId.setString("existingDocId", docId.id);
          })
          .whenComplete(
            () => Get.snackbar(
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
    } else if (snapshot.size == 1) {
      //var tempDocId = existingDocId.getString("existingDocId");
      await _db
          .collection("/Users/$userId/ShoppingList/")
          .doc(userdata.shoppingListId)
          .update(idMap)
          .whenComplete(
            () => Get.snackbar(
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
        debugPrint("error: $error");
      });
    } else {
      debugPrint("alot");
    }
  }

  Future<dynamic> getShoppingListFromDb() async {
    return _shoppingListFromDb.runOnce(() async {
      var userId = await getUserId();
      var userRepo = UserRepository();
      UserModel userdata = await userRepo.getUserData(userId);
      List shoppingList = [];
      final snapshot = await _db
          .collection("/Users/$userId/ShoppingList/")
          .where(FieldPath.documentId, isEqualTo: userdata.shoppingListId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.map((e) => FetchById.fromJson(e)).single;
        if (userData.id == "") {
          return shoppingList;
        } else {
          shoppingList = userData.id.split(',');
          return shoppingList;
        }
      }
      else if(snapshot.docs.isEmpty){
         return shoppingList;
      }
    });
  }

  getRecipeIngredients(id) async {
    return _recipeIngredients.runOnce(() async {
      var ingredientDetails = [];
      final data = await http.get(
          Uri.parse('${apiRepo.url}$id/information?includeNutrition=true'),
          headers: apiRepo.api);
      _jsonData = jsonDecode(data.body);
      for (var i = 0; i < _jsonData['extendedIngredients'].length; i++) {
        ExtendedIngredient temp =
            ExtendedIngredient.fromJson(_jsonData['extendedIngredients'][i]);
        ingredientDetails.add(temp);
      }
      return ingredientDetails;
    });
  }

  getShoppingList() async {
    return _shoppingList.runOnce(() async {
      List shoppingListFromDb = [];
      shoppingListFromDb = await getShoppingListFromDb();
      print("from db" + shoppingListFromDb.toString());
      if (shoppingListFromDb.isEmpty || shoppingListFromDb == []) {
        print("object");
        return shoppingListFromDb;
      } else {
        var finalShoppingList = [];
        var ingredientDetails = [];
        List tempdata = [];
        for (var i = 0; i < shoppingListFromDb.length; i++) {
          final data = await http.get(
              Uri.parse('https://api.apilayer.com/spoonacular/food/ingredients/' + shoppingListFromDb[i] + '/information?'),
              headers: apiRepo.api);

          _jsonData = jsonDecode(data.body);

          tempdata.add(_jsonData);
        }
        for (var i = 0; i < tempdata.length; i++) {
          IngredientInfo temp = IngredientInfo.fromJson(tempdata[i]);
          ingredientDetails.add(temp);
        }
        for (var i = 0; i < ingredientDetails.length; i++) {
          if (shoppingListFromDb.contains(ingredientDetails[i].id.toString())) {
            finalShoppingList.add(ingredientDetails[i]);
          }
        }
        print("final list${finalShoppingList.toString()}");
        return finalShoppingList;
      }
    });
  }

  addToFavourite(favouritesList) async {
    var userId = await getUserId();
    List existingFavouritesList = await getFavouritesFromDb();

    var idListToString = favouritesList.join(',');
    Map<String, dynamic> recipeIdMap = {'id': idListToString};
    if (existingFavouritesList.contains(idListToString)) {
      debugPrint("already there");
    } else {
      await _db
          .collection("/Users/$userId/FavouritesList/")
          .add(recipeIdMap)
          .whenComplete(
            () => Get.snackbar(
              "Success",
              "Recipe added to favourites",
              snackPosition: SnackPosition.BOTTOM,
            ),
          )
          .catchError((error, stackTrace) {
        Get.snackbar(
          "Error",
          "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
        );
        debugPrint("error: $error");
      });
    }
  }

  getFavouritesFromDb() async {
    var userId = await getUserId();
    var favouritesList = [];

    final snapshot = await _db
        .collection("/Users/$userId/FavouritesList/")
        .where(FieldPath.documentId)
        .get();
    if (snapshot.size != 0) {
      for (var item in snapshot.docs) {
        favouritesList.add(FetchById.fromJson(item).toJson()['id']);
      }
    }
    return favouritesList;
  }

  getFavourtieRecipeInfo(favouritesList) async {
    // return _favouritesList.runOnce(() async {
    var finalFavsList = [];
    for (var i = 0; i < favouritesList.length; i++) {
      final response = await http.get(
          Uri.parse(
              '${apiRepo.url}${favouritesList[i].toString()}/information?includeNutrition=true'),
          headers: apiRepo.api);
      final responseJson = jsonDecode(response.body);
      RecipeInformation temp = RecipeInformation.fromJson(responseJson);
      finalFavsList.add(temp);
    }
    return finalFavsList;
    // });
  }

  deleteFavListDoc(recipeId) async {
    var userId = await getUserId();
    var favsListfromDB = await _db
        .collection("/Users/$userId/FavouritesList/")
        .where(FieldPath.documentId)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        var id = IdModel.fromJson(doc).toJson()['id'];
        if (id == recipeId.toString()) {
          doc.reference.delete();
          break;
        }
      }
    }).whenComplete(() => debugPrint("deleted: $recipeId"));
    return favsListfromDB;
  }
}
