import 'package:fecipe/userpreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_events.dart';
import '../auth/bloc/auth_states.dart';
import '../repository/user_repository.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final username = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  late String _errorMessage = "";

  final userRepo = Get.put(UserRepository());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            final userRepo = UserRepository();
            await userRepo.getUserId(_emailController.text);
            if (context.mounted) {
              Navigator.pushNamed(context, '/userPrefFromSignup');
            }
          }
          if (state is AuthError) {
            _errorMessage = state.error;
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          }
        },
        builder: (context, state) {
          if (state is UnAuthenticated || state is Loading) {
            // Displaying the sign up form if the user is not authenticated
            return SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10),
                    Image.asset(
                      "asset/images/signup.png",
                      height: 300,
                    ),
                    Text(
                      "Getting started!",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        "Looks like you are new here! Create an account for a complete experience.",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _errorMessage.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 0, bottom: 20),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ))
                        : Container(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: username,
                        decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            )),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)) {
                            return null;
                          } else {
                            return 'Enter a valid email';
                          }
                        },
                        style: const TextStyle(color: Colors.grey),
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            )),
                      ),
                    ),

                    SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (RegExp(
                                  r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$")
                              .hasMatch(value!)) {
                            return null;
                          } else {
                            return "Password must be min 6 characters, at least one uppercase letter, one lowercase letter and one number.";
                          }
                          // return value != null && value.length < 6
                          //     ? "Enter min. 6 characters"
                          //     : null;
                        },
                        style: const TextStyle(color: Colors.grey),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                                errorMaxLines: 3, // number of lines the error text would wrap 
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            )),
                      ),
                    ),

                    SizedBox(
                        height: MediaQuery.of(context).devicePixelRatio * 10),
                    //submit button
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(15),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () async {
                          _createAccountWithEmailAndPassword(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: state is Loading
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : const Text(
                                  'Next',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(
          username.text,
          _emailController.text,
          _passwordController.text,
        ),
      );
    }
  }
}
