part of 'meal_plan_bloc.dart';

abstract class MealPlanEvent {}

class LoadMealPlans extends MealPlanEvent {
  final List<dynamic> idList;

  LoadMealPlans({required this.idList});
}

class UnscheduleMeal extends MealPlanEvent {
  final String day;
  final String mealTime;
  final String recipeID;
  final String recipeTitle;

  UnscheduleMeal({required this.day,
    required this.mealTime,
    required this.recipeID,
    required this.recipeTitle});
}
