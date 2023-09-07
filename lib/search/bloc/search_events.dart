import '../../data_models/usermodel.dart';

abstract class DashboardEvents {
  @override
  List<Object> get props => [];
}

class UsernameRequested extends DashboardEvents {
  final UserModel user;
  UsernameRequested(this.user);
}
