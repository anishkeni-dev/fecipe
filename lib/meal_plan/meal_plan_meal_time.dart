import 'package:fecipe/meal_plan/meal_plan_item.dart';
import 'package:fecipe/repository/mealplan_repository.dart';
import 'package:flutter/material.dart';

List<Widget> getMealPlanMealTimeItem({required String day, required dynamic idLists}) {
  debugPrint(idLists.toString());
  List<Widget> mealPlanMealTimeItemList = [];
  idLists.forEach((key, value) {
    mealPlanMealTimeItemList.add(MealPlanMealTime(day: day, mealTime: key, mealTimePlans: value));
  });
  return mealPlanMealTimeItemList;
}


class MealPlanMealTime extends StatefulWidget {
  final String day;
  final String mealTime;
  final List<dynamic> mealTimePlans;

  const MealPlanMealTime({
    super.key,
    required this.day,
    required this.mealTime,
    required this.mealTimePlans,
  });

  @override
  State<MealPlanMealTime> createState() => _MealPlanMealTimeState();
}

class _MealPlanMealTimeState extends State<MealPlanMealTime> {
  MealPlanRepository repo = MealPlanRepository();

  // @override
  // void initState() {
  //   super.initState();
  //   BlocProvider.of<MealPlanBloc>(context).add(LoadMealPlans(idList: widget.mealTimePlans));
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.mealTime,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            widget.mealTimePlans.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                "No meals have been scheduled yet.",
              ),
            )
                : FutureBuilder(
                future: repo.getMealPlans(idList: widget.mealTimePlans),
                builder: (context, snapshot) => snapshot.hasData ? getMealPlanItem(day: widget.day, mealTime: widget.mealTime, mealTimeMealPlans: snapshot.data)
                 : const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Center(child: LinearProgressIndicator()),
                )
            )
          ],
        ),
      ),
    );
  }
}

