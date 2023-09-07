import '../../data_models/usermodel.dart';

abstract class SearchStates {}

class InitialState extends SearchStates {
  List<Object?> get props => [];
}

class LoadingState extends SearchStates {
  List<Object?> get props => [];
}

class LoadedState extends SearchStates {
  List<Object?> get props => [];
  final UserModel user;

  LoadedState(this.user);
}

class ErrorState extends SearchStates {
  final String error;

  ErrorState(this.error);
  List<Object?> get props => [error];
}
