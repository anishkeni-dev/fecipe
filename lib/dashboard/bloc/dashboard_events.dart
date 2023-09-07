
import '../../data_models/usermodel.dart';

abstract class DashboardEvents {
  List<Object> get props => [];
}

class DashboardDataRequested extends DashboardEvents {
  final UserModel user;
  DashboardDataRequested(this.user);
}

