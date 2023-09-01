import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ritammuddatask/controllers/providers.dart';
import 'package:ritammuddatask/views/authentication/login_view.dart';
import 'package:ritammuddatask/views/authentication/register_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final bool isOnLoginScreen = ref.watch(isOnLoginScreenProvider);

          return Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isOnLoginScreen
                        ? "Please enter your email and password to login"
                        : "Please enter your details to sign-up",
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () => ref
                        .watch(isOnLoginScreenProvider.notifier)
                        .state = !isOnLoginScreen,
                    child: Text(
                      isOnLoginScreen
                          ? "Don't have an account? Register here"
                          : "Already have an account? Login here",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  isOnLoginScreen ? const LoginView() : const RegisterView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
