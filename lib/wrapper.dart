import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ritammuddatask/controllers/auth_controller.dart';
import 'package:ritammuddatask/controllers/providers.dart';
import 'package:ritammuddatask/controllers/shared_pref.dart';
import 'package:ritammuddatask/models/user_model.dart';
import 'package:ritammuddatask/views/authentication/authentication_view.dart';
import 'package:ritammuddatask/views/home/home_view.dart';
import 'package:shimmer/shimmer.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget shimmerWelcome = Center(
      child: Shimmer.fromColors(
        baseColor: Colors.black87,
        highlightColor: Colors.black12,
        period: const Duration(seconds: 1),
        child: const Text(
          "Welcome",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) => FutureBuilder<Widget>(
          future: userIsLoggedIn(ref),
          initialData: shimmerWelcome,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? snapshot.data
                    : shimmerWelcome
                : shimmerWelcome;
          },
        ),
      ),
    );
  }

  Future<Widget> userIsLoggedIn(WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 1));
    final String? currentUser =
        await AuthController().currentUser().onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
      return null;
    });
    loadTheme(ref);
    if (LocalSharedPref.getLoggedIn() && currentUser != null) {
      return const HomeView();
    } else {
      return const AuthView();
    }
  }

  void loadTheme(WidgetRef ref) {
    final ThemeModel? theme = LocalSharedPref.getTheme();
    if (theme != null) {
      ref.watch(swatchColorProvider.notifier).state = theme.color;
      ref.watch(swatchBrightnessProvider.notifier).state =
          theme.dark ? Brightness.dark : Brightness.light;
    }
  }
}
