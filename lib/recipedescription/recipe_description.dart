import 'package:auto_size_text/auto_size_text.dart';
import 'package:fecipe/favourites/favourites.dart';
import 'package:fecipe/recipedescription/bloc/recipe_description_bloc.dart';
import 'package:fecipe/recipedescription/bloc/recipe_description_events.dart';
import 'package:fecipe/recipedescription/bloc/recipe_description_states.dart';
import 'package:fecipe/recipedescription/ingredients.dart';
import 'package:fecipe/recipedescription/recipe_steps_info.dart';
import 'package:fecipe/repository/recipedata_repository.dart';
import 'package:fecipe/schedule_meal/schedule_meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RecipeDescription extends StatefulWidget {
  const RecipeDescription(this.id, {super.key});

  final String id;
  @override
  State<RecipeDescription> createState() => _RecipeDescriptionState();
}

class _RecipeDescriptionState extends State<RecipeDescription> {
  List recipeFilters = ["Healthy", "Vegan"];
  var _peopleCount = 1;
  String? ingridients;
  late var recipeId;
  var favsList = [];
  bool favIconStatus = false;
  RecipeDataRepository repo = RecipeDataRepository();
  int peopleCount = 1;

  replaceSubStr(subStr) {
    subStr = subStr.replaceAll('</b>', '');
    subStr = subStr.replaceAll('<b>', '');
    return subStr;
  }

  checkFavourite() async {
    var favsListfromDB = await repo.getFavouritesFromDb();
    if (favsListfromDB.contains(recipeId.toString())) {
      setState(() {
        favIconStatus = true;
      });
    }
  }

  onPressFavIcon() async {
    //temp
    if (!favsList.contains(recipeId.toString())) {
      favsList.add(recipeId.toString());
    }
    if (favIconStatus) {
      await repo.deleteFavListDoc(recipeId.toString());
      setState(() {
        favIconStatus = false;
      });
    } else {
      await repo.addToFavourite(favsList);
    }

    await checkFavourite();
  }

  @override
  void initState() {
    // TODO: implement initState
    recipeId = widget.id;
    checkFavourite();
    BlocProvider.of<RecipeDescriptionBloc>(context)
        .add(RecipeDataRequested(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
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
            actions: [
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    BlocBuilder<RecipeDescriptionBloc, RecipeDescriptionStates>(
                        builder: (context, state) {
                      if (state is RecipeDataLoaded) {
                        return IconButton(
                            onPressed: () {
                              Get.to(ScheduleMeal(
                                  recipeID: recipeId.toString(),
                                  recipeTitle: state.recipeData.title));
                            },
                            icon: Icon(Icons.add,
                                size: MediaQuery.of(context).devicePixelRatio *
                                    11));
                      }
                      return Container();
                    }),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.ios_share_rounded,
                            size:
                                MediaQuery.of(context).devicePixelRatio * 10)),
                    IconButton(
                      onPressed: () {
                        onPressFavIcon();
                      },
                      icon: Icon(
                        favIconStatus ? Icons.favorite : Icons.favorite_border,
                        size: MediaQuery.of(context).devicePixelRatio * 11,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                  BlocBuilder<RecipeDescriptionBloc, RecipeDescriptionStates>(
                      builder: (context, state) {
                if (state is RecipeDataLoading) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                } else if (state is RecipeDataLoaded) {
                  String newStr = replaceSubStr(state.recipeData.summary);
                  // _peopleCount = state.recipeData.servings;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: state.recipeData.diets.isEmpty
                            ? 0
                            : MediaQuery.of(context).devicePixelRatio * 10,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Text(
                                  "#${state.recipeData.diets[index].toString()}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                            itemCount: state.recipeData.diets.length),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(178), // Image radius
                          child: Image.network(
                            state.recipeData.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).devicePixelRatio * 10),
                      //title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              state.recipeData.title,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          20,
                                  fontWeight: FontWeight.bold),
                              maxLines: 6,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: Theme.of(context).colorScheme.primary,
                                size:
                                    MediaQuery.of(context).devicePixelRatio * 6,
                              ),
                              Text(
                                "${state.recipeData.readyInMinutes}mins",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10,
                      ),
                      //summary
                      Text(
                        newStr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            recipeinfo(
                                state.recipeData.nutrition.nutrients[0].amount
                                    .round()
                                    .toString(),
                                "Kcals"),
                            recipeinfo(
                                "${state.recipeData.nutrition.weightPerServing.amount.round().toString()}g",
                                "weight"),
                            recipeinfo(
                                "${state.recipeData.nutrition.nutrients[8].amount.toString()}g",
                                "proteins"),
                            recipeinfo(
                                "${state.recipeData.nutrition.nutrients[3].amount.toString()}g",
                                "carbs"),
                            recipeinfo(
                                "${state.recipeData.nutrition.nutrients[1].amount.round().toString()}g",
                                "fats"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10,
                      ),
                      Row(children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "People",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "How many servings?",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            )
                          ],
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).devicePixelRatio * 12,
                        // ),
                        const Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    peopleCount--;
                                    setState(() {
                                      if (peopleCount == 0) {
                                        peopleCount = 1;
                                      }
                                    });
                                  }),
                              AutoSizeText(
                                peopleCount.toString(),
                                style: const TextStyle(color: Colors.white),
                                minFontSize: 10,
                                maxFontSize: 15,
                              ),
                              IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      peopleCount++;
                                    });
                                  })
                            ],
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            TabBar(
                              indicatorColor:
                                  Theme.of(context).colorScheme.primary,
                              labelColor: Theme.of(context).colorScheme.primary,
                              unselectedLabelColor: Colors.black,
                              tabs: const [
                                Tab(
                                    child: Text("Ingredients",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Tab(
                                    child: Text("Recipe",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Ingredients(widget.id),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: RecipeInfo(widget.id),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
        ));
  }
}

Widget recipeinfo(amount, unit) {
  return Column(
    children: [
      Text(
        amount,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      Text(
        unit,
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      ),
    ],
  );
}
