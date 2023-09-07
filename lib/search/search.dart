import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commons/cachedData.dart';
import '/userpreferences/user_preferences.dart';
import '/view_all/view_all.dart';
import '../data_models/usermodel.dart';
import '../repository/recipedata_repository.dart';
import '/recipedescription/recipe_description.dart';
import 'bloc/search_events.dart';
import '/search/bloc/search_bloc.dart';
import '/search/bloc/search_states.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}

CachedData cd = CachedData();


int selectedIndex = 0;

class _SearchState extends State<Search> {
  final search = TextEditingController();
  RecipeDataRepository repo = RecipeDataRepository();

  final List type = ["Breakfast", "Lunch", "Dinner"];
  String searchFilters = '';
  Future<dynamic> futurePopular = Future.value();
  Future<dynamic> futureRecommended = Future.value();
  Future<dynamic> futureSearchList = Future.value();
  List carousalData = [];
  bool isRecommendedRecipeLoading = false;
  bool isPopularRecipeLoading = false;
  bool isSearchResultsLoading = false;

  String searchValue = '';
  bool isPreferences = false;
  bool isSearchActive = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isRecommendedRecipeLoading = true;
      isPopularRecipeLoading = true;
      getRecipes();
      getDataForCarousel();
    });
  }

  getSearchFilters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    searchFilters = prefs.getString('searchFilters')!;

    setState(() {});
  }

  getRecipes() async {
    await fetchRecommendedData();
    await fetchPopularData();
    setState(() {
      isPreferences = false;
    });
  }

  getusername() {
    var user = UserModel(username: "", email: "", pfp: '');
    BlocProvider.of<SearchPageBloc>(context).add(UsernameRequested(user));
    setState(() {});
  }

  getDataForCarousel() async {
    carousalData = await repo.getCarouselData();
  }

  fetchRecommendedData([value = '']) async {
    List recipes = [];
    futureRecommended = Future.value();
    setState(() {
      isRecommendedRecipeLoading = true;
    });

    print("getting recommended data");

    // cd.cachedRecommendedData = recipes;
    if (type[selectedIndex] == "Breakfast" &&
        cd.cachedBreakfastDataRec.isEmpty) {
      recipes = await repo.getMealsListBySearch(
          type[selectedIndex], value, 'recommended', isPreferences);
      cd.cachedBreakfastDataRec = recipes;
    } else if (type[selectedIndex] == "Lunch" &&
        cd.cachedLunchDataRec.isEmpty) {
      recipes = await repo.getMealsListBySearch(
          type[selectedIndex], value, 'recommended', isPreferences);
      cd.cachedLunchDataRec = recipes;
    } else if (type[selectedIndex] == "Dinner" &&
        cd.cachedDinnerDataRec.isEmpty) {
      recipes = await repo.getMealsListBySearch(
          type[selectedIndex], value, 'recommended', isPreferences);
      cd.cachedDinnerDataRec = recipes;
    } else {
      print("existing data");
      if (type[selectedIndex] == "Breakfast") {
        recipes = cd.cachedBreakfastDataRec;
      } else if (type[selectedIndex] == "Lunch") {
        recipes = cd.cachedLunchDataRec;
      } else if (type[selectedIndex] == "Dinner") {
        recipes = cd.cachedDinnerDataRec;
      }
    }

    if (recipes.isNotEmpty) {
      futureRecommended = Future.value(recipes);
    }
    setState(() {
      isRecommendedRecipeLoading = false;
    });
  }

  fetchPopularData([value = '']) async {
    List popularRecipes = [];
    futurePopular = Future.value();
    setState(() {
      isPopularRecipeLoading = true;
    });
    if (type[selectedIndex] == "Breakfast" &&
        cd.cachedBreakfastDataPop.isEmpty) {
      popularRecipes = await repo.getMealsListBySearch(
          type[selectedIndex], value, 'popular', isPreferences);
      cd.cachedBreakfastDataPop = popularRecipes;
    } else if (type[selectedIndex] == "Lunch" &&
        cd.cachedLunchDataPop.isEmpty) {
      popularRecipes = await repo.getMealsListBySearch(
          type[selectedIndex], value, 'popular', isPreferences);
      cd.cachedLunchDataPop = popularRecipes;
    } else if (type[selectedIndex] == "Dinner" &&
        cd.cachedDinnerDataPop.isEmpty) {
      popularRecipes = await repo.getMealsListBySearch(
          type[selectedIndex], value, 'popular', isPreferences);
      cd.cachedDinnerDataPop = popularRecipes;
    } else {
      print("existing data");
      if (type[selectedIndex] == "Breakfast") {
        popularRecipes = cd.cachedBreakfastDataPop;
      } else if (type[selectedIndex] == "Lunch") {
        popularRecipes = cd.cachedLunchDataPop;
      } else if (type[selectedIndex] == "Dinner") {
        popularRecipes = cd.cachedDinnerDataPop;
      }
    }
    if (popularRecipes.isNotEmpty) {
      futurePopular = Future.value(popularRecipes);
    }
    setState(() {
      isPopularRecipeLoading = false;
    });
  }

  handleSearch(value) async {
    getSearchFilters();
    setState(() {
      isSearchResultsLoading = true;
      searchValue = value;
    });
    List searchList =
    await repo.getMealsListBySearch(" ", value, '', isPreferences);
    if (searchList.isNotEmpty) {
      futureSearchList = Future.value(searchList);
    } else {
      futureSearchList = Future.value();
    }
    if (value != '') {
      setState(() {
        isSearchActive = true;
      });
    } else {
      setState(() {
        isSearchActive = false;
      });
      await fetchRecommendedData();
      await fetchPopularData();
      futureSearchList = Future.value();
    }
    setState(() {
      isSearchResultsLoading = false;
    });
  }

  onTabSwitch(index) async {
    setState(() {
      selectedIndex = index;
    });
    if (isSearchActive) {
      handleSearch(searchValue);
    } else {
      fetchRecommendedData();
      fetchPopularData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getusername(),
        builder: (context, snapshot) {
          return BlocBuilder<SearchPageBloc, SearchStates>(
              builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedState) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  title: Row(children: [
                    const Text("Hello, "),
                    Text(state.user.username),
                  ]),
                  // actions: [
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(
                  //       Icons.menu,
                  //       color: Theme.of(context).colorScheme.primary,
                  //     ),
                  //   )
                  // ],
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: state.user.pfp == null
                          ? const DecorationImage(
                              image: AssetImage(
                                  'asset/images/default_profile.jpeg'),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: NetworkImage(state.user.pfp!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      const AutoSizeText(
                        minFontSize: 25,
                        maxFontSize: 30,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        "Choose the best dish for you",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //SearchBar
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: TextField(
                          onChanged: (value) async {
                            if (value.isNotEmpty) {
                              handleSearch(value);
                            } else {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                prefs.setString("searchFilters", '');
                                isSearchActive = false;
                              });
                            }
                          },
                          controller: search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(fontSize: 18),
                            hintText: 'Search',
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 25,
                            ),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.filter_list),
                                color: Colors.yellow.shade600,
                                onPressed: () => isSearchActive
                                    ? _dialogBuilder(context)
                                    : null),
                            contentPadding: const EdgeInsets.all(18),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      isSearchActive
                          ? searchWidget()
                          : Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.24,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: carousalData.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.80,
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        child: AutoSizeText(
                                                          carousalData[index]
                                                              .title,
                                                          maxFontSize: 26,
                                                          minFontSize: 14,
                                                          maxLines: 4,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Image.asset(
                                                  carousalData[index].image,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.32,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.20,
                                                  fit: BoxFit.fill,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: type.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          selected: index == selectedIndex,
                                          onTap: () {
                                            onTabSwitch(index);
                                          },
                                          tileColor: Colors.white,
                                          selectedTileColor: Colors.amber,
                                          title: Text(
                                            type[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: index == selectedIndex
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width: 10,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                    child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 10, right: 10),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Recommended Recipes",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(ViewAll(
                                              type: type[selectedIndex],
                                              recipesType: 'recommended',
                                              isPreferences: isPreferences,
                                            ));
                                          },
                                          child: const Text(
                                            "View all",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: futureRecommended,
                                    builder: (context, snapshot) => snapshot
                                                .hasData &&
                                            !isRecommendedRecipeLoading
                                        ? SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.28,
                                            child: recipeCards(snapshot.data))
                                        : isRecommendedRecipeLoading
                                            ? SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                                child:
                                                    const LinearProgressIndicator(
                                                        color: Colors.amber))
                                            : SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                child: const Text(
                                                  'No results',
                                                  style: TextStyle(
                                                      fontFamily: 'Avenir',
                                                      fontSize: 22,
                                                      color: Color(0xff848484)),
                                                )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Popular Recipes",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(ViewAll(
                                              type: type[selectedIndex],
                                              recipesType: 'popular',
                                              isPreferences: isPreferences,
                                            ));
                                          },
                                          child: const Text(
                                            "View all",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: futurePopular,
                                      builder: (context, snapshot) => snapshot
                                                  .hasData &&
                                              !isPopularRecipeLoading
                                          ? SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.28,
                                              child: recipeCards(snapshot.data))
                                          : isPopularRecipeLoading
                                              ? SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  child:
                                                      const LinearProgressIndicator(
                                                          color: Colors.amber))
                                              : SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  child: const Text(
                                                    'No results',
                                                    style: TextStyle(
                                                        fontFamily: 'Avenir',
                                                        fontSize: 22,
                                                        color:
                                                            Color(0xff848484)),
                                                  ))),
                                ])),
                              ],
                            )
                    ]),
                  ),
                ),
              );
            } else {
              return const Text("Something went wrong, Try again later.");
            }
          });
        });
  }

  FutureBuilder<dynamic> searchWidget() {
    return FutureBuilder(
        future: futureSearchList,
        builder: (context, snapshot) => snapshot.hasData &&
            !isSearchResultsLoading
            ? Column(
          children: [
            Text(searchFilters == ""
                ? "Showing all results for \" $searchValue \""
                : "#$searchFilters"),
            SizedBox(
                height: snapshot.data.length <= 2
                    ? 2 * MediaQuery.of(context).size.height * 0.20
                    : snapshot.data.length *
                    MediaQuery.of(context).size.height *
                    0.10,
                child: recipeCards(snapshot.data)),
          ],
        )
            : isSearchResultsLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                    child: const LinearProgressIndicator(color: Colors.amber))
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: const Text(
                      'No results',
                      style: TextStyle(fontSize: 22, color: Color(0xff848484)),
                    )));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(child: UserPreferences()),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (isSearchActive) {
        isPreferences = true;
        setState(() {});
        handleSearch(searchValue);
      }
    });
  }

  recipeCards(responseList) {
    return ListView.builder(
        scrollDirection: isSearchActive ? Axis.vertical : Axis.horizontal,
        itemCount: responseList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                          RecipeDescription(responseList[index].id.toString()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: isSearchActive
                          ? MediaQuery.of(context).size.height * 0.15
                          : MediaQuery.of(context).size.height * 0.30,
                      width: isSearchActive
                          ? MediaQuery.of(context).size.width * 0.86
                          : MediaQuery.of(context).size.width * 0.50,
                      alignment: Alignment.topRight,
                      child: isSearchActive
                          ? Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      responseList[index].image.toString(),
                                      scale: MediaQuery.of(context)
                                              .devicePixelRatio *
                                          0.2,
                                      fit: BoxFit.fill,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    responseList[index].title.toString(),
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      responseList[index].image.toString(),
                                      scale: MediaQuery.of(context)
                                              .devicePixelRatio *
                                          0.2,
                                      fit: BoxFit.fill,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      maxFontSize: 20,
                                      minFontSize: 16,
                                      responseList[index].title.toString(),
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
