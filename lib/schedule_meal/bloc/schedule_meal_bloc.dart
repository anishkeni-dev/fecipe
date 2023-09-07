import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fecipe/repository/mealplan_repository.dart';

part 'schedule_meal_events.dart';
part 'schedule_meal_states.dart';

class ScheduleMealBloc extends Bloc<ScheduleMealEvent, ScheduleMealState> {
  final MealPlanRepository mealPlanRepository = MealPlanRepository();

  ScheduleMealBloc() : super(ScheduleMealInitial()) {
    on<ScheduleMealButtonPress>((event, emit) async {
      emit(SchedulingMeal());
      await mealPlanRepository.scheduleMeal(day: event.day, mealTime: event.mealTime, recipeID: event.recipeID, recipeTitle: event.recipeTitle);
      emit(MealScheduled());
    });
  }
}
