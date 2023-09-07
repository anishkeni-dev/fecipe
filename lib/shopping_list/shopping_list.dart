import 'package:fecipe/recipedescription/ingredients.dart';
import 'package:fecipe/commons/cachedData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shopping_list/bloc/shoppinglist_bloc.dart';
import '/shopping_list/bloc/shoppinglist_states.dart';
import 'bloc/shoppinglist_events.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}
CachedData cd = CachedData();
class _ShoppingListState extends State<ShoppingList> {
  var shoppingList = [];
  fetchshoppingList() {
    if (cd.cachedShoppingData.isEmpty) {
      print("getting new data");
      BlocProvider.of<ShoppingListBloc>(context)
          .add(ShoppingListRequested(shoppingList));
    }
    else {
      print("existing data");
      return cd.cachedShoppingData;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchshoppingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'Shopping List',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ShoppingListBloc, ShoppingListStates>(
          builder: (context, state) => state is ShoppingListLoaded
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state is ShoppingListLoaded
                      ? state.shoppingList.length
                      : 0,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          "${index + 1}. ${state.shoppingList[index].name
                                              .toString().toTitleCase()}",
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.009,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: IconButton(
                                    onPressed: () {
                                      // on remove
                                      var toRemove = state
                                          .shoppingList[index].id
                                          .toString();
                                      var tempList = [];
                                      BlocProvider.of<ShoppingListBloc>(context)
                                          .add(RemoveFromShoppingList(
                                              toRemove, tempList));
                                    },
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : state is ShoppingListEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4),
                      alignment: Alignment.center,
                      child: const Text("Shopping list empty.",style: TextStyle(color: Color(0xff848484)),))
                  : Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator()),
        ),
      ),
    );
  }
}
