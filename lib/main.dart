import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:fptapp/views/login_view.dart';
import 'package:fptapp/views/main_page.dart';
import 'package:fptapp/views/register_view.dart';
import 'package:fptapp/views/verify_email.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
      BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      BlocProvider<AuthBlocRegister>(create: (context) => AuthBlocRegister()),
      BlocProvider<AuthBlocLogout>(create: (context) => AuthBlocLogout()),
      ],
      
      child: const FPTMaterials(),
    ),
  );
}

class FPTMaterials extends StatelessWidget {
  const FPTMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple, // Set your preferred color
          foregroundColor: Colors.white, // For title/text/icon color
        ),
      ),
      home: const HomePage(),

      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/main-page/': (context) => MainPage(),
        '/verify-email/': (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginView(); // just go straight to login now
  }
}
