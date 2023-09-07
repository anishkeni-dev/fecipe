import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/recipedata_repository.dart';

class RecipeInfo extends StatefulWidget {
  const RecipeInfo(this.id, {super.key});
  final String id;
  @override
  RecipeInfoState createState() => RecipeInfoState();
}

class RecipeInfoState extends State<RecipeInfo> {
  var recipeSteps;
  RecipeDataRepository repo = RecipeDataRepository();
  fetchRecipeSteps() async {
    recipeSteps = await repo.fetchRecipeSteps(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRecipeSteps(),
      builder: (context, snapshot) {
        return recipeSteps == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      itemCount: recipeSteps.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                            color: Colors.transparent, height: 20);
                      },
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(245, 243, 244, 245),
                              border: Border.all(
                                color: const Color.fromARGB(233, 218, 218, 221),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: MediaQuery.of(context)
                                    .size.height*
                                    0.002,
                              ),
                              Text(
                                "Step ${recipeSteps[index].number.toString().trim()} :  ${recipeSteps[index].step.toString()}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height *
                                        .002,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
