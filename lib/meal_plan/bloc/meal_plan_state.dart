part of 'meal_plan_bloc.dart';

abstract class MealPlanState {}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanLoaded extends MealPlanState {
  late List<MealPlanItemModel> mealTimeMealPlans;

  MealPlanLoaded({required this.mealTimeMealPlans});
}

class MealUnscheduled extends MealPlanState {}