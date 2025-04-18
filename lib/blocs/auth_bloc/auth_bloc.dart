import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth-state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, Authstate> {
  AuthBloc() : super(AuthStateLogginIn()) {
    on<AuthEventLogIn>((event, emit) async {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.emailVerified) {
          emit(AuthStateLoggedIn()); // Create this if needed
        } else {
          emit(AuthStateEmailVerify()); // Create this state too
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthStateError(error: e.message));
      } catch (_) {
        emit(AuthStateError(error: 'Unknown error occurred'));
      }
    });
  }
}

class AuthBlocRegister extends Bloc<AuthEvent, Authstate> {
  AuthBlocRegister() : super(AuthStateRegister()) {
    on<AuthEventRegister>((event, emit) async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );

        emit(AuthStateRegisterDone()); // Create this if needed
      } on FirebaseAuthException catch (e) {
        String errorMessage; 

        if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is invalid.';
        } else {
          errorMessage = 'Registration failed. ${e.message}';
        }

        emit(AuthStateError(error: errorMessage));
      } catch (_) {
        emit(AuthStateError(error: 'Unknown error occurred'));
      }
    });
  }
}

class AuthBlocLogout extends Bloc<AuthEvent, Authstate> {
  AuthBlocLogout() : super(AuthStateLogout()) {
    on<AuthEventLogout>((event, emit) async {
      try {
        await FirebaseAuth.instance.signOut();
        emit(AuthStateLogoutDone());
      } on FirebaseAuthException catch (e) {
        emit(AuthStateError(error: e.message ?? 'Logout failed'));
      } catch (_) {
        emit(AuthStateError(error: 'Unknown error occured'));
      }
    });
  }
}

