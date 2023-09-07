import '../../data_models/usermodel.dart';

abstract class EditProfileStates {}


class DataLoadingState extends EditProfileStates {

  List<Object?> get props => [];
}

class DataLoadedState extends EditProfileStates {
  List<Object?> get props => [];
  final UserModel user;
  DataLoadedState(this.user);
}

// class ProfilePictureUploaded extends EditProfileStates{
//   final UserModel user;
//   ProfilePictureUploaded(this.user);
// }
// class ProfilePictureUploading extends EditProfileStates{
//
// }

class DataErrorState extends EditProfileStates {
  final String error;

  DataErrorState(this.error);
  List<Object?> get props => [error];
}
class VerifyWithPasswordState extends EditProfileStates {

}
class VerifiedState extends EditProfileStates {

}



