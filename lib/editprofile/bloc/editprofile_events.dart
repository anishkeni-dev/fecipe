import '../../data_models/usermodel.dart';

abstract class EditProfileEvents {
  List<Object> get props => [];
}

class UserDataRequested extends EditProfileEvents {
  final UserModel user;
  UserDataRequested(this.user);
}
class UserDataUpdate extends EditProfileEvents {
  final UserModel user;
  UserDataUpdate(this.user);
}

class ProfilePictureUpload extends EditProfileEvents{
  final String imageUrl;

  ProfilePictureUpload(this.imageUrl);
  
}