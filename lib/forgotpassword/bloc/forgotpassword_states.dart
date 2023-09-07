import 'package:flutter/material.dart';

class ForgotPasswordState extends StatelessWidget {
  const ForgotPasswordState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ForgotPasswordInitialState extends ForgotPasswordState {
  const ForgotPasswordInitialState({super.key});
}

class ForgotPasswordValidState extends ForgotPasswordState {
  final String validity;

  const ForgotPasswordValidState(this.validity, {super.key});
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String errormessage;

  const ForgotPasswordErrorState(this.errormessage, {super.key});
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  const ForgotPasswordLoadingState({super.key});
}
