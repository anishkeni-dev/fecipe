abstract class ShoppingListStates {}

class ShoppingListLoaded extends ShoppingListStates {
  late List shoppingList;
  ShoppingListLoaded(this.shoppingList);
}

class ShoppingListLoading extends ShoppingListStates {}
class ShoppingListEmpty extends ShoppingListStates {}

class ShoppingListInitial extends ShoppingListStates {}