import 'package:flutter_bloc/flutter_bloc.dart';

import '../shopping_list.dart';
import '/repository/recipedata_repository.dart';
import '/shopping_list/bloc/shoppinglist_events.dart';
import '/shopping_list/bloc/shoppinglist_states.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvents, ShoppingListStates> {
  ShoppingListBloc() : super(ShoppingListInitial()) {

    on<ShoppingListRequested>((event, emit) async {
      emit(ShoppingListLoading());
      RecipeDataRepository repo = RecipeDataRepository();
      event.shoppingList = await repo.getShoppingList();
      if(event.shoppingList.isEmpty){
        emit(ShoppingListEmpty());
      }
      else{
        emit(ShoppingListLoaded(event.shoppingList));
      }

    });

    on<RemoveFromShoppingList>((event, emit) async {
      RecipeDataRepository repo = RecipeDataRepository();
      event.shoppingList = await repo.getShoppingListFromDb();
      if (event.shoppingList.contains(event.element)) {
        event.shoppingList.remove(event.element);
        await repo.storeShoppingList(
            event.shoppingList, "Ingredient removed from the Shopping list");
        var refreshed = await repo.getShoppingListFromDb();
        add(ShoppingListRequested(refreshed));

      }
    });
  }
}
