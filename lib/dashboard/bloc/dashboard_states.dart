import '../../data_models/usermodel.dart';

abstract class DashboardStates {}

class InitialState extends DashboardStates {
  List<Object?> get props => [];
}

class DataLoadingState extends DashboardStates {
  List<Object?> get props => [];
}

class DataLoadedState extends DashboardStates {
  List<Object?> get props => [];
  final UserModel user;
  DataLoadedState(this.user);
}

// class ProfilePictureUploaded extends DashboardStates{
//   final UserModel user;
//   ProfilePictureUploaded(this.user);
// }
// class ProfilePictureUploading extends DashboardStates{
//
// }

class DataErrorState extends DashboardStates {
  final String error;

  DataErrorState(this.error);
  List<Object?> get props => [error];
}
