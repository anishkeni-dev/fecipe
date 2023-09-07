import 'package:fecipe/data_models/recipe_info_model.dart';

abstract class RecipeDescriptionStates {}

class RecipeDataLoaded extends RecipeDescriptionStates {
  late RecipeInformation recipeData;
  RecipeDataLoaded(this.recipeData);
}

class RecipeDataLoading extends RecipeDescriptionStates {}

class RecipeDataInitial extends RecipeDescriptionStates {}
