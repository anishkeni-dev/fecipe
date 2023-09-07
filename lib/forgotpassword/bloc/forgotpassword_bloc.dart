import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgotpassword_events.dart';
import 'forgotpassword_states.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordInitialState()) {
    on<ForgotPasswordTextChangedEvent>((event, emit) {
      if (event.email.isNotEmpty &&
          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(event.email)) {
        emit(const ForgotPasswordValidState("Email is valid"));
      } else if (event.email.isEmpty) {
        emit(const ForgotPasswordErrorState("Please enter a valid email"));
      }
    });

    on<ForgotPasswordSubmittedEvent>((event, emit) async {
      if (state is ForgotPasswordValidState) {
        //await Auth
        final String status = await verifyEmail(email: event.email);
        if (status == 'OTP sent') {
          //email verified
        } else {
          //email verification failed
        }
      }
    });
  }
}

Future<String> verifyEmail({required String email}) async {
  await Future.delayed(const Duration(seconds: 4));
  return 'OTP Sent';
}
