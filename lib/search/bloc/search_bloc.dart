import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/search/bloc/search_events.dart';
import '/search/bloc/search_states.dart';
import '../../data_models/usermodel.dart';
import '../../repository/user_repository.dart';

class SearchPageBloc extends Bloc<DashboardEvents, SearchStates> {
  SearchPageBloc() : super(LoadingState()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<UsernameRequested>((event, emit) async {
      try {
        //getusername
        final userRepo = UserRepository();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? userid = prefs.getString('userId');
        UserModel user = await userRepo.getUserData(userid!);

        emit(LoadedState(user));
      } catch (error) {
        emit(ErrorState(error.toString()));
        print(error.printError);
      }
    });
  }
}
