import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/bloc/auth_events.dart';
import '/dashboard/bloc/dashboard_events.dart';
import '../auth/bloc/auth_bloc.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/dashboard.dart';
import '../data_models/usermodel.dart';
import 'bloc/editprofile_bloc.dart';
import 'bloc/editprofile_events.dart';
import 'bloc/editprofile_states.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool usernameIsEnable = false;
  bool emailIsEnable = false;
  String imageUrl = '';
  getUserData() async {
    appContext = context;
    var user = UserModel(username: "", email: "", pfp: "");
    BlocProvider.of<EditProfileBloc>(context).add(UserDataRequested(user));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        title: const SizedBox(
            child: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        )),
        elevation: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: CustomShape(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Center(
                child: FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) =>
                      BlocBuilder<EditProfileBloc, EditProfileStates>(
                          builder: (context, state) {
                    if (state is DataLoadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is DataLoadedState) {
                      userNameController =
                          TextEditingController(text: state.user.username);
                      emailController =
                          TextEditingController(text: state.user.email);
                      return Column(children: [
                        Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: Stack(
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
                                              image:
                                                  NetworkImage(state.user.pfp!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  width: MediaQuery.of(context).size.height *
                                      0.045,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: IconButton(
                                      alignment: Alignment.center,
                                      onPressed: () {
                                        BlocProvider.of<EditProfileBloc>(
                                                context)
                                            .add(
                                                ProfilePictureUpload(imageUrl));
                                      },
                                      color: Colors.white,
                                      icon: Icon(
                                        state.user.pfp == null
                                            ? Icons.add_a_photo
                                            : Icons.edit,
                                        color: Colors.black26,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                ),
                                controller: userNameController,
                                enabled: emailIsEnable,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    emailIsEnable = true;
                                  });
                                })
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                ),
                                controller: emailController,
                                enabled: usernameIsEnable,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    usernameIsEnable = true;
                                  });
                                })
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(15),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: () {
                              var tempUser = UserModel(
                                  username: userNameController.text,
                                  email: emailController.text,
                                  pfp: state.user.pfp);
                              BlocProvider.of<AuthBloc>(context)
                                  .add(UpdateEmail(emailController.text));
                              BlocProvider.of<EditProfileBloc>(context)
                                  .add(UserDataUpdate(tempUser));
                              BlocProvider.of<DashboardBloc>(context)
                                  .add(DashboardDataRequested(tempUser));

                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]);
                    } else if (state is DataErrorState) {
                      return Text(state.error);
                    } else {
                      return Container();
                    }
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
