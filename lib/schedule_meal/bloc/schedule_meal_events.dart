part of 'schedule_meal_bloc.dart';

abstract class ScheduleMealEvent {}

class ScheduleMealButtonPress extends ScheduleMealEvent {
  final String day;
  final String mealTime;
  final String recipeID;
  final String recipeTitle;

  ScheduleMealButtonPress({
    required this.day,
    required this.mealTime,
    required this.recipeID,
    required this.recipeTitle
  });
}
