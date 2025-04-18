abstract class AuthEvent {}
class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;

  AuthEventLogIn({required this.email, required this.password});
}
class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;

  AuthEventRegister({required this.email, required this.password});
}
class AuthEventLogout extends AuthEvent{
  AuthEventLogout();
}