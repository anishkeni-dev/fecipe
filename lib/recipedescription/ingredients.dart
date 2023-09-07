import 'package:fecipe/shopping_list/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/recipe_description_events.dart';
import '/recipedescription/bloc/recipe_description_bloc.dart';
import '/repository/recipedata_repository.dart';

class Ingredients extends StatefulWidget {
  const Ingredients(
    this.id, {
    super.key,
  });
  final String id;

  @override
  State<Ingredients> createState() => IngredientsState();
}

class IngredientsState extends State<Ingredients> {
  Future<dynamic> _ingredients = Future.value(); // for ingredients
  var shoppingList = [];
  var tempList = [];

  bool check = false;
  RecipeDataRepository repo = RecipeDataRepository();

  checkShoppingListDb() async {
    tempList = await repo.getShoppingListFromDb();
    if (tempList.isEmpty) {
      print("empty");
    } else {
      for (var i = 0; i < tempList.length; i++) {
        shoppingList.add(tempList[i].toString());
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  getIngredients() async {
    var ingredients = await repo.getRecipeIngredients(widget.id);
    _ingredients = Future.value(ingredients);
    setState(() {});
    checkShoppingListDb();
  }

  addToShoppingList(shoppingList) {
    BlocProvider.of<RecipeDescriptionBloc>(context)
        .add(AddToShopping(shoppingList));
  }

  @override
  void initState() {
    // TODO: implement initState
    getIngredients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: _ingredients,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.separated(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                              color: Colors.transparent, height: 13);
                        },
                        itemBuilder: (context, index) {
                          var qty = snapshot.data[index].amount * 1;
                          return Container(
                            height:
                                MediaQuery.of(context).devicePixelRatio * 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(18))),
                            child: Center(
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                fillColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                                title: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,

                                      child: Text(
                                        snapshot.data[index].name
                                            .toString()
                                            .toTitleCase(),

                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    const Spacer(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        "${qty.toStringAsFixed(2)} ${snapshot.data[index].unit.toString()}",
                                        overflow: TextOverflow.fade,
                                        maxLines: 2,
                                      ),
                                    )
                                  ],
                                ),


                                value: shoppingList.contains(
                                    snapshot.data[index].id.toString()),
                                onChanged: (value) {
                                  setState(() {
                                    if (shoppingList.contains(
                                        snapshot.data[index].id.toString())) {
                                      shoppingList.remove(
                                          snapshot.data[index].id.toString());
                                    } else {
                                      shoppingList.add(
                                          snapshot.data[index].id.toString());
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: const CircularProgressIndicator());
              }),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ))),
              child: Text(
                shoppingList.isEmpty
                    ? "Add to Shopping"
                    : "Update Shopping list",
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                addToShoppingList(shoppingList);
              }),
        )
      ],
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
