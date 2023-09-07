
import 'package:fecipe/data_models/recipe_info_model.dart';
import 'package:fecipe/recipedescription/bloc/recipe_description_events.dart';
import 'package:fecipe/recipedescription/bloc/recipe_description_states.dart';
import 'package:fecipe/repository/recipedata_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RecipeDescriptionBloc extends Bloc<RecipeDescriptionEvents, RecipeDescriptionStates> {
  RecipeDescriptionBloc() : super(RecipeDataInitial()) {

    RecipeDataRepository repo = RecipeDataRepository();

    on<RecipeDataRequested>((event, emit) async {
      emit(RecipeDataLoading());
      RecipeInformation recipeData = await repo.fetchRecipeInfo(event.recipeId);
      emit(RecipeDataLoaded(recipeData));
    });

    on<AddToShopping>((event, emit) async {
      print("add to shopping list ${event.shoppingList}");
      await repo.storeShoppingList(event.shoppingList, "Ingredient added to Shopping list");
    });


  }
}
