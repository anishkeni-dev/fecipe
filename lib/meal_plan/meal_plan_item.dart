import 'package:fecipe/data_models/meal_plan_model.dart';
import 'package:fecipe/meal_plan/bloc/meal_plan_bloc.dart';
import 'package:fecipe/recipedescription/recipe_description.dart';
import 'package:fecipe/repository/mealplan_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

Widget getMealPlanItem({required String day, required String mealTime, required dynamic mealTimeMealPlans}) {
  if (mealTimeMealPlans.length == 0) {
    return const Padding(
      padding: EdgeInsets.all(6.0),
      child: Text(
        "An error was encountered when fetching meals.",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  } else {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: mealTimeMealPlans.length,
          itemBuilder: (BuildContext context, int itemIndex) {
            return MealPlanItem(day: day, mealTime: mealTime, mealPlanItem: mealTimeMealPlans[itemIndex]);
          },
        )
      ],
    );
  }
}

class MealPlanItem extends StatefulWidget {
  final String day;
  final String mealTime;
  final MealPlanItemModel mealPlanItem;

  const MealPlanItem({
    super.key,
    required this.day,
    required this.mealTime,
    required this.mealPlanItem,
  });

  @override
  State<MealPlanItem> createState() => _MealPlanItemState();
}

class _MealPlanItemState extends State<MealPlanItem> {
  MealPlanRepository repo = MealPlanRepository();

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Unschedule Meal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to unschedule ${widget.mealPlanItem.title}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                BlocProvider.of<MealPlanBloc>(context).add(UnscheduleMeal(day: widget.day, mealTime: widget.mealTime, recipeID: widget.mealPlanItem.id.toString(), recipeTitle: widget.mealPlanItem.title));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            RecipeDescription(widget.mealPlanItem.id.toString()));
      },
      onLongPress: () {
        _showAlertDialog();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.height * 0.09,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: NetworkImage(
                        widget.mealPlanItem.image,
                      ),
                      fit: BoxFit.cover)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width:
                  MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    widget.mealPlanItem.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  "Preparation Time: ${widget.mealPlanItem.readyInMinutes} mins",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Serves: ${widget.mealPlanItem.servings}",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}