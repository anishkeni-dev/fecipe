import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/repository/user_repository.dart';
import '/commons/bottom_bar.dart';

class UserPreferences extends StatefulWidget {
  const UserPreferences({super.key});

  @override
  State<UserPreferences> createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {
  List recipeFilters = [
    "Vegetarian",
    "Non-vegetarian",
    "Gluten-free",
    "Vegan",
    "Healthy",
    "Ketogenic"
  ];
  Set<String> filters = <String>{};
  List filtersFromSharedPref = [];
  checkSearchFilters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var searchFilters = prefs.getString('searchFilters');
    filtersFromSharedPref = searchFilters.toString().split(',');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    checkSearchFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choose the recipes you like!",
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(
                  height: MediaQuery.of(context).devicePixelRatio * 5,
                ),
                const Text("Select all that applies:",
                    style: TextStyle(
                      color: Colors.grey,
                    )),
                Wrap(
                  spacing: MediaQuery.of(context).devicePixelRatio * 0.5,
                  children: recipeFilters.map(
                    (recipeFilters) {
                      return Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).devicePixelRatio * 4),
                        child: FilterChip(
                          avatar: Image.asset(
                            "asset/images/onboarding3.png",
                          ),
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: filters.contains(recipeFilters) ||
                                          filtersFromSharedPref
                                              .contains(recipeFilters)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent)),
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).devicePixelRatio * 4),
                          selectedColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          label: Text(
                            recipeFilters,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          selected: filters.contains(recipeFilters) ||
                              filtersFromSharedPref.contains(recipeFilters),
                          onSelected: (bool selected) async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(
                              () {
                                if (ModalRoute.of(context)?.settings.name !=
                                    'userPrefFromSignup') {
                                  prefs.remove("searchFilters");
                                }
                                checkSearchFilters();
                                if (selected) {
                                  filters.add(recipeFilters);
                                } else {
                                  filters.remove(recipeFilters);
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: filters.isEmpty &&
                      ModalRoute.of(context)!.settings.name !=
                          '/userPrefFromSignup'
                  ? MaterialStateColor.resolveWith((states) => Colors.grey)
                  : null,
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            onPressed: () async {
              final prevRoute = ModalRoute.of(context)!.settings.name;
              if (prevRoute == "/userPrefFromSignup") {
                if (filters.isNotEmpty) {
                  UserRepository repo = UserRepository();
                  repo.saveUserPreferences(filters);
                }
                Get.to(const BottomBar());
              } else {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                var filtersListToString = filters.join(',');
                prefs.setString("searchFilters", filtersListToString);
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Continue",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
