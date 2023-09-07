
abstract class RecipeDescriptionEvents {}

class RecipeDataRequested extends RecipeDescriptionEvents {
  final String recipeId;
  RecipeDataRequested(this.recipeId);
}

class AddToShopping extends RecipeDescriptionEvents {
  late List shoppingList;
  AddToShopping(this.shoppingList);
}
