import 'package:fecipe/repository/recipedata_repository.dart';
import 'package:flutter/material.dart';

import '../favourites/favourites.dart';
import '../shopping_list/shopping_list.dart';
import '/dashboard/dashboard.dart';
import '/search/search.dart';
import 'package:fecipe/meal_plan/meal_plan.dart';

class BottomBar extends StatefulWidget {

 const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    Search(),
    const MealPlan(),
    Favourites(),
    const DashboardPage(),
    const ShoppingList(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
              color: Colors.transparent,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: BottomAppBar(
              color: Theme.of(context).colorScheme.background,
              shape: const CircularNotchedRectangle(),
              child: Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIcon(0, MediaQuery.of(context).size.width * 0.08, 0.0,
                        Icons.search),
                    CustomIcon(1, 0.0, MediaQuery.of(context).size.width * 0.08,
                        Icons.timer),
                    CustomIcon(2, MediaQuery.of(context).size.width * 0.08, 0.0,
                        Icons.favorite),
                    CustomIcon(3, 0.0, MediaQuery.of(context).size.width * 0.08,
                        Icons.person),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(20),
            shape: MaterialStateProperty.all(const CircleBorder()),
            padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          ),
          onPressed: () {
            setState(() {
              _selectedIndex = 4;
              RecipeDataRepository repo = RecipeDataRepository();
              repo.getShoppingListFromDb();
            });
          },
          child: const Icon(
            Icons.shopping_bag,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  CustomIcon(index, marginLeft, marginRight, iconName) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft, right: marginRight),
      child: IconButton(
          onPressed: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          icon: Icon(
            iconName,
            color: Theme.of(context).colorScheme.primary,
          )),
    );
  }
}
