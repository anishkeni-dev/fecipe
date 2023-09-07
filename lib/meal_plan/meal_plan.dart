import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fecipe/commons/days_and_mealTimes.dart';
import 'package:fecipe/meal_plan/bloc/meal_plan_bloc.dart';
import 'package:fecipe/meal_plan/meal_plan_meal_time.dart';
import 'package:fecipe/repository/mealplan_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealPlan extends StatefulWidget {
  const MealPlan({super.key});

  @override
  State<MealPlan> createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  //with AutomaticKeepAliveClientMixin
  MealPlanRepository repo = MealPlanRepository();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); /// Remember to add this line!!!
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
                child: Text(
              'Meal Plan',
              style: TextStyle(color: Colors.white),
            )),
          ),
          body: Container(
            decoration: BoxDecoration(
                color: Colors.white38,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 1.3,
            child: _connectionStatus == ConnectivityResult.none
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            color: Colors.redAccent,
                            size: MediaQuery.of(context).size.height * 0.4,
                          ),
                          Text(
                            "No Network Detected",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            "Your device is not connected to the internet. You must have an active network connection to view Meal Plans.",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.grey,
                        tabs: days
                            .map((tabName) => Tab(child: Text(tabName)))
                            .toList(),
                      ),
                      Expanded(
                        child: TabBarView(
                            children: days
                                .map((day) => Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: BlocListener<MealPlanBloc,
                                          MealPlanState>(
                                        listener: (context, state) {
                                          if (state is MealUnscheduled) {
                                            setState(() {});
                                          }
                                        },
                                        child: FutureBuilder(
                                            future: repo.getIdLists(day: day),
                                            builder: (context, snapshot) => snapshot
                                                    .hasData
                                                ? SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Column(
                                                        children:
                                                            getMealPlanMealTimeItem(
                                                                day: day,
                                                                idLists:
                                                                    snapshot
                                                                        .data)),
                                                  )
                                                : Container(
                                                    alignment: Alignment.center,
                                                    child:
                                                        const CircularProgressIndicator())),
                                      ),
                                    ))
                                .toList()),
                      )
                    ],
                  ),
          ),
        ));
  }
  //
  // @override
  // bool get wantKeepAlive => true;
}
