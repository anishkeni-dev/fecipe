import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/forgotpassword/bloc/forgotpassword_bloc.dart';
import '/forgotpassword/bloc/forgotpassword_events.dart';
import '/forgotpassword/bloc/forgotpassword_states.dart';
import '/resetpassword/resetpassword.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final email = TextEditingController();
  final verificationCode = TextEditingController();
  bool emailVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: emailVerified
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter 6 digits code",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      "Please enter the 6 digit verification code that was sent to '${email.text}'.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.grey),
                      controller: verificationCode,
                      onChanged: (value) {
                        BlocProvider.of<ForgotPasswordBloc>(context)
                            .add(ForgotPasswordTextChangedEvent(email.text));
                      },
                      decoration: InputDecoration(
                          hintText: 'Verification Code',
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 2),
                          )),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).devicePixelRatio * 10),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      builder: (context, state) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(15),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Verify',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    );
                  }),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forgot your password?",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      "Please enter your email to receive a verification code.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      builder: (context, state) {
                    if (state is ForgotPasswordErrorState) {
                      return Text(
                        state.errormessage,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      );
                    } else {
                      return Container();
                    }
                  }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.grey),
                      controller: email,
                      // enabled: emailVerified ? false : true,
                      onChanged: (value) {
                        BlocProvider.of<ForgotPasswordBloc>(context)
                            .add(ForgotPasswordTextChangedEvent(email.text));
                      },
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 2),
                          )),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).devicePixelRatio * 10),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      builder: (context, state) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(15),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {
                          BlocProvider.of<ForgotPasswordBloc>(context)
                              .add(ForgotPasswordTextChangedEvent(email.text));
                          if (state is ForgotPasswordValidState) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            BlocProvider.of<ForgotPasswordBloc>(context)
                                .add(ForgotPasswordSubmittedEvent(email.text));
                            emailVerified = true;
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
