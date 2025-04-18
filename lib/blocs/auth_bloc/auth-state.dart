abstract class Authstate {}

class AuthStateLogginIn extends Authstate {
  AuthStateLogginIn();
}

class AuthStateEmailVerify extends Authstate {
  AuthStateEmailVerify();
}

class AuthStateLoggedIn extends Authstate {
  AuthStateLoggedIn();
}

class AuthStateError extends Authstate {
  final String? error;
  AuthStateError({this.error});
}

class AuthStateRegister extends Authstate {
  AuthStateRegister();
}

class AuthStateRegisterDone extends Authstate {
  AuthStateRegisterDone();
}
class AuthStateLogout extends Authstate {
  AuthStateLogout();
}

class AuthStateLogoutDone extends Authstate {
  AuthStateLogoutDone();
}
