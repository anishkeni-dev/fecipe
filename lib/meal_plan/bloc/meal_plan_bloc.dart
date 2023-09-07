import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fecipe/data_models/meal_plan_model.dart';
import 'package:fecipe/repository/mealplan_repository.dart';

part 'meal_plan_event.dart';
part 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealPlanRepository mealPlanRepository = MealPlanRepository();

  MealPlanBloc() : super(MealPlanInitial()) {
    // on<LoadMealPlans>((event, emit) async {
    //   emit(MealPlanLoading());
    //   List<MealPlanItemModel> mealTimeMealPlans = await mealPlanRepository.getMealPlans(idList: event.idList);
    //   for (var i in mealTimeMealPlans) {
    //     i.printMealPlanItem();
    //   }
    //   emit(MealPlanLoaded(mealTimeMealPlans: mealTimeMealPlans));
    // });

    on<UnscheduleMeal>((event, emit) async {
      await mealPlanRepository.unscheduleMeal(day: event.day, mealTime: event.mealTime, recipeID: event.recipeID, recipeTitle: event.recipeTitle);
      emit(MealUnscheduled());
    });
  }
}
