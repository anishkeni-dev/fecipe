abstract class ForgotPasswordEvent {}

class ForgotPasswordTextChangedEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordTextChangedEvent(this.email);
}

class ForgotPasswordSubmittedEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordSubmittedEvent(this.email);
}
