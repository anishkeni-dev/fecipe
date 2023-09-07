import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../recipedescription/recipe_description.dart';
import '../repository/recipedata_repository.dart';

class ViewAll extends StatefulWidget {
  const ViewAll(
      {super.key,
      required this.type,
      required this.recipesType,
      required this.isPreferences});
  final String type;
  final String recipesType;
  final bool isPreferences;
  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  RecipeDataRepository repo = RecipeDataRepository();
  Future<dynamic> futureRecipes = Future.value();
  bool isRecipesLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isRecipesLoading = true;
      fetchData();
    });
  }

  fetchData([value = '']) async {
    List recipes = [];
    futureRecipes = Future.value();
    setState(() {
      isRecipesLoading = true;
    });

    recipes = await repo.getMealsListBySearch(
        widget.type, value, widget.recipesType, widget.isPreferences);

    if (recipes.isNotEmpty) {
      futureRecipes = Future.value(recipes);
    }
    setState(() {
      isRecipesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          title: const SizedBox(
              child: Text(
            'Recipes',
            style: TextStyle(color: Colors.white),
          )),
          elevation: 0,
        ),
        body: FutureBuilder(
          future: futureRecipes,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(RecipeDescription(
                                snapshot.data[index].id.toString()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 5,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.39,
                              width: MediaQuery.of(context).size.width * .90,
                              alignment: Alignment.topRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        snapshot.data[index].image.toString(),
                                        fit: BoxFit.fill,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: AutoSizeText(
                                      maxFontSize: 24,
                                      minFontSize: 16,
                                      snapshot.data[index].title.toString(),
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //  ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
