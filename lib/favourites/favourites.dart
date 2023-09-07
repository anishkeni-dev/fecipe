import 'package:flutter/material.dart';

import '../search/search.dart';
import '/repository/recipedata_repository.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}


class _FavouritesState extends State<Favourites> {
  Future<dynamic> favourites = Future.value();
  RecipeDataRepository repo = RecipeDataRepository();
  var isLoading = true;

  fetchFavourites() async {
    var favouritesList = [];

    if (cd.cachedFavouritesData.isEmpty) {
      favouritesList =
      await repo.getFavourtieRecipeInfo(await repo.getFavouritesFromDb());
      cd.cachedFavouritesData = favouritesList;
      if (favouritesList.isNotEmpty) {
        favourites = Future.value(favouritesList);
      } else {
        favourites = Future.value();
      }
      setState(() {
        isLoading = false;
      });
    }
    else if (cd.cachedFavouritesData.isNotEmpty) {
      favouritesList = cd.cachedFavouritesData;
      if (favouritesList.isNotEmpty) {
        favourites = Future.value(favouritesList);
      } else {
        favourites = Future.value();
      }
      setState(() {
        isLoading = false;
      });
    }
  }


  removeFromFavourites(recipeId) async {
    setState(() {
      isLoading = true;
    });
    await repo.deleteFavListDoc(recipeId);
    cd.cachedFavouritesData = [];
    await fetchFavourites();
  }

  @override
  void initState() {
    super.initState();
    fetchFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Favourites', style: TextStyle(color: Colors.white),)),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: favourites,
            builder: (context, snapshot) =>
            snapshot.hasData && !isLoading
                ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 8,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  snapshot.data[index].image,
                                  height:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      0.12,
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      0.12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.5,
                                    child: Text(
                                      snapshot.data[index].title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height *
                                        0.009,
                                  ),
                                  const Row(
                                    children: [
                                      Text(
                                        "Ratings: 4.2",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 20,
                                        color: Colors.yellow,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                removeFromFavourites(
                                    snapshot.data[index].id);
                              },
                              icon: const Icon(Icons.favorite),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : isLoading
                ? Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4),
                child: const CircularProgressIndicator())
                : Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4),
                // height: MediaQuery.of(context).size.height * 0.04,
                child: const Text(
                  'No results',
                  style: TextStyle(
                      fontSize: 22,
                      color: Color(0xff848484)),
                ))),
      ),
    );
  }

}