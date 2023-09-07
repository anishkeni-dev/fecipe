
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_models/usermodel.dart';
import '../../repository/user_repository.dart';
import 'dashboard_events.dart';
import 'dashboard_states.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardStates> {
  DashboardBloc() : super(DataLoadingState()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<DashboardDataRequested>((event, emit) async {
      try {
        //getusername
          final userRepo = UserRepository();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? userid = prefs.getString('userId');
          UserModel user = await userRepo.getUserData(userid!);
          emit(DataLoadedState(user));

      } catch (e) {
        emit(DataErrorState(e.toString()));
        // print(e.toString());
      }
    });
  }



}