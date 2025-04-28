import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:fptapp/blocs/musics/musics_bloc.dart';
import 'package:fptapp/blocs/news/news_bloc.dart';
import 'package:fptapp/blocs/notes/notes_bloc.dart';
import 'package:fptapp/views/login_view.dart';
import 'package:fptapp/views/main_page.dart';
import 'package:fptapp/views/musics_view.dart';
import 'package:fptapp/views/news_view.dart';
import 'package:fptapp/views/register_view.dart';
import 'package:fptapp/views/verify_email.dart';
import 'firebase_options.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
        BlocProvider<NotesBloc>(create: (context) => NotesBloc()),
        BlocProvider<NewsBloc>(create: (context) => NewsBloc()),
        BlocProvider<MusicBloc>(create: (context) => MusicBloc())
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // Set your preferred color
          foregroundColor: Colors.white, // For title/text/icon color
        ),
      ),
      home: const HomePage(),

      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/note-page/': (context) => MainPage(),
        '/verify-email/': (context) => const VerifyEmailView(),
        '/home/': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;

  final List<Widget> pages = [
   
    const NewsPage(),
    const MusicPage(),
     const MainPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[myIndex],
      bottomNavigationBar: Container(
        color: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          gap: 8,
          color: Colors.white,
          activeColor: Colors.white,
         
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          selectedIndex: myIndex,
          onTabChange: (index) {
            setState(() {
              myIndex = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
              backgroundColor: Colors.orange,
              
            ),
            GButton(
              icon: Icons.music_note,
              text: 'Music',
              backgroundColor: Colors.red
            ),
            GButton(
              icon: Icons.note,
              text: 'Notes',
              backgroundColor: Colors.green
            ),
          ],
        ),
      ),
    );
  }
}