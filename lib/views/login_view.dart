import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth-state.dart';
import 'package:fptapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:fptapp/blocs/auth_bloc/auth_event.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _errorMessage;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, Authstate>(
        listener: (context, state) {
          if (state is AuthStateLoggedIn) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home/', (_) => false);
          } else if (state is AuthStateEmailVerify) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/verify-email/', (_) => false);
          } else if (state is AuthStateError && state.error != null) {
            final snackBar = SnackBar(content: Text(state.error!));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              TextField(
                controller: _email,
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                  context.read<AuthBloc>().add(
                    AuthEventLogIn(email: email, password: password),
                  );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/register/', (route) => false);
                },
                child: const Text("Don't have anccount? Register here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
