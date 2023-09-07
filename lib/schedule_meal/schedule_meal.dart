import 'package:fecipe/commons/days_and_mealTimes.dart';
import 'package:fecipe/schedule_meal/bloc/schedule_meal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleMeal extends StatefulWidget {
  final String recipeID;
  final String recipeTitle;
  const ScheduleMeal({Key? key, required this.recipeID, required this.recipeTitle}) : super(key:key);

  @override
  State<ScheduleMeal> createState() => _ScheduleMealState();
}

class _ScheduleMealState extends State<ScheduleMeal> {
  String day = days.first;
  String mealTime = mealTimes.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Schedule Your Meal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: MediaQuery.of(context).devicePixelRatio * 11,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Do you want to add",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              widget.recipeTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "to your schedule?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                'Please select the day and the meal time when you would like to schedule the meal.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DropdownButtonFormField<String>(
                value: day,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                isExpanded: true,
                // elevation: 100,
                style: Theme.of(context).textTheme.bodyLarge,
                hint: const Text('Schedule Day'),
                onChanged: (String? value) {
                  setState(() {
                    day = value!;
                  });
                },
                items: days.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).devicePixelRatio * 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DropdownButtonFormField<String>(
                value: mealTime,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                isExpanded: true,
                // elevation: 100,
                style: Theme.of(context).textTheme.bodyLarge,
                hint: const Text('Schedule Meal Time'),
                onChanged: (String? value) {
                  setState(() {
                    mealTime = value!;
                  });
                },
                items: mealTimes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).devicePixelRatio * 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.05,
              child: BlocConsumer<ScheduleMealBloc, ScheduleMealState>(
                listener: (context, state) {
                  if (state is MealScheduled) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(15),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: state is SchedulingMeal ? null : () {
                      BlocProvider.of<ScheduleMealBloc>(context).add(ScheduleMealButtonPress(day: day, mealTime: mealTime, recipeID: widget.recipeID, recipeTitle: widget.recipeTitle));
                    },
                    child: Text(
                      'Schedule Meal',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
