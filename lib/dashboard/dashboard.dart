import 'package:fecipe/changepassword/changepassword.dart';
import 'package:fecipe/editprofile/edit_profile.dart';
import 'package:fecipe/view_all/view_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data_models/usermodel.dart';
import '../forgotpassword/forgotpassword.dart';
import '/auth/bloc/auth_bloc.dart';
import '/dashboard/bloc/dashboard_bloc.dart';
import '/dashboard/bloc/dashboard_states.dart';
import '../auth/bloc/auth_events.dart';
import '../auth/bloc/auth_states.dart';
import '/dashboard/profile_tile.dart';
import 'bloc/dashboard_events.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

late BuildContext appContext;

class _DashboardPageState extends State<DashboardPage> {
  getUserData() async {
    appContext = context;
    var user = UserModel(username: "", email: "", pfp: "");
    BlocProvider.of<DashboardBloc>(context).add(DashboardDataRequested(user));
    setState(() {});
  }

  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Center(
            child: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        )),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            child: Stack(
              children: [
                ClipPath(
                  clipper: CustomShape(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Center(
                    child: FutureBuilder(
                      future: getUserData(),
                      builder: (context, snapshot) =>
                          BlocBuilder<DashboardBloc, DashboardStates>(
                              builder: (context, state) {
                        if (state is DataLoadingState) {
                          return const CircularProgressIndicator();
                        } else if (state is DataLoadedState) {
                          return Column(children: [
                            Stack(
                              children: [
                                state.user.pfp == null
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'asset/images/default_profile.jpeg'),
                                              fit: BoxFit.cover),
                                        ),
                                      )
                                    : state is DataLoadingState
                                        ? Container()
                                        : Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    state.user.pfp!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              state.user.username,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.user.email,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ]);
                        } else if (state is DataErrorState) {
                          return Text(state.error);
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
              crossAxisCount: 2,
              children: [
                ProfileTile(
                  text: 'Change Password',
                  onpress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(),
                      ),
                    );
                  },
                  icon: Icons.password,
                ),
                ProfileTile(
                  text: 'Edit Profile',
                  onpress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ),
                    );
                  },
                  icon: Icons.edit,
                ),
                ProfileTile(
                  text: 'Settings',
                  onpress: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>  ViewAll(),
                    //   ),
                    // );
                  },
                  icon: Icons.settings,
                ),
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  return ProfileTile(
                    text: 'Logout',
                    onpress: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                    icon: Icons.logout,
                  );
                }),
              ],
            ),
          ),

          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
