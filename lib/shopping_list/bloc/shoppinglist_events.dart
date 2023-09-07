abstract class ShoppingListEvents {}

class ShoppingListRequested extends ShoppingListEvents {
  late List shoppingList;

  ShoppingListRequested(this.shoppingList);
}

class RemoveFromShoppingList extends ShoppingListEvents {
  late String element;
  late List shoppingList;

  RemoveFromShoppingList(this.element, this.shoppingList);
}